import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

const _en = vc.LocaleConfiguration(
  locale: Locale('en'),
  nativeName: 'English',
  icon: 'EN',
);
const _hi = vc.LocaleConfiguration(
  locale: Locale('hi'),
  nativeName: 'हिन्दी',
  icon: 'HI',
);

/// Records the error-level messages that reach telemetry.
final class _Errors implements vc.TelemetryProvider {
  final messages = <String>[];

  @override
  String get name => 'errors';

  @override
  String get title => 'Errors';

  @override
  String get description => 'Errors';

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> reportError(
    exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) async {}

  @override
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  }) async {}

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    vc.LogLevel? level = vc.LogLevel.info,
  }) async {
    if (level == vc.LogLevel.error) messages.add(message);
  }

  @override
  Future<vc.Trace> startTrace(
    String name,
    String operation, {
    vc.LogLevel? level = vc.LogLevel.info,
  }) async => vc.NoOpTrace();
}

/// Starts the platform with [plugin] registered, after seeding the saved
/// preferences and the device locale.
Future<_Errors> _start(
  WidgetTester tester,
  vc.LocalePlugin plugin, {
  Map<String, Object> prefs = const {},
  Locale? deviceLocale,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  if (deviceLocale != null) {
    tester.platformDispatcher.localeTestValue = deviceLocale;
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
  }

  final errors = _Errors();
  vc.runApp(
    features: () => [
      vc.FeatureDescriptor(
        name: 'home',
        title: 'Home',
        routes: () => [
          GoRoute(path: '/', builder: (_, _) => const Text('home')),
        ],
      ),
    ],
    plugins: vc.PluginDescriptor(
      telemetry: vc.TelemetryPlugin(providers: [errors]),
      others: [plugin],
    ),
  );
  await vc.vyuh.getReady(tester);
  return errors;
}

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  group('LocaleConfiguration', () {
    test('exposes the language code of its locale', () {
      final code = ['hi'].single;
      final config = vc.LocaleConfiguration(
        locale: Locale(code),
        nativeName: 'हिन्दी',
        icon: 'HI',
      );
      expect(config.languageCode, 'hi');
    });

    test('fromCode builds a configuration from a language code', () {
      final config = vc.LocaleConfiguration.fromCode(
        'ta',
        nativeName: 'தமிழ்',
        icon: 'TA',
      );
      expect(config.locale, const Locale('ta'));
      expect(config.nativeName, 'தமிழ்');
      expect(config.icon, 'TA');
    });
  });

  group('LocalePlugin before init', () {
    test('defaults to the first locale', () {
      final plugin = vc.LocalePlugin(locales: [_en, _hi]);

      expect(plugin.defaultLocale, same(_en));
      expect(plugin.currentLocale.value, const Locale('en'));
      expect(plugin.currentLocaleCode, 'en');
      expect(plugin.supportedLocales, [const Locale('en'), const Locale('hi')]);
      expect(plugin.isLoadingLocale.value, isFalse);
      expect(plugin.registrationCount, 0);
    });

    test('an explicit default locale wins over the first one', () {
      final plugin = vc.LocalePlugin(locales: [_en, _hi], defaultLocale: _hi);

      expect(plugin.defaultLocale, same(_hi));
      expect(plugin.currentLocaleCode, 'hi');
      expect(plugin.isLocaleActive(const Locale('hi', 'IN')), isTrue);
      expect(plugin.isLocaleActive(const Locale('en')), isFalse);
    });

    test('looks up names and icons, with fallbacks for unknown codes', () {
      final plugin = vc.LocalePlugin(locales: [_en, _hi]);

      expect(plugin.getLocaleName('hi'), 'हिन्दी');
      expect(plugin.getLocaleIcon('hi'), 'HI');
      expect(plugin.getLocaleName('fr'), 'FR');
      expect(plugin.getLocaleIcon('fr'), '🌐');
    });
  });

  group('LocalePlugin.init', () {
    testWidgets('restores a saved, supported locale', (tester) async {
      final plugin = vc.LocalePlugin(locales: [_en, _hi]);
      await _start(
        tester,
        plugin,
        prefs: {'app_locale': 'hi'},
        deviceLocale: const Locale('en'),
      );

      expect(plugin.currentLocaleCode, 'hi');
    });

    testWidgets('ignores a saved, unsupported locale and uses the device', (
      tester,
    ) async {
      final plugin = vc.LocalePlugin(locales: [_en, _hi]);
      await _start(
        tester,
        plugin,
        prefs: {'app_locale': 'fr'},
        deviceLocale: const Locale('hi', 'IN'),
      );

      expect(plugin.currentLocaleCode, 'hi');
      // The configured locale, not the device's `hi_IN`.
      expect(plugin.currentLocale.value, const Locale('hi'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_locale'), 'hi');
    });

    testWidgets('falls back to the default for an unsupported device locale', (
      tester,
    ) async {
      final plugin = vc.LocalePlugin(locales: [_hi, _en], defaultLocale: _en);
      await _start(tester, plugin, deviceLocale: const Locale('fr', 'FR'));

      expect(plugin.currentLocaleCode, 'en');
    });
  });

  group('LocalePlugin.setLocale', () {
    testWidgets('rejects an unsupported locale', (tester) async {
      final plugin = vc.LocalePlugin(locales: [_en, _hi]);
      await _start(tester, plugin, deviceLocale: const Locale('en'));

      expect(await plugin.setLocale(const Locale('fr')), isFalse);
      expect(plugin.currentLocaleCode, 'en');
    });

    testWidgets(
      'notifies registrations before switching, survives a failing one, '
      'and persists the choice',
      (tester) async {
        final plugin = vc.LocalePlugin(locales: [_en, _hi]);
        final errors = await _start(
          tester,
          plugin,
          deviceLocale: const Locale('en'),
        );

        final seen = <String>[];
        plugin.registerTranslations(
          vc.TranslationRegistration(
            name: 'broken',
            onLocaleChange: (locale) async {
              if (locale.languageCode == 'hi') throw StateError('no hi');
            },
          ),
        );
        plugin.registerTranslations(
          vc.TranslationRegistration(
            name: 'good',
            onLocaleChange: (locale) async {
              seen.add(
                '${locale.languageCode} while '
                '${plugin.currentLocaleCode}, '
                'loading=${plugin.isLoadingLocale.value}',
              );
            },
          ),
        );
        await tester.pump();
        expect(plugin.registrationCount, 2);
        seen.clear();

        expect(await plugin.setLocale(const Locale('hi')), isTrue);

        // The registration ran while the old locale was still current.
        expect(seen, ['hi while en, loading=true']);
        expect(plugin.currentLocaleCode, 'hi');
        expect(plugin.isLoadingLocale.value, isFalse);
        expect(
          errors.messages,
          contains(contains('Error notifying "broken" of locale change')),
        );

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('app_locale'), 'hi');
      },
    );
  });

  group('LocalePlugin.registerTranslations', () {
    testWidgets('initializes a registration with the current locale', (
      tester,
    ) async {
      final plugin = vc.LocalePlugin(locales: [_en, _hi], defaultLocale: _hi);
      await _start(tester, plugin, deviceLocale: const Locale('hi'));

      final received = <Locale>[];
      plugin.registerTranslations(
        vc.TranslationRegistration(
          name: 'feature',
          onLocaleChange: (locale) async => received.add(locale),
        ),
      );
      expect(received, isEmpty, reason: 'initialization is deferred');

      await tester.pump();
      expect(received, [const Locale('hi')]);
    });

    testWidgets('logs a registration that fails to initialize', (tester) async {
      final plugin = vc.LocalePlugin(locales: [_en]);
      final errors = await _start(
        tester,
        plugin,
        deviceLocale: const Locale('en'),
      );

      plugin.registerTranslations(
        vc.TranslationRegistration(
          name: 'broken',
          onLocaleChange: (_) async => throw StateError('load failed'),
        ),
      );
      await tester.pump();

      expect(
        errors.messages,
        contains(
          'LocalePlugin: Error initializing "broken" translations: '
          'Bad state: load failed',
        ),
      );
    });
  });

  testWidgets('dispose drops all registrations', (tester) async {
    final plugin = vc.LocalePlugin(locales: [_en]);
    await _start(tester, plugin, deviceLocale: const Locale('en'));
    plugin.registerTranslations(
      vc.TranslationRegistration(name: 'a', onLocaleChange: (_) async {}),
    );
    await tester.pump();

    await plugin.dispose();

    expect(plugin.registrationCount, 0);
  });
}
