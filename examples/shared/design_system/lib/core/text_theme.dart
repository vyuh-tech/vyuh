import 'package:flutter/material.dart' as legacy_material show TextTheme;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

TextTheme createTextTheme({
  String bodyFontString = 'Poppins',
  String displayFontString = 'Poppins',
}) {
  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString);
  final displayTextTheme = GoogleFonts.getTextTheme(displayFontString);
  return _toMaterialUiTextTheme(displayTextTheme).copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}

TextTheme _toMaterialUiTextTheme(legacy_material.TextTheme theme) => TextTheme(
  displayLarge: theme.displayLarge,
  displayMedium: theme.displayMedium,
  displaySmall: theme.displaySmall,
  headlineLarge: theme.headlineLarge,
  headlineMedium: theme.headlineMedium,
  headlineSmall: theme.headlineSmall,
  titleLarge: theme.titleLarge,
  titleMedium: theme.titleMedium,
  titleSmall: theme.titleSmall,
  bodyLarge: theme.bodyLarge,
  bodyMedium: theme.bodyMedium,
  bodySmall: theme.bodySmall,
  labelLarge: theme.labelLarge,
  labelMedium: theme.labelMedium,
  labelSmall: theme.labelSmall,
);
