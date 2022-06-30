import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hadith/constants/app_constants.dart';
import 'package:hadith/db/entities/backup_meta.dart';
import 'package:hadith/models/resource.dart';

class StorageService{
  late final Reference rootRef;
  final storage=FirebaseStorage.instance;
  final User user;

  StorageService({required this.user}){
    rootRef=storage.ref("Backups/${user.uid}/");
  }

  BackupMeta _getBackupMeta(FullMetadata fullMetadata){
    return BackupMeta(
        fileName: fullMetadata.name,
        updatedDate: fullMetadata.updated?.toString()??"",
        isAuto: fullMetadata.customMetadata?["isAuto"]=="true"?true:false
    );
  }

  Future<Resource<List<BackupMeta>>>getFiles()async{
    return await _errorHandling<List<BackupMeta>>(()async{
      final backupMetas = <BackupMeta>[];

      final listResult=await rootRef.listAll().timeout(const Duration(seconds: kTimeOutSeconds));
      for(var resultRef in listResult.items){
        final metadata=await resultRef.getMetadata();
        backupMetas.add(_getBackupMeta(metadata));
      }
      return backupMetas;
    });
  }

  Future<Resource<T>> _errorHandling<T>(Future<T> Function() func)async{
    try{
      return Resource.success(await func.call());
    }catch(e){
      return Resource.error("Bir şeyler yanlış gitti");
    }
  }

  Future<Resource<Uint8List?>>getFileData(String name){
    return _errorHandling<Uint8List?>(()async{
      final rawData=await rootRef.child(name).getData().timeout(const Duration(seconds: kTimeOutSeconds));
      return rawData;
    });

  }

  Future<Resource<BackupMeta>>uploadData(String name,Uint8List rawData,{bool isAuto=false})async{
    return await _errorHandling<BackupMeta>(()async{
      final result=await rootRef.child(name).putData(rawData,SettableMetadata(
          customMetadata: {
            "isAuto":isAuto.toString()
          }
      )).timeout(const Duration(seconds: kTimeOutSeconds));
      if(result.state==TaskState.success&&result.metadata!=null){
        return _getBackupMeta(result.metadata!);
      }
      throw Exception("bazı hatalar oluştu");
    });
  }

  Future<void>deleteFile(String name)async{
    await _errorHandling(() async{
      await rootRef.child(name).delete().timeout(const Duration(seconds: kTimeOutSeconds));
    });
  }

}