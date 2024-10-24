import 'package:flutter/material.dart';

class TmdbTextStyleTheme extends ThemeExtension<TmdbTextStyleTheme> {
  static const String _fontFamily = 'Poppins';

  final TextStyle? displayLarge;
  final TextStyle? displayMedium;
  final TextStyle? displaySmall;
  final TextStyle? headlineLarge;
  final TextStyle? headlineMedium;
  final TextStyle? headlineSmall;
  final TextStyle? titleLarge;
  final TextStyle? labelLarge;
  final TextStyle? labelMedium;
  final TextStyle? labelSmall;
  final TextStyle? bodyLarge;
  final TextStyle? bodyMedium;
  final TextStyle? bodySmall;
  final TextStyle? caption;

  const TmdbTextStyleTheme({
    //headline1
    this.displayLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline2
    this.displayMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline3
    this.displaySmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline4
    this.headlineLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline5
    this.headlineMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline6
    this.headlineSmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //headline7
    this.titleLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      package: 'design_system',
    ),
    //subhead1
    this.labelLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      package: 'design_system',
    ),
    //subhead2
    this.labelMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      package: 'design_system',
    ),
    //subhead3
    this.labelSmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      package: 'design_system',
    ),
    //paragraph1
    this.bodyLarge = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      package: 'design_system',
    ),
    //paragraph2
    this.bodyMedium = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      package: 'design_system',
    ),
    //paragraph3
    this.bodySmall = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      package: 'design_system',
    ),
    this.caption = const TextStyle(
      fontFamily: _fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      package: 'design_system',
    ),
  });

  @override
  ThemeExtension<TmdbTextStyleTheme> copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? subHead4,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? caption,
  }) {
    return TmdbTextStyleTheme(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      caption: caption ?? this.caption,
    );
  }

  @override
  ThemeExtension<TmdbTextStyleTheme> lerp(
    covariant ThemeExtension<TmdbTextStyleTheme>? other,
    double t,
  ) {
    if (other is! TmdbTextStyleTheme) {
      return this;
    }
    return const TmdbTextStyleTheme();
  }
}
