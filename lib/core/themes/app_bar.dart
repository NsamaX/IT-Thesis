import 'package:flutter/material.dart';
import 'colors.dart';
import 'icon.dart';
import 'text.dart';

class AppBarStyles {
  final bool isDarkMode;

  AppBarStyles(this.isDarkMode);

  AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: backgroundColor,
    iconTheme: iconTheme,
    titleTextStyle: titleTextStyle,
  );

  Color get backgroundColor => isDarkMode
      ? AppColors.DarkModeBackground_lv3
      : AppColors.LightModeBackground_lv3;

  IconThemeData get iconTheme => AppIconThemes(isDarkMode).appBarIcon;

  TextStyle get titleTextStyle => AppTextStyles(isDarkMode).titleSmall.copyWith(
    color: AppColors.PrimaryColor,
  );
}
