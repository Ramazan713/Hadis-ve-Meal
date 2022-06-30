

import 'package:hadith/db/entities/user_info_entity.dart';
import 'package:hadith/db/services/user_info_dao.dart';

class UserInfoRepo{
  final UserInfoDao userInfoDao;

  UserInfoRepo({required this.userInfoDao});

  Future<int>insertUserInfo(UserInfoEntity userInfoEntity)=>
      userInfoDao.insertUserInfo(userInfoEntity);

  Future<int>updateUserInfo(UserInfoEntity userInfoEntity)=>
      userInfoDao.updateUserInfo(userInfoEntity);

  Stream<UserInfoEntity?>getStreamUserInfoWithId(String userId)=>
      userInfoDao.getStreamUserInfoWithId(userId);

  Future<UserInfoEntity?>getUserInfoWithId(String userId)=>
      userInfoDao.getUserInfoWithId(userId);

  Future<void>deleteAllDataWithQuery()=>
      userInfoDao.deleteAllDataWithQuery();

  Future<int>deleteUserInfo(UserInfoEntity userInfoEntity)=>
      userInfoDao.deleteUserInfo(userInfoEntity);

}