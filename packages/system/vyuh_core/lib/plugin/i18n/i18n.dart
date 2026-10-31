/// Internationalization (i18n) support for the Vyuh framework.
///
/// - `LocalePlugin` holds the current locale as an observable, saves the
///   user's language, and tells registered features when it changes.
/// - `LocaleConfiguration` describes one supported language.
/// - `TranslationRegistration` is how a feature hooks in its translations.
///
/// ## Setup in applications
///
/// `LocalePlugin` is optional, so register it in `others`. It needs at least
/// one locale; the default is `defaultLocale`, or the first locale.
///
/// ```dart
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
/// runApp(
///   plugins: PluginDescriptor(
///     others: [LocalePlugin(locales: [english, hindi], defaultLocale: english)],
///   ),
///   features: () => [/* ... */],
/// );
/// ```
///
/// Connect `currentLocale` and `supportedLocales` to your `MaterialApp`
/// inside a MobX `Observer`; the plugin adds no widgets of its own.
///
/// ## Usage in features
///
/// Register translations in the feature's `init`. The plugin calls
/// `onLocaleChange` with the current locale right after registration, and
/// again on every change.
///
/// ```dart
/// final feature = FeatureDescriptor(
///   name: 'my_feature',
///   title: 'My Feature',
///   init: () async {
///     vyuh.locale?.registerTranslations(
///       TranslationRegistration(
///         name: 'my_feature',
///         onLocaleChange: (locale) async {
///           await MyFeatureLocaleSettings.setLocale(locale);
///         },
///       ),
///     );
///   },
/// );
/// ```
///
/// ## Changing the language
///
/// ```dart
/// final changed = await vyuh.locale?.setLocale(const Locale('hi')) ?? false;
/// await vyuh.locale?.useDeviceLocale();
/// ```
///
/// `setLocale` matches by language code and makes the configured locale for
/// that language current, so `Locale('hi', 'IN')` sets `Locale('hi')`. It
/// awaits every registration's `onLocaleChange` (with `isLoadingLocale` set
/// to true), then updates `currentLocale` and saves the language. It returns
/// false for a language that isn't configured.
library;

export 'locale_configuration.dart';
export 'locale_plugin.dart';
export 'translation_registration.dart';
