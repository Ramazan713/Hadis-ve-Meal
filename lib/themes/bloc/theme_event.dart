
import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/theme_enum.dart';

abstract class IThemeEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ThemeEventChangeTheme extends IThemeEvent{
  final ThemeTypesEnum themeEnum;

  ThemeEventChangeTheme({required this.themeEnum});

  @override
  List<Object?> get props => [themeEnum];
}

class ThemeEventRequest extends IThemeEvent{}
