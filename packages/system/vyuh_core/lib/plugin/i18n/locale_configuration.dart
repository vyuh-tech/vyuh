import 'package:material_ui/material_ui.dart';

/// Configuration for a single locale including its code, native name, and icon
///
/// This class represents all the information needed to display and use a locale
/// in the application's language selector.
///
/// Example:
/// ```dart
/// const hindi = LocaleConfiguration(
///   locale: Locale('hi'),
///   nativeName: 'हिन्दी',
///   icon: '🇮🇳',
/// );
/// ```
class LocaleConfiguration {
  /// The Flutter locale
  final Locale locale;

  /// Native name of the language (e.g., "हिन्दी" for Hindi)
  final String nativeName;

  /// Icon/emoji representing the locale (e.g., "🇮🇳" for Hindi)
  final String icon;

  const LocaleConfiguration({
    required this.locale,
    required this.nativeName,
    required this.icon,
  });

  /// Get the language code from the locale
  String get languageCode => locale.languageCode;

  /// Create from language code with explicit name and icon
  factory LocaleConfiguration.fromCode(
    String code, {
    required String nativeName,
    required String icon,
  }) {
    return LocaleConfiguration(
      locale: Locale(code),
      nativeName: nativeName,
      icon: icon,
    );
  }
}
