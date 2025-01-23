import 'package:flutter/material.dart';
import 'colors.dart';
import 'icon.dart';
import 'text.dart';

class AppBarStyles {
  final bool isDarkMode;

  AppBarStyles(this.isDarkMode);

  AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: isDarkMode
        ? AppColors.DarkModeBackground_lv3
        : AppColors.LightModeBackground_lv3,
    iconTheme: AppIconThemes(isDarkMode).appBarIcon,
    titleTextStyle: AppTextStyles(isDarkMode).titleSmall.copyWith(
      color: AppColors.PrimaryColor,
    ),
  );
}
