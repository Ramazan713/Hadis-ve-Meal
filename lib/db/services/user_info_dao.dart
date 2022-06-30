

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/user_info_entity.dart';

@dao
abstract class UserInfoDao{

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertUserInfo(UserInfoEntity userInfoEntity);

  @Update()
  Future<int>updateUserInfo(UserInfoEntity userInfoEntity);

  @delete
  Future<int>deleteUserInfo(UserInfoEntity userInfoEntity);

  @Query("""select * from userInfo where userId=:userId""")
  Stream<UserInfoEntity?>getStreamUserInfoWithId(String userId);

  @Query("""select * from userInfo where userId=:userId""")
  Future<UserInfoEntity?>getUserInfoWithId(String userId);


  @Query("""delete from userInfo""")
  Future<void>deleteAllDataWithQuery();


}