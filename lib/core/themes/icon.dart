import 'package:flutter/material.dart';

import 'colors.dart';

class AppIconThemes {
  final bool isDarkMode;

  AppIconThemes(this.isDarkMode);

  IconThemeData get appBarIcon => const IconThemeData(
    color: AppColors.PrimaryColor,
    size: 24,
  );

  IconThemeData get defaultIcon => IconThemeData(
    color: iconColor,
    size: 16,
  );

  Color get iconColor => isDarkMode
      ? AppColors.DarkModeText
      : AppColors.LightModeText;
}
