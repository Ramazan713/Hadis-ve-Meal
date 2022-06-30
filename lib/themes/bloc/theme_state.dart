

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/theme_enum.dart';

class ThemeState extends Equatable{

  final DataStatus status;
  final ThemeTypesEnum themeEnum;

  const ThemeState({required this.status,required this.themeEnum});

  ThemeState copyWith({DataStatus? status,ThemeTypesEnum? themeEnum}){
    return ThemeState(status: status??this.status, themeEnum: themeEnum??this.themeEnum);
  }

  @override
  List<Object?> get props => [status,themeEnum];

}
