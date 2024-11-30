import 'package:flutter/material.dart';
import 'colors.dart';
import 'icon.dart';
import 'text.dart';

class AppBarStyles {
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.DarkModeBackground_lv3,
    iconTheme: AppIconThemes.appBarIcon,
    titleTextStyle: AppTextStyles.textStyle(AppColors.PrimaryColor, 16, true),
  );
}
