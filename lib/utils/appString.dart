import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static Shader _createShader(List<Color> colors, double? fontSize) {
    final double textHeight = fontSize ?? 24.0;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0.0, 0.0, 350.0, textHeight));
  }

  // Playfair Display Text Styles
  static TextStyle playfairDisplay({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


  static TextStyle plusJakartaSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.plusJakartaSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


  static TextStyle cormorantGaramond({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Poppins Text Styles
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Manrope Text Styles
  static TextStyle manrope({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    List<Color>? gradientColors,
  }) {
    if (gradientColors != null && gradientColors.isNotEmpty) {
      return GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: fontWeight,
        foreground: Paint()..shader = _createShader(gradientColors, fontSize),
      );
    }
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}