import 'package:flutter/material.dart';
import 'package:hadith/utils/theme_util.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:settings_ui/src/utils/theme_provider.dart';

SettingsThemeData? getSettingThemeData(BuildContext context) {
  final tm = Theme.of(context);

  return ThemeUtil.getThemeMode() == ThemeMode.light
      ? null
      : ThemeProvider.getTheme(
              context: context,
              platform: DevicePlatform.android,
              brightness: Brightness.dark)
          .copyWith(
              settingsSectionBackground: tm.scaffoldBackgroundColor,
              settingsListBackground: tm.scaffoldBackgroundColor);
}
