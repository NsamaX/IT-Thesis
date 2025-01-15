import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'button.dart';
import 'colors.dart';
import 'icon.dart';
import 'nav_bar.dart';
import 'progress_indicator.dart';
import 'text.dart';

/// Returns ThemeData based on the current mode (Dark/Light).
ThemeData themeData({required bool isDarkMode}) {
  final appBarStyles = AppBarStyles(isDarkMode);
  final buttonStyles = AppButtonStyles(isDarkMode);
  final iconThemes = AppIconThemes(isDarkMode);
  final navBarStyles = AppBottomNavBarStyles(isDarkMode);
  final progressIndicatorStyles = AppProgressIndicatorStyles(isDarkMode);
  final textStyles = AppTextStyles(isDarkMode);

  return ThemeData(
    // Background Colors
    scaffoldBackgroundColor: isDarkMode
        ? AppColors.DarkModeBackground_lv2
        : AppColors.LightModeBackground_lv2,

    // Primary Colors
    primaryColor: AppColors.PrimaryColor,

    // Icon Theme
    iconTheme: iconThemes.defaultIcon,

    // Text Theme
    textTheme: TextTheme(
      titleLarge: textStyles.titleLarge,
      titleMedium: textStyles.titleMedium,
      titleSmall: textStyles.titleSmall,
      bodyLarge: textStyles.bodyLarge,
      bodyMedium: textStyles.bodyMedium,
      bodySmall: textStyles.bodySmall,
    ),

    // AppBar Theme
    appBarTheme: appBarStyles.appBarTheme,

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: navBarStyles.bottomNavBarTheme,

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyles.elevatedButton,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: progressIndicatorStyles.progressIndicatorTheme,
  );
}
