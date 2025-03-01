import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'app_bar.dart';
import 'button.dart';
import 'colors.dart';
import 'icon.dart';
import 'nav_bar.dart';
import 'progress_indicator.dart';
import 'text.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
ThemeData themeData({required bool isDarkMode}) {
  final appBarStyles = AppBarStyles(isDarkMode);
  final buttonStyles = AppButtonStyles(isDarkMode);
  final iconThemes = AppIconThemes(isDarkMode);
  final navBarStyles = AppBottomNavBarStyles(isDarkMode);
  final progressIndicatorStyles = AppProgressIndicatorStyles(isDarkMode);
  final textStyles = AppTextStyles(isDarkMode);

  return ThemeData(
    scaffoldBackgroundColor: isDarkMode
        ? AppColors.DarkModeBackground_lv2
        : AppColors.LightModeBackground_lv2,
    primaryColor: AppColors.PrimaryColor,
    colorScheme:    ColorScheme(
      brightness:   Brightness.light,
      primary:    AppColors.PrimaryColor,
      secondary:  AppColors.SecondaryColor,
      tertiary:   AppColors.TertiaryColor,
      surface:    AppColors.LightModeBackground_lv2,
      onPrimary:  Colors.white,
      onSecondary:Colors.white,
      onSurface:  Colors.white,
      error:      CupertinoColors.systemRed,
      onError:    Colors.white,
    ),
    iconTheme: iconThemes.defaultIcon,
    textTheme: TextTheme(
      titleLarge: textStyles.titleLarge,
      titleMedium: textStyles.titleMedium,
      titleSmall: textStyles.titleSmall,
      bodyLarge: textStyles.bodyLarge,
      bodyMedium: textStyles.bodyMedium,
      bodySmall: textStyles.bodySmall,
    ),
    appBarTheme: appBarStyles.appBarTheme,
    bottomNavigationBarTheme: navBarStyles.bottomNavBarTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyles.elevatedButton,
    ),
    progressIndicatorTheme: progressIndicatorStyles.progressIndicatorTheme,
  );
}
