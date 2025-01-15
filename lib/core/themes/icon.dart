import 'package:flutter/material.dart';
import 'colors.dart';

class AppIconThemes {
  final bool isDarkMode;

  AppIconThemes(this.isDarkMode);

  IconThemeData get defaultIcon {
    return IconThemeData(
      color: isDarkMode
          ? AppColors.DarkModeText
          : AppColors.LightModeText,
      size: 16,
    );
  }

  IconThemeData get appBarIcon {
    return IconThemeData(
      color: AppColors.PrimaryColor,
      size: 24,
    );
  }
}
