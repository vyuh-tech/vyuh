import 'package:flutter/material.dart';

/// Registration for feature-specific translations
///
/// Features can register their translation with the LocalePlugin.
/// When using slang, translations are managed globally through LocaleSettings,
/// so no provider wrapper is needed.
///
/// Example:
/// ```dart
/// localePlugin.registerTranslations(
///   TranslationRegistration(
///     name: 'my_feature',
///     onLocaleChange: (locale) async {
///       final appLocale = _convertToAppLocale(locale);
///       await FeatureLocaleSettings.setLocale(appLocale);
///     },
///   ),
/// );
/// ```
class TranslationRegistration {
  /// Name of the translation system (for debugging)
  final String name;

  /// Callback when locale changes (async to support deferred loading)
  final Future<void> Function(Locale locale) onLocaleChange;

  const TranslationRegistration({
    required this.name,
    required this.onLocaleChange,
  });
}
