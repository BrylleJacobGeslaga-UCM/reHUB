import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Text styles — same names as the Figma text styles (reHUB/Display, etc.).
class AppText {
  AppText._();

  static TextStyle _base(double size, FontWeight weight, double lineHeight,
          [double spacing = 0]) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        height: lineHeight / size,
        letterSpacing: spacing,
        color: AppColors.text,
      );

  static TextStyle get display => _base(30, FontWeight.w800, 36, -0.5);
  static TextStyle get heading => _base(22, FontWeight.w700, 28, -0.3);
  static TextStyle get title => _base(17, FontWeight.w700, 24, -0.1);
  static TextStyle get body => _base(15, FontWeight.w400, 22);
  static TextStyle get bodyStrong => _base(15, FontWeight.w600, 22);
  static TextStyle get caption => _base(13, FontWeight.w500, 18);
  static TextStyle get label => _base(12, FontWeight.w600, 16, 0.3);
}
