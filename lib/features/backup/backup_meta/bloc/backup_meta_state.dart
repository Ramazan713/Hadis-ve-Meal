import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/backup_meta.dart';

class BackupMetaState extends Equatable{

  final DataStatus status;
  final List<BackupMeta>backupMetas;

  const BackupMetaState({required this.status,required this.backupMetas});

  BackupMetaState copyWith({DataStatus? status,List<BackupMeta>?backupMetas}){
    return BackupMetaState(status: status??this.status, backupMetas: backupMetas??this.backupMetas);
  }

  @override
  List<Object?> get props => [status,backupMetas];
}