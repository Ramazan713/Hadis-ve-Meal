import 'package:equatable/equatable.dart';

abstract class IBackupMetaEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class BackupMetaEventRequest extends IBackupMetaEvent{}

class BackupMetaEventLoadingState extends IBackupMetaEvent{}

class BackupMetaEventSuccessState extends IBackupMetaEvent{}





