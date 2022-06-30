import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hadith/constants/app_constants.dart';
import 'package:hadith/constants/enums/backup_meta_control.dart';
import 'package:hadith/db/entities/backup_meta.dart';
import 'package:hadith/db/entities/user_info_entity.dart';
import 'package:hadith/db/repos/backup_meta_repo.dart';
import 'package:hadith/db/repos/backup_repo.dart';
import 'package:hadith/models/resource.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_bloc.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_event.dart';
import 'package:hadith/services/connectivity_service.dart';
import 'package:hadith/services/storage_service.dart';
import 'package:hadith/utils/loading_util.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CloudBackupManager{

  late final BackupRepo _backupRepo;
  late final BackupMetaRepo _backupMetaRepo;
  final BuildContext context;
  final Uuid uuid=const Uuid();

  CloudBackupManager({required this.context}){
    _backupMetaRepo=context.read<BackupMetaRepo>();
    _backupRepo=context.read<BackupRepo>();

  }


  Future<T?>_checkConnectionAndResult<T>(Future<T>Function()func,{String? successMessage})async{
    if(await ConnectivityService().isConnectInternet()){
      LoadingUtil.requestLoading(context);

      final result=await func.call();
      if(result is ResourceSuccess){
        ToastUtils.showLongToast(successMessage??"Başarılı");
      }else if(result is ResourceError){
        ToastUtils.showLongToast(result.error);
      }else{
        ToastUtils.showLongToast("Bir şeyler yanlış gitti");
      }
      LoadingUtil.requestCloseLoading(context);
      return result;
    }else{
      ToastUtils.showLongToast("İnternet bağlantınızı kontrol ediniz");
    }
    return null;
  }

  Future<void>_checkRedundantBackupMetas(Future<List<BackupMeta>> Function(int, int) redundantBackupFunc,
      BackupMetaControl backupMetaControl,StorageService storageService,int offset,int limit)async{
    if(backupMetaControl==BackupMetaControl.delete){
      if(limit>0){
        final redundantBackups=await redundantBackupFunc(limit,offset);
        for(var backup in redundantBackups){
          await storageService.deleteFile(backup.fileName);
        }
        await _backupMetaRepo.deleteBackupMetas(redundantBackups);
      }
    }
  }



  Future<void>logInDownloadFiles(User user,UserInfoBloc userInfoBloc,{void Function(int)?completeListener})async{
    await _checkConnectionAndResult(() async{
      final storageService=StorageService(user: user);
      final resourceFiles=await storageService.getFiles();
      if(resourceFiles is ResourceSuccess<List<BackupMeta>>){
        final results=await _backupMetaRepo.insertBackupMetas(resourceFiles.data);

        final photoData=await _downloadUserPhoto(user);
        userInfoBloc.add(UserInfoEventInsert(userInfoEntity: UserInfoEntity(
          userId: user.uid,
          img: photoData
        )));

        final controlBackup=await _backupMetaRepo.controlNonAutoBackups();
        _checkRedundantBackupMetas(_backupMetaRepo.getNonAutoBackupMetaWithOffset,controlBackup,
          storageService,kNonAutoMaxBackups,resourceFiles.data.length-kNonAutoMaxBackups);

        final controlBackupAuto=await _backupMetaRepo.controlAutoBackups();
        _checkRedundantBackupMetas(_backupMetaRepo.getAutoBackupMetaWithOffset,controlBackupAuto,
            storageService,kAutoMaxBackups,resourceFiles.data.length-kAutoMaxBackups);
        completeListener?.call(results.length);
      }
      return resourceFiles;
    });
  }

  Future<void> refreshFiles(User user)async{
    await _checkConnectionAndResult(()async{
      final storageService=StorageService(user: user);
      final filesResource=await storageService.getFiles();
      if(filesResource is ResourceSuccess<List<BackupMeta>>){
        await _backupMetaRepo.deleteBackupMetaWithQuery();
        await _backupMetaRepo.insertBackupMetas(filesResource.data);
      }
      return filesResource;
    });

  }

  Future<void>logOutRemoveFiles(User user,UserInfoBloc userInfoBloc)async{
    await _backupMetaRepo.deleteBackupMetaWithQuery();
    await _backupRepo.deleteAllData();
    userInfoBloc.add(UserInfoEventDelete(userId: user.uid));
  }

  Future<void>deleteAllData(BuildContext context,{void Function()?listener})async{
    LoadingUtil.requestLoading(context);
    await _backupRepo.deleteAllData();
    LoadingUtil.requestCloseLoading(context);
    listener?.call();
    _refreshApp(context);
  }

  Future<void>downloadLastBackup(User user)async{
    await _checkConnectionAndResult(()async{
      final backupMeta=await _backupMetaRepo.getLastBackupMeta();
      if(backupMeta!=null){
        await downloadFile(backupMeta.fileName, user, true);
        return Resource.success("başarılı");
      }
      return Resource.error("bir şeyler yanlış gitti");
    });
  }

  Future<void>downloadFile(String fileName,User user,bool deleteAllData)async{
    await _checkConnectionAndResult(()async{

      final storageService=StorageService(user: user);
      var result=await storageService.getFileData(fileName);

      if(result is ResourceSuccess<Uint8List?>&&result.data!=null){
        await _backupRepo.extractDataFromUint8List(result.data!,listenerBeforeInsertion: ()async{
          if(deleteAllData){
            await _backupRepo.deleteAllData();
          }
        },listenerComplete: (isComplete){
          if(!isComplete){
            result = Resource.error("bir şeyler yanlış gitti");
          }else{
            _refreshApp(context);
          }
        });
      }
      return result;
    });
  }


  Future<void>uploadAutoBackup(User user,void Function(bool)?callback)async{
    await _checkConnectionAndResult(()async {
      final storageService=StorageService(user: user);
      final controlBackup=await _backupMetaRepo.controlAutoBackups();
      return await _uploadDataWithMeta(controlBackup,_backupMetaRepo.getFirstUpdatedAutoBackupMeta,
          storageService,true);
    }).then((value){
      callback?.call(value is ResourceSuccess<BackupMeta>);
    });
  }

  Future<Resource<BackupMeta>?> _uploadDataWithMeta(BackupMetaControl controlBackup,
      Future<BackupMeta?> Function() metaFunc,StorageService storageService,bool isAuto)async{

    Resource<BackupMeta>? result;

    switch(controlBackup){
      case BackupMetaControl.delete:
      case BackupMetaControl.fixed:
        final backupMeta=await metaFunc.call();
        final rawData=await _backupRepo.getUint8ListData();
        if(backupMeta!=null){
          result=await storageService.uploadData(backupMeta.fileName,
              rawData,isAuto: backupMeta.isAuto);
          if(result is ResourceSuccess<BackupMeta>){
            await _backupMetaRepo.updateBackupMeta(result.data.copyWith(id: backupMeta.id
                ,keepOldId: true));
          }
        }
        break;
      case BackupMetaControl.insert:
        final name=uuid.v4();
        final rawData=await _backupRepo.getUint8ListData();
        result=await storageService.uploadData(name, rawData,isAuto: isAuto);
        if(result is ResourceSuccess<BackupMeta>){
          await _backupMetaRepo.insertBackupMeta(result.data);
        }
        break;
      case BackupMetaControl.none:
        break;
    }
    return result;
  }


  Future<void>uploadBackup(User user)async{
   await _checkConnectionAndResult(()async {
     final storageService=StorageService(user: user);
     final controlBackup=await _backupMetaRepo.controlNonAutoBackups();

     return await _uploadDataWithMeta(controlBackup,_backupMetaRepo.getFirstUpdatedNonAutoBackupMeta,
          storageService,false);
   });
  }

  Future<Uint8List?>_downloadUserPhoto(User user)async{
    if(user.photoURL!=null){
      final uri = Uri.parse(user.photoURL!);
      final result=await http.get(uri);
      return result.bodyBytes;
    }
    return null;
  }

  void _refreshApp(BuildContext context){
    Navigator.pop(context);
    Phoenix.rebirth(context);
  }

}