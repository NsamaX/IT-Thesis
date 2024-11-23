import 'package:flutter/material.dart';
import 'colors.dart';

class AppBottomNavBarStyles {
  static BottomNavigationBarThemeData bottomNavBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundDark,
    selectedItemColor: AppColors.accentBlue,
    unselectedItemColor: AppColors.textWhiteOpacity,
  );
}
