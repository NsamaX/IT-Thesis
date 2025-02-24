import 'package:flutter/material.dart';
import 'colors.dart';

class AppProgressIndicatorStyles {
  final bool isDarkMode;

  AppProgressIndicatorStyles(this.isDarkMode);

  ProgressIndicatorThemeData get progressIndicatorTheme => ProgressIndicatorThemeData(
    color: AppColors.PrimaryColor,
    refreshBackgroundColor: backgroundColor,
    circularTrackColor: trackColor,
  );

  Color get backgroundColor => isDarkMode
      ? AppColors.DarkModeBackground_lv3
      : AppColors.LightModeBackground_lv3;

  Color get trackColor => isDarkMode
      ? AppColors.DarkModeBackground_lv2
      : AppColors.LightModeBackground_lv2;
}
