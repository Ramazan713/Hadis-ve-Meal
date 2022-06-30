import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/theme_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/themes/bloc/theme_event.dart';
import 'package:hadith/themes/bloc/theme_state.dart';
import 'package:hadith/utils/theme_util.dart';
import 'package:hadith/utils/localstorage.dart';

class ThemeBloc extends Bloc<IThemeEvent,ThemeState>{
  ThemeBloc() :
        super(ThemeState(status: DataStatus.initial,
          themeEnum: ThemeUtil.getThemeEnum())){
    on<ThemeEventChangeTheme>(_onSetTheme,transformer: restartable());
    on<ThemeEventRequest>(_onRequestTheme,transformer: restartable());
  }

  void _onRequestTheme(ThemeEventRequest event,Emitter<ThemeState>emit)async{
    final ThemeTypesEnum themeEnum = ThemeUtil.getThemeEnum();
    emit(state.copyWith(status: DataStatus.success,themeEnum: themeEnum));
  }

  void _onSetTheme(ThemeEventChangeTheme event,Emitter<ThemeState>emit)async{
    final sharedPreferences=LocalStorage.sharedPreferences;
    sharedPreferences.setInt(PrefConstants.themeTypeEnum.key, event.themeEnum.index);
    emit(state.copyWith(status: DataStatus.success,themeEnum: event.themeEnum));
  }

}