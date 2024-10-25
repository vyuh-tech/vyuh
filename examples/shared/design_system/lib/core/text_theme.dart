import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme({
  String bodyFontString = 'Poppins',
  String displayFontString = 'Poppins',
}) {
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString);
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString);
  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}
