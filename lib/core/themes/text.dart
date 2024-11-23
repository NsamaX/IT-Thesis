import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle titleLarge = textStyle(AppColors.textWhite, 32, true);
  static TextStyle titleMedium = textStyle(AppColors.textWhite, 24, true);
  static TextStyle titleSmall = textStyle(AppColors.textWhite, 16, true);
  static TextStyle bodyLarge = textStyle(AppColors.textWhite, 20, false);
  static TextStyle bodyMedium = textStyle(AppColors.textWhite, 16, false);
  static TextStyle bodySmall = textStyle(AppColors.textWhite, 12, false);

  static TextStyle textStyle(Color color, double fontSize, bool isTitle) {
    return TextStyle(
      fontFamily: GoogleFonts.inter().fontFamily,
      fontSize: fontSize,
      fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
  }
}
