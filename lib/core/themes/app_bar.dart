import 'package:flutter/material.dart';
import 'colors.dart';
import 'icon.dart';
import 'text.dart';

class AppBarStyles {
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    iconTheme: AppIconThemes.appBarIcon,
    titleTextStyle: AppTextStyles.textStyle(AppColors.accentBlue, 16, true),
  );
}
