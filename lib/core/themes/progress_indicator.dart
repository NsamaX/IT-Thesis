import 'package:flutter/material.dart';
import 'colors.dart';

class AppProgressIndicatorStyles {
  final bool isDarkMode;

  AppProgressIndicatorStyles(this.isDarkMode);

  ProgressIndicatorThemeData get progressIndicatorTheme {
    return ProgressIndicatorThemeData(
      color: AppColors.PrimaryColor,
      refreshBackgroundColor: isDarkMode
          ? AppColors.DarkModeBackground_lv3
          : AppColors.LightModeBackground_lv3,
      circularTrackColor: isDarkMode
          ? AppColors.DarkModeBackground_lv2
          : AppColors.LightModeBackground_lv2,
    );
  }
}
