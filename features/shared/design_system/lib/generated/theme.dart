import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4285158540),
      surfaceTint: Color(4285158540),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4293713151),
      onPrimaryContainer: Color(4280618565),
      secondary: Color(4284766832),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4293648119),
      onSecondaryContainer: Color(4280227882),
      tertiary: Color(4286534235),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294957535),
      onTertiaryContainer: Color(4281471001),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294899711),
      onSurface: Color(4280097312),
      onSurfaceVariant: Color(4283057486),
      outline: Color(4286281087),
      outlineVariant: Color(4291544271),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281478965),
      inversePrimary: Color(4292262908),
      primaryFixed: Color(4293713151),
      onPrimaryFixed: Color(4280618565),
      primaryFixedDim: Color(4292262908),
      onPrimaryFixedVariant: Color(4283579507),
      secondaryFixed: Color(4293648119),
      onSecondaryFixed: Color(4280227882),
      secondaryFixedDim: Color(4291740379),
      onSecondaryFixedVariant: Color(4283188055),
      tertiaryFixed: Color(4294957535),
      onTertiaryFixed: Color(4281471001),
      tertiaryFixedDim: Color(4294031298),
      onTertiaryFixedVariant: Color(4284758852),
      surfaceDim: Color(4292860128),
      surfaceBright: Color(4294899711),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294570489),
      surfaceContainer: Color(4294175988),
      surfaceContainerHigh: Color(4293781230),
      surfaceContainerHighest: Color(4293386472),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4283316335),
      surfaceTint: Color(4285158540),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4286671524),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282924883),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286214279),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284495680),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288178033),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294899711),
      onSurface: Color(4280097312),
      onSurfaceVariant: Color(4282794314),
      outline: Color(4284636519),
      outlineVariant: Color(4286478722),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281478965),
      inversePrimary: Color(4292262908),
      primaryFixed: Color(4286671524),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4285026698),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286214279),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284569709),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4288178033),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4286336857),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292860128),
      surfaceBright: Color(4294899711),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294570489),
      surfaceContainer: Color(4294175988),
      surfaceContainerHigh: Color(4293781230),
      surfaceContainerHighest: Color(4293386472),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281079372),
      surfaceTint: Color(4285158540),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283316335),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280688433),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282924883),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281997088),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284495680),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294899711),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280689194),
      outline: Color(4282794314),
      outlineVariant: Color(4282794314),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281478965),
      inversePrimary: Color(4294240255),
      primaryFixed: Color(4283316335),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281803095),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282924883),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281411900),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284495680),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282786090),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292860128),
      surfaceBright: Color(4294899711),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294570489),
      surfaceContainer: Color(4294175988),
      surfaceContainerHigh: Color(4293781230),
      surfaceContainerHighest: Color(4293386472),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292262908),
      surfaceTint: Color(4292262908),
      onPrimary: Color(4282000731),
      primaryContainer: Color(4283579507),
      onPrimaryContainer: Color(4293713151),
      secondary: Color(4291740379),
      onSecondary: Color(4281675072),
      secondaryContainer: Color(4283188055),
      onSecondaryContainer: Color(4293648119),
      tertiary: Color(4294031298),
      onTertiary: Color(4283114798),
      tertiaryContainer: Color(4284758852),
      onTertiaryContainer: Color(4294957535),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279570968),
      onSurface: Color(4293386472),
      onSurfaceVariant: Color(4291544271),
      outline: Color(4287991449),
      outlineVariant: Color(4283057486),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386472),
      inversePrimary: Color(4285158540),
      primaryFixed: Color(4293713151),
      onPrimaryFixed: Color(4280618565),
      primaryFixedDim: Color(4292262908),
      onPrimaryFixedVariant: Color(4283579507),
      secondaryFixed: Color(4293648119),
      onSecondaryFixed: Color(4280227882),
      secondaryFixedDim: Color(4291740379),
      onSecondaryFixedVariant: Color(4283188055),
      tertiaryFixed: Color(4294957535),
      onTertiaryFixed: Color(4281471001),
      tertiaryFixedDim: Color(4294031298),
      onTertiaryFixedVariant: Color(4284758852),
      surfaceDim: Color(4279570968),
      surfaceBright: Color(4282071102),
      surfaceContainerLowest: Color(4279242002),
      surfaceContainerLow: Color(4280097312),
      surfaceContainer: Color(4280360484),
      surfaceContainerHigh: Color(4281084207),
      surfaceContainerHighest: Color(4281807674),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292526079),
      surfaceTint: Color(4292262908),
      onPrimary: Color(4280223551),
      primaryContainer: Color(4288579266),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4292003551),
      onSecondary: Color(4279898917),
      secondaryContainer: Color(4288122020),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294360007),
      onTertiary: Color(4281010964),
      tertiaryContainer: Color(4290216845),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279570968),
      onSurface: Color(4294965757),
      onSurfaceVariant: Color(4291872979),
      outline: Color(4289175723),
      outlineVariant: Color(4287070603),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386472),
      inversePrimary: Color(4283645300),
      primaryFixed: Color(4293713151),
      onPrimaryFixed: Color(4279894586),
      primaryFixedDim: Color(4292262908),
      onPrimaryFixedVariant: Color(4282395489),
      secondaryFixed: Color(4293648119),
      onSecondaryFixed: Color(4279569951),
      secondaryFixedDim: Color(4291740379),
      onSecondaryFixedVariant: Color(4282069830),
      tertiaryFixed: Color(4294957535),
      onTertiaryFixed: Color(4280616463),
      tertiaryFixedDim: Color(4294031298),
      onTertiaryFixedVariant: Color(4283509300),
      surfaceDim: Color(4279570968),
      surfaceBright: Color(4282071102),
      surfaceContainerLowest: Color(4279242002),
      surfaceContainerLow: Color(4280097312),
      surfaceContainer: Color(4280360484),
      surfaceContainerHigh: Color(4281084207),
      surfaceContainerHighest: Color(4281807674),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965757),
      surfaceTint: Color(4292262908),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4292526079),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965757),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4292003551),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965753),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294360007),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279570968),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965757),
      outline: Color(4291872979),
      outlineVariant: Color(4291872979),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386472),
      inversePrimary: Color(4281605716),
      primaryFixed: Color(4293976575),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4292526079),
      onPrimaryFixedVariant: Color(4280223551),
      secondaryFixed: Color(4293911292),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4292003551),
      onSecondaryFixedVariant: Color(4279898917),
      tertiaryFixed: Color(4294959076),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294360007),
      onTertiaryFixedVariant: Color(4281010964),
      surfaceDim: Color(4279570968),
      surfaceBright: Color(4282071102),
      surfaceContainerLowest: Color(4279242002),
      surfaceContainerLow: Color(4280097312),
      surfaceContainer: Color(4280360484),
      surfaceContainerHigh: Color(4281084207),
      surfaceContainerHighest: Color(4281807674),
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
        scaffoldBackgroundColor: colorScheme.background,
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
