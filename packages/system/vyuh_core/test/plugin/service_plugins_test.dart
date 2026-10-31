import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vyuh_core/plugin/network/http_network_plugin_stub.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class _Observer extends NavigatorObserver {}

final class _RecordingAnalytics implements AnalyticsProvider {
  _RecordingAnalytics(this.name);

  @override
  final String name;

  final calls = <String>[];
  final observer = _Observer();

  @override
  String get title => name;

  @override
  String get description => name;

  @override
  List<NavigatorObserver> get observers => [observer];

  @override
  Future<void> init() async => calls.add('init');

  @override
  Future<void> dispose() async => calls.add('dispose');

  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) async =>
      calls.add('event $name $params');

  @override
  Future<void> identifyUser(
    String userId, {
    Map<String, dynamic>? traits,
  }) async => calls.add('identify $userId $traits');

  @override
  Future<void> resetUser() async => calls.add('reset');
}

final class _RecordingTrace extends Trace {
  _RecordingTrace(this.label);

  final String label;
  final attributes = <String, String>{};
  final metrics = <String, int>{};
  final children = <_RecordingTrace>[];
  bool stopped = false;

  @override
  Map<String, String> getAttributes() => Map.of(attributes);

  @override
  int getMetric(String name) => metrics[name] ?? -1;

  @override
  void setAttributes(Map<String, String> attributes) =>
      this.attributes.addAll(attributes);

  @override
  void setMetric(String name, int value) => metrics[name] = value;

  @override
  Future<void> stop() async => stopped = true;

  @override
  Future<Trace> startChild(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) async {
    final child = _RecordingTrace('$label/$name');
    children.add(child);
    return child;
  }
}

final class _TracingProvider extends _NoOpDelegate {
  _TracingProvider(this.label);

  final String label;
  final traces = <_RecordingTrace>[];

  @override
  Future<Trace> startTrace(
    String name,
    String operation, {
    LogLevel? level = LogLevel.info,
  }) async {
    final trace = _RecordingTrace('$label:$name');
    traces.add(trace);
    return trace;
  }
}

/// Delegates everything except [startTrace] to the no-op provider.
abstract class _NoOpDelegate implements TelemetryProvider {
  final _noop = NoOpTelemetryProvider();

  @override
  String get name => _noop.name;

  @override
  String get title => _noop.title;

  @override
  String get description => _noop.description;

  @override
  Future<void> init() => _noop.init();

  @override
  Future<void> dispose() => _noop.dispose();

  @override
  Future<void> reportError(
    exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? params,
    bool fatal = false,
  }) => _noop.reportError(exception);

  @override
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    bool fatal = false,
  }) => _noop.reportFlutterError(details);

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? params,
    LogLevel? level = LogLevel.info,
  }) => _noop.reportMessage(message);
}

void main() {
  group('AnalyticsPlugin', () {
    late _RecordingAnalytics first;
    late _RecordingAnalytics second;
    late AnalyticsPlugin analytics;

    setUp(() {
      first = _RecordingAnalytics('first');
      second = _RecordingAnalytics('second');
      analytics = AnalyticsPlugin(providers: [first, second]);
    });

    test('describes itself', () {
      expect(analytics.description, 'Analytics Plugin');
      expect(analytics.observers, [first.observer, second.observer]);
    });

    test('fans every call out to all providers', () async {
      await analytics.init();
      await analytics.reportEvent('clicked', params: {'id': 1});
      await analytics.identifyUser('u1', traits: {'plan': 'pro'});
      await analytics.resetUser();
      await analytics.dispose();

      const expected = [
        'init',
        'event clicked {id: 1}',
        'identify u1 {plan: pro}',
        'reset',
        'dispose',
      ];
      expect(first.calls, expected);
      expect(second.calls, expected);
    });
  });

  group('NoOpAnalyticsProvider', () {
    test('accepts every call and reports nothing', () async {
      final provider = NoOpAnalyticsProvider();
      expect(provider.name, 'vyuh.plugin.analytics.provider.noop');
      expect(provider.title, 'No Op Analytics Provider');
      expect(provider.description, contains('No events will be sent'));
      expect(provider.observers, isEmpty);

      await provider.init();
      await provider.reportEvent('e', params: {'a': 1});
      await provider.identifyUser('u', traits: {'b': 2});
      await provider.resetUser();
      await provider.dispose();
    });
  });

  group('GetItDIPlugin', () {
    late GetItDIPlugin di;

    setUp(() async {
      di = GetItDIPlugin(debugLabel: 'test');
      await di.init();
    });

    tearDown(() => di.dispose());

    test('registers and resolves singletons, by type and by name', () {
      final a = _Service();
      final b = _Service();
      di.register<_Service>(a);
      di.register<_Service>(b, name: 'b');

      expect(di.get<_Service>(), same(a));
      expect(di.get<_Service>(name: 'b'), same(b));
      expect(di.has<_Service>(name: 'b'), isTrue);
      expect(di.debugLabel, 'test');
    });

    test('a factory builds a new instance on every get', () {
      var built = 0;
      di.registerFactory<List<int>>(() => [++built]);

      expect(di.get<List<int>>(), [1]);
      expect(di.get<List<int>>(), [2]);
    });

    test('a lazy singleton is built once, on first get', () {
      var built = 0;
      di.registerLazy<List<int>>(() => [++built]);
      expect(built, 0);

      final first = di.get<List<int>>();
      expect(di.get<List<int>>(), same(first));
      expect(built, 1);
    });

    test('unregister removes a registration', () {
      di.register<String>('x', name: 'x');
      di.unregister<String>(name: 'x');
      expect(di.has<String>(name: 'x'), isFalse);
    });

    test('reset clears every registration', () async {
      di.register<String>('x');
      await di.reset();
      expect(di.has<String>(), isFalse);
    });

    test('async registrations resolve lazily to the same future', () async {
      var built = 0;
      di.registerAsync<String>(() async => 'service ${++built}', name: 's');
      expect(built, 0);

      final first = di.getAsync<String>(name: 's');
      expect(await first, 'service 1');
      expect(di.getAsync<String>(name: 's'), same(first));
      expect(built, 1);
    });
  });

  group('DefaultEnvPlugin', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
            final key = utf8.decode(message!.buffer.asUint8List());
            if (key != 'test-assets/app.env') return null;
            return ByteData.sublistView(
              utf8.encode('API_URL=https://api.test\nMODE=file\n'),
            );
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
      dotenv.clean();
    });

    test('loads the env file, merged with defaults', () async {
      final env = DefaultEnvPlugin(
        fileName: 'test-assets/app.env',
        // MODE is also set in the file: the file wins over a default.
        defaults: {'ONLY_DEFAULT': 'yes', 'MODE': 'default'},
      );
      await env.init();

      expect(env.get('API_URL'), 'https://api.test');
      expect(env.get('MODE'), 'file');
      expect(env.get('ONLY_DEFAULT'), 'yes');
      expect(env.get('MISSING', fallback: 'fb'), 'fb');
      expect(env.maybeGet('MISSING'), isNull);
      expect(env.maybeGet('MISSING', fallback: 'fb'), 'fb');
      expect(env.all(), containsPair('API_URL', 'https://api.test'));
    });

    test('clear and dispose drop all values until the next init', () async {
      final env = DefaultEnvPlugin(fileName: 'test-assets/app.env');
      expect(env.fileName, 'test-assets/app.env');
      expect(env.defaults, isEmpty);

      await env.init();
      env.clear();
      expect(env.all, throwsA(isA<NotInitializedError>()));

      await env.init();
      expect(env.get('MODE'), 'file');
      await env.dispose();
      expect(() => env.maybeGet('MODE'), throwsA(isA<NotInitializedError>()));
    });
  });

  group('NoOpEnvPlugin', () {
    test('holds no values and rejects required reads', () async {
      final env = NoOpEnvPlugin();
      await env.init();

      expect(env.all(), isEmpty);
      expect(env.maybeGet('A', fallback: 'b'), 'b');
      expect(() => env.get('A'), throwsUnsupportedError);

      env.clear();
      await env.dispose();
      expect(env.fileName, '.env');
      expect(env.defaults, isEmpty);
    });
  });

  for (final (label, create) in [
    ('InMemoryStoragePlugin', () => _StorageApi.plain(InMemoryStoragePlugin())),
    (
      'InMemorySecureStoragePlugin',
      () => _StorageApi.secure(InMemorySecureStoragePlugin()),
    ),
  ]) {
    group(label, () {
      test('writes, reads, checks and deletes values', () async {
        final storage = create();
        await storage.plugin.init();

        expect(await storage.read('k'), isNull);
        expect(await storage.has('k'), isFalse);

        expect(await storage.write('k', 42), 42);
        expect(await storage.read('k'), 42);
        expect(await storage.has('k'), isTrue);

        expect(await storage.delete('k'), isTrue);
        expect(await storage.delete('k'), isFalse);
        expect(await storage.has('k'), isFalse);
      });

      test('dispose discards stored values', () async {
        final storage = create();
        await storage.plugin.init();
        await storage.write('k', 'v');

        await storage.plugin.dispose();
        await storage.plugin.init();

        expect(await storage.has('k'), isFalse);
      });
    });
  }

  group('HttpNetworkPlugin', () {
    test('creates and closes its own client when none is given', () async {
      final network = HttpNetworkPlugin(timeout: const Duration(seconds: 1));
      await network.init();
      // A second init keeps the existing client.
      await network.init();
      await network.dispose();
      // Disposing twice is safe.
      await network.dispose();
    });

    test('send forwards a raw request to the client', () async {
      final network = HttpNetworkPlugin(
        client: MockClient((request) async {
          expect(request.method, 'PUT');
          expect(request.url.path, '/raw');
          return http.Response('sent ${request.body}', 201);
        }),
      );

      final request = http.Request('PUT', Uri.parse('https://example.com/raw'))
        ..body = 'payload';
      final response = await network.send(request);

      expect(response.statusCode, 201);
      expect(await response.stream.bytesToString(), 'sent payload');
    });

    test('close leaves the shared client open; dispose closes it', () async {
      var closed = false;
      final client = _ClosingClient(() => closed = true);
      final network = HttpNetworkPlugin(client: client);

      network.close();
      expect(closed, isFalse);

      await network.dispose();
      expect(closed, isTrue);

      // Disposed, so init makes a new client.
      await network.init();
      await network.dispose();
    });

    test('createWebClient is unsupported off the web', () {
      expect(createWebClient, throwsUnsupportedError);
    });
  });

  group('NoOpTelemetryProvider', () {
    test('accepts every call and records nothing', () async {
      final provider = NoOpTelemetryProvider();
      expect(provider.name, 'vyuh.plugin.telemetry.provider.noop');
      expect(provider.title, 'No Op Telemetry Provider');
      expect(provider.description, contains('No events will be sent'));

      await provider.init();
      await provider.reportError(StateError('x'), fatal: true);
      await provider.reportFlutterError(
        FlutterErrorDetails(exception: StateError('x')),
      );
      await provider.reportMessage('hello', level: LogLevel.warning);
      await provider.dispose();
    });

    test('NoOpTrace keeps no state', () async {
      final trace = await NoOpTelemetryProvider().startTrace('t', 'op');
      expect(trace, isA<NoOpTrace>());

      trace.setAttributes({'a': 'b'});
      trace.setMetric('m', 3);
      expect(trace.getAttributes(), isEmpty);
      expect(trace.getMetric('m'), 0);

      expect(await trace.startChild('c', 'op'), isA<NoOpTrace>());
      await trace.stop();
    });
  });

  group('TelemetryPlugin composite trace', () {
    late _TracingProvider first;
    late _TracingProvider second;
    late TelemetryPlugin telemetry;

    setUp(() {
      first = _TracingProvider('first');
      second = _TracingProvider('second');
      telemetry = TelemetryPlugin(providers: [first, second]);
    });

    test('describes itself', () {
      expect(telemetry.description, 'Telemetry Plugin');
    });

    test('writes go to every provider trace', () async {
      final trace = await telemetry.startTrace('load', 'op');

      trace.setAttributes({'feature': 'blog'});
      trace.setMetric('items', 7);

      for (final t in [first.traces.single, second.traces.single]) {
        expect(t.attributes, {'feature': 'blog'});
        expect(t.metrics, {'items': 7});
      }
    });

    test('reads come from the first provider trace', () async {
      final trace = await telemetry.startTrace('load', 'op');
      first.traces.single
        ..attributes['source'] = 'first'
        ..metrics['m'] = 1;
      second.traces.single
        ..attributes['source'] = 'second'
        ..metrics['m'] = 2;

      expect(trace.getAttributes(), {'source': 'first'});
      expect(trace.getMetric('m'), 1);
    });

    test('reads fall back to empty values without providers', () async {
      final trace = await TelemetryPlugin(providers: []).startTrace('t', 'op');
      expect(trace.getAttributes(), isEmpty);
      expect(trace.getMetric('m'), 0);
    });

    test('child traces and stop reach every provider trace', () async {
      final trace = await telemetry.startTrace('load', 'op');
      final child = await trace.startChild('step', 'op');
      child.setMetric('n', 1);
      await child.stop();
      await trace.stop();

      for (final t in [first.traces.single, second.traces.single]) {
        expect(t.stopped, isTrue);
        expect(t.children.single.metrics, {'n': 1});
        expect(t.children.single.stopped, isTrue);
      }
    });
  });
}

final class _Service {}

final class _ClosingClient extends http.BaseClient {
  _ClosingClient(this.onClose);

  final void Function() onClose;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      throw UnimplementedError();

  @override
  void close() => onClose();
}

/// A common view over the two in-memory storage plugins, which share an API
/// but no type.
final class _StorageApi {
  _StorageApi.plain(InMemoryStoragePlugin p)
    : plugin = p,
      read = p.read,
      write = p.write,
      has = p.has,
      delete = p.delete;

  _StorageApi.secure(InMemorySecureStoragePlugin p)
    : plugin = p,
      read = p.read,
      write = p.write,
      has = p.has,
      delete = p.delete;

  final Plugin plugin;
  final Future<dynamic> Function(String) read;
  final Future<dynamic> Function(String, dynamic) write;
  final Future<bool> Function(String) has;
  final Future<bool> Function(String) delete;
}
