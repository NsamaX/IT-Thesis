import 'package:flutter/material.dart';
import 'colors.dart';
import 'text.dart';

class AppButtonStyles {
  final bool isDarkMode;

  AppButtonStyles(this.isDarkMode);

  ButtonStyle get elevatedButton => ElevatedButton.styleFrom(
    backgroundColor: isDarkMode
        ? AppColors.DarkModeText
        : AppColors.LightModeText,
    textStyle: AppTextStyles(isDarkMode).bodyLarge,
  );
}
