import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/user_info_entity.dart';

class UserInfoState extends Equatable{
  final DataStatus status;
  final UserInfoEntity? userInfoEntity;

  const UserInfoState({required this.status,this.userInfoEntity});

  UserInfoState copyWith({DataStatus? status,UserInfoEntity? userInfoEntity,bool keepOldEntity=true}){
    return UserInfoState(status: status??this.status,
        userInfoEntity: keepOldEntity?userInfoEntity??this.userInfoEntity:userInfoEntity);
}

  @override
  List<Object?> get props => [status,userInfoEntity];


}