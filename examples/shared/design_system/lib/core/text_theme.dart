import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

TextTheme createTextTheme({
  String bodyFontString = 'Poppins',
  String displayFontString = 'Poppins',
}) {
  final base = ThemeData.light().textTheme;
  final body = _applyFont(base, bodyFontString);
  return _applyFont(base, displayFontString).copyWith(
    bodyLarge: body.bodyLarge,
    bodyMedium: body.bodyMedium,
    bodySmall: body.bodySmall,
    labelLarge: body.labelLarge,
    labelMedium: body.labelMedium,
    labelSmall: body.labelSmall,
  );
}

TextTheme _applyFont(TextTheme base, String family) => TextTheme(
  displayLarge: GoogleFonts.getFont(family, textStyle: base.displayLarge),
  displayMedium: GoogleFonts.getFont(family, textStyle: base.displayMedium),
  displaySmall: GoogleFonts.getFont(family, textStyle: base.displaySmall),
  headlineLarge: GoogleFonts.getFont(family, textStyle: base.headlineLarge),
  headlineMedium: GoogleFonts.getFont(family, textStyle: base.headlineMedium),
  headlineSmall: GoogleFonts.getFont(family, textStyle: base.headlineSmall),
  titleLarge: GoogleFonts.getFont(family, textStyle: base.titleLarge),
  titleMedium: GoogleFonts.getFont(family, textStyle: base.titleMedium),
  titleSmall: GoogleFonts.getFont(family, textStyle: base.titleSmall),
  bodyLarge: GoogleFonts.getFont(family, textStyle: base.bodyLarge),
  bodyMedium: GoogleFonts.getFont(family, textStyle: base.bodyMedium),
  bodySmall: GoogleFonts.getFont(family, textStyle: base.bodySmall),
  labelLarge: GoogleFonts.getFont(family, textStyle: base.labelLarge),
  labelMedium: GoogleFonts.getFont(family, textStyle: base.labelMedium),
  labelSmall: GoogleFonts.getFont(family, textStyle: base.labelSmall),
);
