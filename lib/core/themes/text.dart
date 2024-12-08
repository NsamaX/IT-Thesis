import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle titleLarge = textStyle(AppColors.DarkModeText, 32, true);
  static TextStyle titleMedium = textStyle(AppColors.DarkModeText, 24, true);
  static TextStyle titleSmall = textStyle(AppColors.DarkModeText, 16, true);
  static TextStyle bodyLarge = textStyle(AppColors.DarkModeText, 20, false);
  static TextStyle bodyMedium = textStyle(AppColors.DarkModeText, 16, false);
  static TextStyle bodySmall = textStyle(AppColors.DarkModeText, 12, false);

  static TextStyle textStyle(Color color, double fontSize, bool isBold) {
    return TextStyle(
      fontFamily: GoogleFonts.inter().fontFamily,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
  }
}
