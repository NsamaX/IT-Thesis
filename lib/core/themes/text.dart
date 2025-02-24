import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  final bool isDarkMode;

  AppTextStyles(this.isDarkMode);

  Color get _textColor => isDarkMode ? AppColors.DarkModeText : AppColors.LightModeText;

  /*------------------------------ Title Styles ------------------------------*/
  TextStyle get titleLarge  => _textStyle(_textColor, 28, true);
  TextStyle get titleMedium => _textStyle(_textColor, 20, true);
  TextStyle get titleSmall  => _textStyle(_textColor, 12, true);

  /*------------------------------- Body Styles ------------------------------*/
  TextStyle get bodyLarge   => _textStyle(_textColor, 18, false);
  TextStyle get bodyMedium  => _textStyle(_textColor, 14, false);
  TextStyle get bodySmall   => _textStyle(_textColor, 10, false);

  /*----------------------------- Factory Method -----------------------------*/
  TextStyle _textStyle(Color color, double fontSize, bool isBold) => TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}
