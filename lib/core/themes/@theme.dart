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
    scaffoldBackgroundColor: AppColors.backgroundMedium,
    primaryColor: AppColors.backgroundDark,
    secondaryHeaderColor: AppColors.accentBlue,
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
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: AppButtonStyles.elevatedButton),
    progressIndicatorTheme: AppProgressIndicatorStyles.progressIndicatorTheme,
  );
}
