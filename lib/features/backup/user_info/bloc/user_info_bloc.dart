import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/user_info_entity.dart';
import 'package:hadith/db/repos/user_info_repo.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_event.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_state.dart';

class UserInfoBloc extends Bloc<IUserInfoEvent,UserInfoState>{
  final UserInfoRepo userInfoRepo;
  UserInfoBloc({required this.userInfoRepo}) : super(const UserInfoState(status: DataStatus.initial)){
    on<UserInfoEventRequest>(_onRequestData,transformer: droppable());
    on<UserInfoEventDelete>(_onDeleteAll,transformer: restartable());
    on<UserInfoEventInsert>(_onInsertData,transformer: restartable());
  }

  void _onRequestData(UserInfoEventRequest event,Emitter<UserInfoState>emit)async{
    emit(state.copyWith(status: DataStatus.loading,keepOldEntity: true));
    await emit.forEach<UserInfoEntity?>(userInfoRepo.getStreamUserInfoWithId(event.userId)
        , onData: (data)=>state.copyWith(status: DataStatus.success,userInfoEntity: data,
            keepOldEntity: false));
  }

  void _onDeleteAll(UserInfoEventDelete event,Emitter<UserInfoState>emit)async{
    final userInfo=await userInfoRepo.getUserInfoWithId(event.userId);
    if(userInfo!=null) {
      await userInfoRepo.deleteUserInfo(userInfo);
    }
  }

  void _onInsertData(UserInfoEventInsert event,Emitter<UserInfoState>emit)async{
    await userInfoRepo.insertUserInfo(event.userInfoEntity);
  }

}