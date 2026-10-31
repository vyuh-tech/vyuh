import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

/// The app's themes, given once to [PlatformWidgetBuilder.theme].
///
/// The framework uses it everywhere it draws its own UI: the loading screen
/// before the app starts, the startup failure screen, the default app root,
/// loaders, error views and placeholders. Apps that build their own root in
/// `appBuilder` should pass the same values to their `MaterialApp`.
///
/// ```dart
/// runApp(
///   platformWidgetBuilder: PlatformWidgetBuilder.system.copyWith(
///     theme: VyuhTheme(light: MyDesign.light, dark: MyDesign.dark),
///   ),
///   features: () => [...],
/// );
/// ```
@immutable
final class VyuhTheme {
  /// The light theme. Also used when [dark] is not given.
  final ThemeData light;

  /// The dark theme.
  final ThemeData? dark;

  /// Which theme to use. Defaults to following the platform.
  final ThemeMode mode;

  const VyuhTheme({
    required this.light,
    this.dark,
    this.mode = ThemeMode.system,
  });

  /// Material 3 light and dark themes generated from one seed color.
  factory VyuhTheme.fromSeed(Color seed, {ThemeMode mode = ThemeMode.system}) =>
      VyuhTheme(
        light: ThemeData(colorSchemeSeed: seed, brightness: Brightness.light),
        dark: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark),
        mode: mode,
      );

  /// The framework default: Material 3 from a neutral indigo seed.
  static final VyuhTheme system = VyuhTheme.fromSeed(Colors.indigo);

  /// A copy with the given fields replaced.
  VyuhTheme copyWith({ThemeData? light, ThemeData? dark, ThemeMode? mode}) =>
      VyuhTheme(
        light: light ?? this.light,
        dark: dark ?? this.dark,
        mode: mode ?? this.mode,
      );
}

/// Design tokens for the UI the framework draws itself.
///
/// Add it to your `ThemeData.extensions` to restyle loaders, error views and
/// placeholders. Every token you leave out falls back to a value derived from
/// the theme's [ColorScheme], so the defaults follow light and dark mode.
///
/// ```dart
/// ThemeData(
///   colorSchemeSeed: brand,
///   extensions: const [
///     VyuhThemeExtension(showPoweredBy: false, loaderDelay: Duration(milliseconds: 300)),
///   ],
/// )
/// ```
///
/// Read the resolved tokens with [VyuhThemeExtension.of].
@immutable
final class VyuhThemeExtension extends ThemeExtension<VyuhThemeExtension> {
  /// Background of the full-screen app loader.
  final Color? appLoaderBackground;

  /// Progress color of loaders.
  final Color? loaderColor;

  /// Background behind a route that is loading.
  final Color? routeLoaderBackground;

  /// Background of image and content placeholders.
  final Color? placeholderBackground;

  /// Icon color of placeholders.
  final Color? placeholderForeground;

  /// Background of the badge behind failure icons and of inline failures.
  final Color? failureBackground;

  /// Icon and text color on [failureBackground].
  final Color? failureForeground;

  /// Background of debug-only diagnostics such as unknown content.
  final Color? debugBackground;

  /// Text color of debug-only diagnostics.
  final Color? debugForeground;

  /// Border color of debug-only diagnostics.
  final Color? debugBorder;

  /// Corner radius of inline failures, placeholders and diagnostics.
  final double? radius;

  /// How long a route or content loader waits before it appears, so fast
  /// loads don't flash.
  final Duration? loaderDelay;

  /// Whether the app loader shows "Powered by Vyuh".
  final bool? showPoweredBy;

  const VyuhThemeExtension({
    this.appLoaderBackground,
    this.loaderColor,
    this.routeLoaderBackground,
    this.placeholderBackground,
    this.placeholderForeground,
    this.failureBackground,
    this.failureForeground,
    this.debugBackground,
    this.debugForeground,
    this.debugBorder,
    this.radius,
    this.loaderDelay,
    this.showPoweredBy,
  });

  /// Fully resolved tokens for [scheme].
  factory VyuhThemeExtension.fallback(ColorScheme scheme) => VyuhThemeExtension(
    appLoaderBackground: scheme.surface,
    loaderColor: scheme.primary,
    routeLoaderBackground: scheme.surface,
    placeholderBackground: scheme.surfaceContainerHighest,
    placeholderForeground: scheme.onSurfaceVariant,
    failureBackground: scheme.errorContainer,
    failureForeground: scheme.onErrorContainer,
    debugBackground: scheme.errorContainer,
    debugForeground: scheme.onErrorContainer,
    debugBorder: scheme.error,
    radius: 12,
    loaderDelay: const Duration(milliseconds: 200),
    showPoweredBy: true,
  );

  /// The tokens for [context]: the theme's extension, with every missing
  /// token filled from its color scheme.
  static VyuhThemeExtension of(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = VyuhThemeExtension.fallback(theme.colorScheme);
    final custom = theme.extension<VyuhThemeExtension>();
    return custom == null ? fallback : fallback._merge(custom);
  }

  VyuhThemeExtension _merge(VyuhThemeExtension other) => VyuhThemeExtension(
    appLoaderBackground: other.appLoaderBackground ?? appLoaderBackground,
    loaderColor: other.loaderColor ?? loaderColor,
    routeLoaderBackground: other.routeLoaderBackground ?? routeLoaderBackground,
    placeholderBackground: other.placeholderBackground ?? placeholderBackground,
    placeholderForeground: other.placeholderForeground ?? placeholderForeground,
    failureBackground: other.failureBackground ?? failureBackground,
    failureForeground: other.failureForeground ?? failureForeground,
    debugBackground: other.debugBackground ?? debugBackground,
    debugForeground: other.debugForeground ?? debugForeground,
    debugBorder: other.debugBorder ?? debugBorder,
    radius: other.radius ?? radius,
    loaderDelay: other.loaderDelay ?? loaderDelay,
    showPoweredBy: other.showPoweredBy ?? showPoweredBy,
  );

  @override
  VyuhThemeExtension copyWith({
    Color? appLoaderBackground,
    Color? loaderColor,
    Color? routeLoaderBackground,
    Color? placeholderBackground,
    Color? placeholderForeground,
    Color? failureBackground,
    Color? failureForeground,
    Color? debugBackground,
    Color? debugForeground,
    Color? debugBorder,
    double? radius,
    Duration? loaderDelay,
    bool? showPoweredBy,
  }) => VyuhThemeExtension(
    appLoaderBackground: appLoaderBackground ?? this.appLoaderBackground,
    loaderColor: loaderColor ?? this.loaderColor,
    routeLoaderBackground: routeLoaderBackground ?? this.routeLoaderBackground,
    placeholderBackground: placeholderBackground ?? this.placeholderBackground,
    placeholderForeground: placeholderForeground ?? this.placeholderForeground,
    failureBackground: failureBackground ?? this.failureBackground,
    failureForeground: failureForeground ?? this.failureForeground,
    debugBackground: debugBackground ?? this.debugBackground,
    debugForeground: debugForeground ?? this.debugForeground,
    debugBorder: debugBorder ?? this.debugBorder,
    radius: radius ?? this.radius,
    loaderDelay: loaderDelay ?? this.loaderDelay,
    showPoweredBy: showPoweredBy ?? this.showPoweredBy,
  );

  @override
  VyuhThemeExtension lerp(VyuhThemeExtension? other, double t) {
    if (other == null) return this;
    return VyuhThemeExtension(
      appLoaderBackground: Color.lerp(
        appLoaderBackground,
        other.appLoaderBackground,
        t,
      ),
      loaderColor: Color.lerp(loaderColor, other.loaderColor, t),
      routeLoaderBackground: Color.lerp(
        routeLoaderBackground,
        other.routeLoaderBackground,
        t,
      ),
      placeholderBackground: Color.lerp(
        placeholderBackground,
        other.placeholderBackground,
        t,
      ),
      placeholderForeground: Color.lerp(
        placeholderForeground,
        other.placeholderForeground,
        t,
      ),
      failureBackground: Color.lerp(
        failureBackground,
        other.failureBackground,
        t,
      ),
      failureForeground: Color.lerp(
        failureForeground,
        other.failureForeground,
        t,
      ),
      debugBackground: Color.lerp(debugBackground, other.debugBackground, t),
      debugForeground: Color.lerp(debugForeground, other.debugForeground, t),
      debugBorder: Color.lerp(debugBorder, other.debugBorder, t),
      radius: lerpDouble(radius, other.radius, t),
      loaderDelay: t < 0.5 ? loaderDelay : other.loaderDelay,
      showPoweredBy: t < 0.5 ? showPoweredBy : other.showPoweredBy,
    );
  }
}
