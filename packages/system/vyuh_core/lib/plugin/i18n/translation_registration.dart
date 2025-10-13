import 'package:flutter/material.dart';

/// Registration for feature-specific translations
///
/// Features can register their translation providers and locale change handlers
/// with the LocalePlugin. This enables automatic translation updates when the
/// application locale changes.
///
/// Example:
/// ```dart
/// localePlugin.registerTranslations(
///   TranslationRegistration(
///     onLocaleChange: (locale) async {
///       final appLocale = _convertToAppLocale(locale);
///       await FeatureLocaleSettings.setLocale(appLocale);
///     },
///     provider: (child) => FeatureTranslationProvider(child: child),
///   ),
/// );
/// ```
class TranslationRegistration {
  /// Callback when locale changes (async to support deferred loading)
  final Future<void> Function(Locale locale) onLocaleChange;

  /// Provider widget to wrap the app
  final Widget Function(Widget child) provider;

  const TranslationRegistration({
    required this.onLocaleChange,
    required this.provider,
  });
}
