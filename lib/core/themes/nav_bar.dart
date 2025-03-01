import 'package:flutter/material.dart';

import 'colors.dart';

class AppBottomNavBarStyles {
  final bool isDarkMode;

  AppBottomNavBarStyles(this.isDarkMode);

  BottomNavigationBarThemeData get bottomNavBarTheme => BottomNavigationBarThemeData(
    backgroundColor: backgroundColor,
    selectedItemColor: AppColors.PrimaryColor,
    unselectedItemColor: AppColors.TextOpacity,
  );

  Color get backgroundColor => isDarkMode
      ? AppColors.DarkModeBackground_lv1
      : AppColors.LightModeBackground_lv1;
}
