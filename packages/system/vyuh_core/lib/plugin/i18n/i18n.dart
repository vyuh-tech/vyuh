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
/// Applications should create and register the LocalePlugin with supported locales:
///
/// ```dart
/// final localePlugin = LocalePlugin(
///   locales: [
///     LocaleConfiguration.english,
///     LocaleConfiguration.hindi,
///     LocaleConfiguration.german,
///   ],
/// );
///
/// runApp(
///   plugins: PluginDescriptor(
///     // ... other plugins
///     others: [localePlugin],
///   ),
/// );
/// ```

export 'locale_configuration.dart';
export 'locale_plugin.dart';
export 'translation_registration.dart';
