

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/backup_meta.dart';

import '../entities/helper/int_data.dart';

@dao
abstract class BackupMetaDao{

  @Query("""select * from backupMeta where isAuto=0 order by updatedDate desc limit :limit offset :offset""")
  Future<List<BackupMeta>>getNonAutoBackupMetaWithOffset(int limit,int offset);

  @Query("""select * from backupMeta where isAuto=1 order by updatedDate desc limit :limit offset :offset""")
  Future<List<BackupMeta>>getAutoBackupMetaWithOffset(int limit,int offset);

  @Query("""select count(*) data from backupMeta where isAuto=0""")
  Future<IntData?>getNonAutoBackupMetaSize();

  @Query("""select count(*) data from backupMeta where isAuto=1""")
  Future<IntData?>getAutoBackupMetaSize();

  @Query("""select * from backupMeta where isAuto=1 order by updatedDate limit 1""")
  Future<BackupMeta?>getFirstUpdatedAutoBackupMeta();

  @Query("""select * from backupMeta where isAuto=0 order by updatedDate limit 1""")
  Future<BackupMeta?>getFirstUpdatedNonAutoBackupMeta();

  @Query("""select * from backupMeta order by updatedDate desc""")
  Stream<List<BackupMeta>>getStreamBackupMetas();
  
  @Query("""select * from backupMeta order by updatedDate desc limit 1""")
  Future<BackupMeta?>getLastBackupMeta();


  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertBackupMetas(List<BackupMeta>backupMetas);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertBackupMeta(BackupMeta backupMeta);


  @Update()
  Future<int>updateBackupMetas(List<BackupMeta>backupMetas);

  @Update()
  Future<int>updateBackupMeta(BackupMeta backupMeta);

  @Query("""delete from backupMeta""")
  Future<void>deleteBackupMetaWithQuery();

  @delete
  Future<int>deleteBackupMeta(BackupMeta backupMeta);

  @delete
  Future<int>deleteBackupMetas(List<BackupMeta>backupMetas);


}