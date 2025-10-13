import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../runtime/platform/vyuh_platform.dart';
import '../plugin.dart';
import '../telemetry/logger.dart';
import 'locale_configuration.dart';
import 'translation_registration.dart';

/// Plugin for managing internationalization across features
///
/// This plugin provides centralized locale management and allows features
/// to register their locale change handlers.
///
/// Usage in features:
/// ```dart
/// final feature = FeatureDescriptor(
///   init: () async {
///     final localePlugin = vyuh.getPlugin<LocalePlugin>();
///     if (localePlugin != null) {
///       localePlugin.registerTranslations(
///         TranslationRegistration(
///           name: 'my_feature',
///           onLocaleChange: (locale) async {
///             final appLocale = _convertToAppLocale(locale);
///             await FeatureLocaleSettings.setLocale(appLocale);
///           },
///         ),
///       );
///     }
///   },
/// );
/// ```
class LocalePlugin extends Plugin {
  static const String _localePreferenceKey = 'app_locale';

  /// List of supported locale configurations
  final List<LocaleConfiguration> locales;

  /// Default locale configuration (first locale if not specified)
  final LocaleConfiguration? _defaultLocale;

  /// Raw observable for the current locale (no codegen)
  late final Observable<Locale> currentLocale;

  /// Raw observable to track locale loading state (no codegen)
  final Observable<bool> isLoadingLocale = Observable(false);

  final List<TranslationRegistration> _registrations = [];
  SharedPreferences? _prefs;

  /// Get the default locale configuration
  LocaleConfiguration get defaultLocale => _defaultLocale ?? locales.first;

  /// Available locales in the application
  List<Locale> get supportedLocales => locales.map((l) => l.locale).toList();

  LocalePlugin({
    required this.locales,
    LocaleConfiguration? defaultLocale,
  })  : assert(locales.isNotEmpty, 'At least one locale must be provided'),
        _defaultLocale = defaultLocale,
        super(name: 'locale', title: 'Internationalization') {
    currentLocale = Observable((_defaultLocale ?? locales.first).locale);
  }

  /// Register a feature's translation configuration
  ///
  /// This should be called during feature initialization.
  /// The plugin will:
  /// 1. Initialize the feature's translations with the current locale
  /// 2. Register the callback for future locale changes
  void registerTranslations(TranslationRegistration registration) {
    _registrations.add(registration);

    vyuh.log.info('LocalePlugin: Registered translations for "${registration.name}"');

    // Initialize with current locale (async to support deferred loading)
    Future.microtask(() async {
      try {
        await registration.onLocaleChange(currentLocale.value);
      } catch (e) {
        vyuh.log.error(
          'LocalePlugin: Error initializing "${registration.name}" translations: $e',
        );
      }
    });
  }

  /// Set the application locale
  Future<bool> setLocale(Locale locale) async {
    if (!_isLocaleSupported(locale)) {
      return false;
    }

    // Set loading state
    runInAction(() => isLoadingLocale.value = true);

    try {
      // IMPORTANT: Load all deferred translation libraries BEFORE updating the observable
      // This ensures translations are ready when the UI rebuilds
      for (final registration in _registrations) {
        try {
          await registration.onLocaleChange(locale);
        } catch (e) {
          vyuh.log.error(
              'LocalePlugin: Error notifying "${registration.name}" of locale change: $e');
        }
      }

      // Now update the observable to trigger UI rebuild with loaded translations
      runInAction(() => currentLocale.value = locale);

      // Persist the preference
      await _prefs?.setString(_localePreferenceKey, locale.languageCode);

      return true;
    } finally {
      // Clear loading state
      runInAction(() => isLoadingLocale.value = false);
    }
  }

  /// Use the device's locale if supported, otherwise default to configured default
  Future<void> useDeviceLocale() async {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    if (_isLocaleSupported(deviceLocale)) {
      await setLocale(deviceLocale);
    } else {
      // Try to match language code only (ignore country code)
      final languageLocale = Locale(deviceLocale.languageCode);
      if (_isLocaleSupported(languageLocale)) {
        await setLocale(languageLocale);
      } else {
        // Default to configured default locale
        await setLocale(defaultLocale.locale);
      }
    }
  }

  /// Get configuration for a specific language code
  LocaleConfiguration? _getConfig(String languageCode) {
    try {
      return locales.firstWhere((l) => l.languageCode == languageCode);
    } catch (_) {
      return null;
    }
  }

  /// Check if a locale is supported
  bool _isLocaleSupported(Locale locale) {
    return locales.any((l) => l.languageCode == locale.languageCode);
  }

  /// Check if a specific locale is currently active
  bool isLocaleActive(Locale locale) {
    return currentLocale.value.languageCode == locale.languageCode;
  }

  /// Get the native name for a locale code
  String getLocaleName(String localeCode) {
    return _getConfig(localeCode)?.nativeName ?? localeCode.toUpperCase();
  }

  /// Get the icon/emoji for a locale code
  String getLocaleIcon(String localeCode) {
    return _getConfig(localeCode)?.icon ?? '🌐'; // Globe emoji as fallback
  }

  /// Get the current locale code
  String get currentLocaleCode => currentLocale.value.languageCode;

  /// Number of registered translations
  int get registrationCount => _registrations.length;

  @override
  Future<void> init() async {
    // Load saved locale preference
    _prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = _prefs?.getString(_localePreferenceKey);

    if (savedLocaleCode != null) {
      final savedLocale = Locale(savedLocaleCode);
      if (_isLocaleSupported(savedLocale)) {
        await setLocale(savedLocale);
      } else {
        await useDeviceLocale();
      }
    } else {
      await useDeviceLocale();
    }
  }

  @override
  Future<void> dispose() async {
    _registrations.clear();
    _prefs = null;
  }
}
