// The plugin behaviours the plugin docs promise: failures stay isolated,
// lifecycles reset cleanly, and every default does what its contract says.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

/// An event plugin whose first init fails, like a service that is down.
final class _FlakyEvents extends vc.EventPlugin {
  final inner = vc.DefaultEventPlugin();
  int attempts = 0;

  _FlakyEvents() : super(name: 'test.events', title: 'Flaky Events');

  @override
  Future<void> init() async {
    if (attempts++ == 0) throw StateError('event bus is down');
    await inner.init();
  }

  @override
  Future<void> dispose() => inner.dispose();

  @override
  void emit<T extends vc.VyuhEvent>(T event) => inner.emit(event);

  @override
  vc.DisposeFunction on<T extends vc.VyuhEvent>(
    vc.VyuhEventListener<T> listener,
  ) => inner.on<T>(listener);

  @override
  vc.DisposeFunction once<T extends vc.VyuhEvent>(
    vc.VyuhEventListener<T> listener,
  ) => inner.once<T>(listener);
}

/// A telemetry provider that fails on every call it is told to.
final class _BrokenTelemetry implements vc.TelemetryProvider {
  final Set<String> failing;
  final errors = <(Object?, StackTrace?, Map<String, dynamic>?, bool)>[];
  final messages = <(vc.LogLevel?, String)>[];

  _BrokenTelemetry([this.failing = const {}]);

  Future<T> _maybeFail<T>(String call, T value) => failing.contains(call)
      ? Future.error(StateError(call))
      : Future.value(value);

  @override
  String get name => 'test.broken';

  @override
  String get title => 'Broken';

  @override
  String get description => 'Broken';

  @override
  Future<void> init() => _maybeFail('init', null);

  @override
  Future<void> dispose() => _maybeFail('dispose', null);

  @override
  Future<void> reportError(
    exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) {
    errors.add((exception, stackTrace, params, fatal));
    return _maybeFail('reportError', null);
  }

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
  }) {
    messages.add((level, message));
    return _maybeFail('reportMessage', null);
  }

  @override
  Future<vc.Trace> startTrace(
    String name,
    String operation, {
    vc.LogLevel? level = vc.LogLevel.info,
  }) => failing.contains('startTrace')
      ? Future.error(StateError('startTrace'))
      : Future.value(_BrokenTrace(failing));
}

final class _BrokenTrace extends vc.Trace {
  final Set<String> failing;
  _BrokenTrace(this.failing);

  @override
  void setMetric(String name, int value) {}

  @override
  int getMetric(String name) => 0;

  @override
  void setAttributes(Map<String, String> attributes) {}

  @override
  Map<String, String> getAttributes() => const {};

  @override
  Future<void> stop() => failing.contains('stop')
      ? Future.error(StateError('stop'))
      : Future.value();

  @override
  Future<vc.Trace> startChild(
    String name,
    String operation, {
    vc.LogLevel? level = vc.LogLevel.info,
  }) => failing.contains('startChild')
      ? Future.error(StateError('startChild'))
      : Future.value(_BrokenTrace(failing));
}

final class _Analytics implements vc.AnalyticsProvider {
  final bool broken;
  final events = <String>[];
  final calls = <String>[];

  _Analytics({this.broken = false});

  Future<void> _call(String name) {
    calls.add(name);
    if (broken) throw StateError('analytics is down');
    return Future.value();
  }

  @override
  String get name => 'test.analytics';

  @override
  String get title => 'Analytics';

  @override
  String get description => 'Analytics';

  @override
  List<NavigatorObserver> get observers => const [];

  @override
  Future<void> init() => _call('init');

  @override
  Future<void> dispose() => _call('dispose');

  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) {
    events.add(name);
    return _call('reportEvent');
  }

  @override
  Future<void> identifyUser(String userId, {Map<String, dynamic>? traits}) =>
      _call('identifyUser');

  @override
  Future<void> resetUser() => _call('resetUser');
}

final class _TestAuth extends vc.AuthPlugin {
  _TestAuth() : super(name: 'test.auth', title: 'Test Auth');

  @override
  String get token => '';

  @override
  String get refreshToken => '';

  void signIn(vc.User user) => setCurrentUser(user);
}

/// Counts requests and fails the first [failures] of them with a timeout.
final class _FlakyClient extends http.BaseClient {
  int failures;
  int requests = 0;
  final Duration delay;

  _FlakyClient({this.failures = 0, this.delay = Duration.zero});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests++;
    if (failures > 0) {
      failures--;
      throw TimeoutException('slow');
    }
    await Future<void>.delayed(delay);
    return http.StreamedResponse(Stream.value([104, 105]), 200);
  }
}

const _fastRetry = RetryOptions(maxAttempts: 3, delayFactor: Duration.zero);

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  group('preloaded plugins', () {
    testWidgets(
      'a failing preloaded plugin fails startup; restart retries it',
      (tester) async {
        final events = _FlakyEvents();
        vc.runApp(
          plugins: vc.PluginDescriptor(event: events),
          features: () => [
            vc.FeatureDescriptor(
              name: 'home',
              title: 'Home',
              routes: () => [
                GoRoute(path: '/', builder: (_, _) => const Text('home')),
              ],
            ),
          ],
        );
        await vc.vyuh.getReady(tester);
        await tester.pumpAndSettle();
        expect(vc.vyuh.tracker.currentState.value, vc.InitState.error);
        expect(vc.vyuh.tracker.error, isA<StateError>());
        expect(find.text(vc.VyuhStrings.current.appStartFailedTitle), findsOne);

        await tester.runAsync(() => vc.vyuh.restart());
        await tester.pumpAndSettle();
        expect(events.attempts, 2);
        expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
        expect(find.text('home'), findsOneWidget);
      },
    );
  });

  group('TelemetryPlugin isolation', () {
    test('init, dispose, traces and stops survive a broken provider', () async {
      final broken = _BrokenTelemetry({
        'init',
        'dispose',
        'startTrace',
        'startChild',
        'stop',
      });
      final healthy = _BrokenTelemetry();
      final telemetry = vc.TelemetryPlugin(providers: [broken, healthy]);

      await telemetry.init();
      final trace = await telemetry.startTrace('a', 'b');
      final child = await trace.startChild('c', 'd');
      await child.stop();
      await trace.stop();

      // A provider whose startTrace failed gets a no-op trace, so its
      // children and stops are skipped while the healthy one keeps tracing.
      final healthyTrace = await vc.TelemetryPlugin(
        providers: [
          _BrokenTelemetry({'startChild', 'stop'}),
        ],
      ).startTrace('a', 'b');
      await (await healthyTrace.startChild('c', 'd')).stop();
      await healthyTrace.stop();

      await telemetry.dispose();
    });

    test('trace waits for the error report before rethrowing', () async {
      final provider = _BrokenTelemetry();
      final telemetry = vc.TelemetryPlugin(providers: [provider]);
      await expectLater(
        telemetry.trace<void>(
          name: 'work',
          operation: 'run',
          fn: (_) => throw StateError('boom'),
        ),
        throwsStateError,
      );
      expect(provider.errors.single.$1, isA<StateError>());
    });

    test('log levels run from least to most severe', () {
      expect(vc.LogLevel.values, [
        vc.LogLevel.trace,
        vc.LogLevel.debug,
        vc.LogLevel.info,
        vc.LogLevel.warning,
        vc.LogLevel.error,
        vc.LogLevel.fatal,
      ]);
    });
  });

  group('Logger', () {
    testWidgets('logs any value and reports errors with their stack', (
      tester,
    ) async {
      final provider = _BrokenTelemetry();
      vc.runApp(
        plugins: vc.PluginDescriptor(
          telemetry: vc.TelemetryPlugin(providers: [provider]),
        ),
        features: () => [
          vc.FeatureDescriptor(
            name: 'home',
            title: 'Home',
            routes: () => [
              GoRoute(path: '/', builder: (_, _) => const Text('home')),
            ],
          ),
        ],
      );
      await vc.vyuh.getReady(tester);

      final stack = StackTrace.current;
      vc.vyuh.log.info(42);
      vc.vyuh.log.error('save failed', error: 'disk', stackTrace: stack);
      vc.vyuh.log.fatal('gone', error: 'db');
      vc.vyuh.log.warn('no error, no report');

      expect(provider.messages, contains((vc.LogLevel.info, '42')));
      expect(provider.errors.map((e) => (e.$1, e.$2, e.$4)), [
        ('disk', stack, false),
        ('db', null, true),
      ]);
      expect(provider.errors.map((e) => e.$3), [
        {'message': 'save failed'},
        {'message': 'gone'},
      ]);
    });
  });

  group('AnalyticsPlugin isolation', () {
    test('a broken provider never stops the others', () async {
      final broken = _Analytics(broken: true);
      final healthy = _Analytics();
      final analytics = vc.AnalyticsPlugin(providers: [broken, healthy]);

      await analytics.init();
      await analytics.reportEvent('checkout');
      await analytics.identifyUser('u1');
      await analytics.resetUser();
      await analytics.dispose();

      expect(healthy.events, ['checkout']);
      expect(healthy.calls, [
        'init',
        'reportEvent',
        'identifyUser',
        'resetUser',
        'dispose',
      ]);
      expect(broken.calls, healthy.calls);
    });
  });

  group('AuthPlugin', () {
    testWidgets('setting the user emits UserChangedEvent', (tester) async {
      final auth = _TestAuth();
      vc.runApp(
        plugins: vc.PluginDescriptor(auth: auth),
        features: () => [
          vc.FeatureDescriptor(
            name: 'home',
            title: 'Home',
            routes: () => [
              GoRoute(path: '/', builder: (_, _) => const Text('home')),
            ],
          ),
        ],
      );
      await vc.vyuh.getReady(tester);

      final seen = <vc.User>[];
      final cancel = vc.vyuh.event.on<vc.UserChangedEvent>(
        (event) => seen.add(event.user),
      );
      const user = vc.User(
        id: 'u1',
        name: 'Ada',
        loginMethod: vc.LoginMethod.emailPassword,
      );
      auth.signIn(user);
      await tester.pump();
      cancel();

      expect(seen, [user]);
      expect(vc.UserChangedEvent(user).name, 'vyuh.auth.user_changed');
    });

    test('works without a platform, and dispose signs out locally', () async {
      final auth = _TestAuth();
      await auth.init();
      const user = vc.User(
        id: 'u1',
        name: 'Ada',
        loginMethod: vc.LoginMethod.emailPassword,
      );
      auth.signIn(user);
      expect(auth.currentUser, user);

      await auth.dispose();
      expect(auth.currentUser, vc.User.unknown);
    });
  });

  group('EventPlugin.once', () {
    test('returns a handle that cancels before the event arrives', () async {
      final events = vc.DefaultEventPlugin();
      await events.init();
      var calls = 0;
      final cancel = events.once<vc.SystemReadyEvent>((_) => calls++);
      cancel();
      events.emit(vc.SystemReadyEvent());
      await Future<void>.delayed(Duration.zero);
      expect(calls, 0);

      events.once<vc.SystemReadyEvent>((_) => calls++);
      events.emit(vc.SystemReadyEvent());
      events.emit(vc.SystemReadyEvent());
      await Future<void>.delayed(Duration.zero);
      expect(calls, 1);
      await events.dispose();
    });
  });

  group('defaults', () {
    test('in-memory stores report a deleted null value as deleted', () async {
      final memory = vc.InMemoryStoragePlugin();
      await memory.init();
      await memory.write('empty', null);
      expect(await memory.delete('empty'), isTrue);
      expect(await memory.delete('empty'), isFalse);
      await memory.dispose();

      final secure = vc.InMemorySecureStoragePlugin();
      await secure.init();
      await secure.write('empty', null);
      expect(await secure.delete('empty'), isTrue);
      expect(await secure.delete('empty'), isFalse);
      await secure.dispose();
    });

    test('the default plugins are exported', () {
      expect(vc.UnknownAuthPlugin().currentUser, vc.User.unknown);
      expect(vc.NoOpEnvPlugin().maybeGet('A', fallback: 'b'), 'b');
    });

    test('GetItDIPlugin names its container', () {
      expect(vc.GetItDIPlugin().toString(), 'GetItDIPlugin');
      expect(
        vc.GetItDIPlugin(debugLabel: 'doc').toString(),
        'GetItDIPlugin(doc)',
      );
    });
  });

  group('HttpNetworkPlugin', () {
    test(
      'read and readBytes retry and time out like the other calls',
      () async {
        final client = _FlakyClient(failures: 2);
        final network = vc.HttpNetworkPlugin(
          client: client,
          retryOptions: _fastRetry,
        );
        expect(await network.read(Uri.parse('https://x.test')), 'hi');
        expect(client.requests, 3);

        client.failures = 1;
        expect(
          await network.readBytes(Uri.parse('https://x.test')),
          Uint8List.fromList([104, 105]),
        );
        await network.dispose();
      },
    );

    test('send times out and is not retried', () async {
      final client = _FlakyClient(delay: const Duration(milliseconds: 50));
      final network = vc.HttpNetworkPlugin(
        client: client,
        retryOptions: _fastRetry,
        timeout: const Duration(milliseconds: 1),
      );
      await expectLater(
        network.send(http.Request('GET', Uri.parse('https://x.test'))),
        throwsA(isA<TimeoutException>()),
      );
      expect(client.requests, 1);
      await network.dispose();
    });
  });

  group('LocalePlugin', () {
    testWidgets('setLocale uses the configured locale for the language', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final locale = vc.LocalePlugin(
        locales: const [
          vc.LocaleConfiguration(
            locale: Locale('en'),
            nativeName: 'English',
            icon: 'E',
          ),
          vc.LocaleConfiguration(
            locale: Locale('hi'),
            nativeName: 'हिन्दी',
            icon: 'H',
          ),
        ],
      );
      expect(locale.name, 'vyuh.plugin.locale');
      vc.runApp(
        plugins: vc.PluginDescriptor(others: [locale]),
        features: () => [
          vc.FeatureDescriptor(
            name: 'home',
            title: 'Home',
            routes: () => [
              GoRoute(path: '/', builder: (_, _) => const Text('home')),
            ],
          ),
        ],
      );
      await vc.vyuh.getReady(tester);

      await tester.runAsync(() => locale.setLocale(const Locale('hi', 'IN')));
      expect(locale.currentLocale.value, const Locale('hi'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_locale'), 'hi');

      await tester.runAsync(locale.dispose);
      expect(locale.currentLocale.value, const Locale('en'));
    });
  });
}
