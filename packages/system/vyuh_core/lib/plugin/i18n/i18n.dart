/// Internationalization (i18n) support for Vyuh framework
///
/// This module provides the core infrastructure for multilingual support across
/// all Vyuh packages and applications. It includes:
///
/// - `LocalePlugin` - Central plugin for managing application locales
/// - `LocaleConfiguration` - Configuration for individual locales with metadata
/// - `TranslationRegistration` - Interface for features to register their translations
///
/// ## Usage in Features
///
/// Features can register their translations with the LocalePlugin during initialization:
///
/// ```dart
/// final feature = FeatureDescriptor(
///   name: 'my_feature',
///   init: () async {
///     final localePlugin = vyuh.getPlugin<LocalePlugin>();
///     if (localePlugin != null) {
///       localePlugin.registerTranslations(
///         TranslationRegistration(
///           onLocaleChange: (locale) async {
///             await MyFeatureLocaleSettings.setLocale(locale);
///           },
///           provider: (child) => MyFeatureTranslationProvider(child: child),
///         ),
///       );
///     }
///   },
/// );
/// ```
///
/// ## Setup in Applications
///
/// Applications should create and register the LocalePlugin with supported locales.
/// Locale configurations are typically defined at the application level:
///
/// ```dart
/// // Define your app's supported locales
/// const english = LocaleConfiguration(
///   locale: Locale('en'),
///   nativeName: 'English',
///   icon: '🇺🇸',
/// );
///
/// const hindi = LocaleConfiguration(
///   locale: Locale('hi'),
///   nativeName: 'हिन्दी',
///   icon: '🇮🇳',
/// );
///
/// final localePlugin = LocalePlugin(
///   locales: [english, hindi],
/// );
///
/// runApp(
///   plugins: PluginDescriptor(
///     // ... other plugins
///     others: [localePlugin],
///   ),
/// );
/// ```
library;

export 'locale_configuration.dart';
export 'locale_plugin.dart';
export 'translation_registration.dart';
