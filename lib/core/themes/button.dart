import 'package:flutter/material.dart';
import 'colors.dart';
import 'text.dart';

class AppButtonStyles {
  final bool isDarkMode;

  AppButtonStyles(this.isDarkMode);

  ButtonStyle get elevatedButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(backgroundColor),
    textStyle: WidgetStateProperty.all(textStyle),
  );

  Color get backgroundColor => isDarkMode
      ? AppColors.DarkModeText
      : AppColors.LightModeText;

  TextStyle get textStyle => AppTextStyles(isDarkMode).bodyLarge;
}
