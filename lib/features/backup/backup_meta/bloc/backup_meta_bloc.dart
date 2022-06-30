import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/backup_meta.dart';
import 'package:hadith/db/repos/backup_meta_repo.dart';
import 'package:hadith/features/backup/backup_meta/bloc/backup_meta_event.dart';
import 'package:hadith/features/backup/backup_meta/bloc/backup_meta_state.dart';

class BackupMetaBloc extends Bloc<IBackupMetaEvent,BackupMetaState>{
  final BackupMetaRepo backupMetaRepo;

  BackupMetaBloc({required this.backupMetaRepo}) :
        super(const BackupMetaState(status: DataStatus.initial, backupMetas: [])){
    on<BackupMetaEventRequest>(_onRequestData,transformer: restartable());
    on<BackupMetaEventLoadingState>(_onLoading,transformer: restartable());
    on<BackupMetaEventSuccessState>(_onSuccess,transformer: restartable());

  }

  void _onRequestData(BackupMetaEventRequest event,Emitter<BackupMetaState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    final dataStream=backupMetaRepo.getStreamBackupMetas();


    await emit.forEach<List<BackupMeta>>(dataStream, onData: (data)=>
        state.copyWith(status: DataStatus.success,backupMetas: data));
  }

  void _onLoading(BackupMetaEventLoadingState event,Emitter<BackupMetaState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
  }

  void _onSuccess(BackupMetaEventSuccessState event,Emitter<BackupMetaState>emit)async{
    emit(state.copyWith(status: DataStatus.success));
  }


}