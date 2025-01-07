import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'button.dart';
import 'colors.dart';
import 'icon.dart';
import 'nav_bar.dart';
import 'progress_indicator.dart';
import 'text.dart';

ThemeData themeData() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.DarkModeBackground_lv2,
    primaryColor: AppColors.DarkModeBackground_lv1,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.PrimaryColor,
      onPrimary: AppColors.LightModeBackground_lv1,
      secondary: AppColors.SecondaryColor,
      onSecondary: AppColors.DarkModeBackground_lv1,
      surface: AppColors.DarkModeBackground_lv2,
      onSurface: AppColors.LightModeBackground_lv1,
      error: Colors.red.shade400,
      onError: Colors.white,
    ),
    iconTheme: AppIconThemes.defaultIcon,
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
    ),
    appBarTheme: AppBarStyles.appBarTheme,
    bottomNavigationBarTheme: AppBottomNavBarStyles.bottomNavBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.elevatedButton,
    ),
    progressIndicatorTheme: AppProgressIndicatorStyles.progressIndicatorTheme,
  );
}
