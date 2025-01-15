import 'package:flutter/material.dart';
import 'colors.dart';

class AppBottomNavBarStyles {
  final bool isDarkMode;

  AppBottomNavBarStyles(this.isDarkMode);

  BottomNavigationBarThemeData get bottomNavBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode
          ? AppColors.DarkModeBackground_lv1
          : AppColors.LightModeBackground_lv1,
      selectedItemColor: AppColors.PrimaryColor,
      unselectedItemColor: AppColors.TextOpacity,
    );
  }
}
