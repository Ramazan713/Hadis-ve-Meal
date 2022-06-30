import 'package:equatable/equatable.dart';
import 'package:hadith/db/entities/user_info_entity.dart';

abstract class IUserInfoEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserInfoEventRequest extends IUserInfoEvent{
  final String userId;
  UserInfoEventRequest({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class UserInfoEventDelete extends IUserInfoEvent{
  final String userId;
  UserInfoEventDelete({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class UserInfoEventInsert extends IUserInfoEvent{
  final UserInfoEntity userInfoEntity;

  UserInfoEventInsert({required this.userInfoEntity});

  @override
  List<Object?> get props => [userInfoEntity];
}
