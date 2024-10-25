import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a548c),
      surfaceTint: Color(0xff6a548c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffecdcff),
      onPrimaryContainer: Color(0xff250e45),
      secondary: Color(0xff645a70),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffebdef7),
      onSecondaryContainer: Color(0xff1f182a),
      tertiary: Color(0xff7f525b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9df),
      onTertiaryContainer: Color(0xff321019),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff1d1a20),
      onSurfaceVariant: Color(0xff4a454e),
      outline: Color(0xff7b757f),
      outlineVariant: Color(0xffcbc4cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffd6bbfc),
      primaryFixed: Color(0xffecdcff),
      onPrimaryFixed: Color(0xff250e45),
      primaryFixedDim: Color(0xffd6bbfc),
      onPrimaryFixedVariant: Color(0xff523c73),
      secondaryFixed: Color(0xffebdef7),
      onSecondaryFixed: Color(0xff1f182a),
      secondaryFixedDim: Color(0xffcec2db),
      onSecondaryFixedVariant: Color(0xff4c4357),
      tertiaryFixed: Color(0xffffd9df),
      onTertiaryFixed: Color(0xff321019),
      tertiaryFixedDim: Color(0xfff1b7c2),
      onTertiaryFixedVariant: Color(0xff643b44),
      surfaceDim: Color(0xffdfd8e0),
      surfaceBright: Color(0xfffef7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f1f9),
      surfaceContainer: Color(0xfff3ecf4),
      surfaceContainerHigh: Color(0xffede6ee),
      surfaceContainerHighest: Color(0xffe7e0e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4e386f),
      surfaceTint: Color(0xff6a548c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff816aa4),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff483f53),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7a7087),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff603740),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff986771),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff1d1a20),
      onSurfaceVariant: Color(0xff46414a),
      outline: Color(0xff625d67),
      outlineVariant: Color(0xff7e7982),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffd6bbfc),
      primaryFixed: Color(0xff816aa4),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff68518a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7a7087),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff61586d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff986771),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7c4f59),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdfd8e0),
      surfaceBright: Color(0xfffef7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f1f9),
      surfaceContainer: Color(0xfff3ecf4),
      surfaceContainerHigh: Color(0xffede6ee),
      surfaceContainerHighest: Color(0xffe7e0e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c164c),
      surfaceTint: Color(0xff6a548c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4e386f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff261f31),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff483f53),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a1720),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff603740),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff26222a),
      outline: Color(0xff46414a),
      outlineVariant: Color(0xff46414a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xfff4e7ff),
      primaryFixed: Color(0xff4e386f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff372157),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff483f53),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff31293c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff603740),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff46212a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdfd8e0),
      surfaceBright: Color(0xfffef7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9f1f9),
      surfaceContainer: Color(0xfff3ecf4),
      surfaceContainerHigh: Color(0xffede6ee),
      surfaceContainerHighest: Color(0xffe7e0e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd6bbfc),
      surfaceTint: Color(0xffd6bbfc),
      onPrimary: Color(0xff3a255b),
      primaryContainer: Color(0xff523c73),
      onPrimaryContainer: Color(0xffecdcff),
      secondary: Color(0xffcec2db),
      onSecondary: Color(0xff352d40),
      secondaryContainer: Color(0xff4c4357),
      onSecondaryContainer: Color(0xffebdef7),
      tertiary: Color(0xfff1b7c2),
      onTertiary: Color(0xff4b252e),
      tertiaryContainer: Color(0xff643b44),
      onTertiaryContainer: Color(0xffffd9df),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff151218),
      onSurface: Color(0xffe7e0e8),
      onSurfaceVariant: Color(0xffcbc4cf),
      outline: Color(0xff958e99),
      outlineVariant: Color(0xff4a454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      inversePrimary: Color(0xff6a548c),
      primaryFixed: Color(0xffecdcff),
      onPrimaryFixed: Color(0xff250e45),
      primaryFixedDim: Color(0xffd6bbfc),
      onPrimaryFixedVariant: Color(0xff523c73),
      secondaryFixed: Color(0xffebdef7),
      onSecondaryFixed: Color(0xff1f182a),
      secondaryFixedDim: Color(0xffcec2db),
      onSecondaryFixedVariant: Color(0xff4c4357),
      tertiaryFixed: Color(0xffffd9df),
      onTertiaryFixed: Color(0xff321019),
      tertiaryFixedDim: Color(0xfff1b7c2),
      onTertiaryFixedVariant: Color(0xff643b44),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1d1a20),
      surfaceContainer: Color(0xff211e24),
      surfaceContainerHigh: Color(0xff2c292f),
      surfaceContainerHighest: Color(0xff37333a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdabfff),
      surfaceTint: Color(0xffd6bbfc),
      onPrimary: Color(0xff1f073f),
      primaryContainer: Color(0xff9e86c2),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd2c6df),
      onSecondary: Color(0xff1a1325),
      secondaryContainer: Color(0xff978ca4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff6bbc7),
      onTertiary: Color(0xff2b0b14),
      tertiaryContainer: Color(0xffb7838d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff151218),
      onSurface: Color(0xfffff9fd),
      onSurfaceVariant: Color(0xffd0c8d3),
      outline: Color(0xffa7a0ab),
      outlineVariant: Color(0xff87818b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      inversePrimary: Color(0xff533d74),
      primaryFixed: Color(0xffecdcff),
      onPrimaryFixed: Color(0xff1a023a),
      primaryFixedDim: Color(0xffd6bbfc),
      onPrimaryFixedVariant: Color(0xff402b61),
      secondaryFixed: Color(0xffebdef7),
      onSecondaryFixed: Color(0xff150e1f),
      secondaryFixedDim: Color(0xffcec2db),
      onSecondaryFixedVariant: Color(0xff3b3346),
      tertiaryFixed: Color(0xffffd9df),
      onTertiaryFixed: Color(0xff25060f),
      tertiaryFixedDim: Color(0xfff1b7c2),
      onTertiaryFixedVariant: Color(0xff512a34),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1d1a20),
      surfaceContainer: Color(0xff211e24),
      surfaceContainerHigh: Color(0xff2c292f),
      surfaceContainerHighest: Color(0xff37333a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9fd),
      surfaceTint: Color(0xffd6bbfc),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffdabfff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9fd),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd2c6df),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff6bbc7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff151218),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9fd),
      outline: Color(0xffd0c8d3),
      outlineVariant: Color(0xffd0c8d3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e0e8),
      inversePrimary: Color(0xff341e54),
      primaryFixed: Color(0xfff0e1ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffdabfff),
      onPrimaryFixedVariant: Color(0xff1f073f),
      secondaryFixed: Color(0xffefe2fc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd2c6df),
      onSecondaryFixedVariant: Color(0xff1a1325),
      tertiaryFixed: Color(0xffffdfe4),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff6bbc7),
      onTertiaryFixedVariant: Color(0xff2b0b14),
      surfaceDim: Color(0xff151218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff100d12),
      surfaceContainerLow: Color(0xff1d1a20),
      surfaceContainer: Color(0xff211e24),
      surfaceContainerHigh: Color(0xff2c292f),
      surfaceContainerHighest: Color(0xff37333a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
