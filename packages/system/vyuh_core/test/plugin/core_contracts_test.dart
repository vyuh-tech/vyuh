import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class _Descriptor extends ExtensionDescriptor {
  _Descriptor() : super(title: 'Descriptor');

  int updates = 0;

  @override
  void onSourceFeatureUpdated() => updates++;
}

final class _Builder extends ExtensionBuilder<_Descriptor> {
  _Builder() : super(extensionType: _Descriptor, title: 'Builder');

  List<_Descriptor> received = [];

  @override
  Future<void> onInit(List<_Descriptor> extensions) async {
    received = extensions;
  }
}

final class _Other extends ExtensionDescriptor {
  _Other() : super(title: 'Other');

  @override
  void onSourceFeatureUpdated() {}
}

final class _CountingPlugin extends Plugin with InitOncePlugin {
  _CountingPlugin() : super(name: 'counting', title: 'Counting');

  int opens = 0;
  int closes = 0;
  final Completer<void> closing = Completer<void>();

  @override
  Future<void> initOnce() async => opens++;

  @override
  Future<void> disposeOnce() async {
    await closing.future;
    closes++;
  }
}

final class _Flags extends FeatureFlagPlugin<String, int> {
  _Flags() : super(settings: 'remote', name: 'flags', title: 'Flags');

  int? context;

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> getBool(String featureName, {bool defaultValue = false}) async =>
      defaultValue;

  @override
  Future<double> getDouble(
    String featureName, {
    double defaultValue = 0.0,
  }) async => defaultValue;

  @override
  Future<int> getInt(String featureName, {int defaultValue = 0}) async =>
      defaultValue;

  @override
  Future<Map<String, dynamic>> getJson(
    String featureName, {
    Map<String, dynamic> defaultValue = const {},
  }) async => defaultValue;

  @override
  Future<String> getString(
    String featureName, {
    String defaultValue = '',
  }) async => defaultValue;

  @override
  Future<void> refresh() async {}

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {}

  @override
  Future<void> updateContext(int context) async => this.context = context;
}

void main() {
  group('debugAssertOneOfPathOrRouteId', () {
    test('accepts exactly one of path or routeId', () {
      expect(
        () => debugAssertOneOfPathOrRouteId('/home', null),
        returnsNormally,
      );
      expect(
        () => debugAssertOneOfPathOrRouteId(null, 'route'),
        returnsNormally,
      );
    });

    test('rejects both or neither', () {
      expect(
        () => debugAssertOneOfPathOrRouteId('/home', 'route'),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => debugAssertOneOfPathOrRouteId(null, null),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ExtensionDescriptor', () {
    test('records its source feature and notifies the subclass', () {
      final descriptor = _Descriptor();
      expect(descriptor.sourceFeature, isNull);

      descriptor.setSourceFeature('blog');

      expect(descriptor.sourceFeature, 'blog');
      expect(descriptor.updates, 1);
    });
  });

  group('ExtensionBuilder', () {
    test('records its source feature', () {
      final builder = _Builder();
      expect(builder.sourceFeature, isNull);
      builder.setSourceFeature('blog');
      expect(builder.sourceFeature, 'blog');
    });

    test('passes only its own descriptor type to onInit', () async {
      final builder = _Builder();
      final mine = _Descriptor();

      await builder.init([mine, _Other()]);

      expect(builder.received, [mine]);
      expect(builder.isInitialized, isTrue);
    });

    test('refuses a second init while initialized', () async {
      final builder = _Builder();
      await builder.init([]);

      expect(() => builder.init([]), throwsStateError);
    });

    test('can be initialized again after dispose', () async {
      final builder = _Builder();
      await builder.init([]);
      await builder.dispose();
      expect(builder.isDisposed, isTrue);
      expect(builder.isInitialized, isFalse);

      await builder.init([]);
      expect(builder.isInitialized, isTrue);
      expect(builder.isDisposed, isFalse);
    });

    test('registerLazy is a no-op by default', () {
      expect(() => _Builder().registerLazy(_Descriptor()), returnsNormally);
    });

    test('captureLazyState is unsupported by default', () {
      expect(
        () => _Builder().captureLazyState(_Descriptor()),
        throwsA(
          isA<UnsupportedError>().having(
            (e) => e.message,
            'message',
            contains('Builder does not support transactional lazy'),
          ),
        ),
      );
    });
  });

  group('InitOncePlugin', () {
    test('init during disposal waits for disposal, then reopens', () async {
      final plugin = _CountingPlugin();
      await plugin.init();
      expect(plugin.opens, 1);

      final disposal = plugin.dispose();
      final reopen = plugin.init();

      // The reopen must not start before the disposal finishes.
      await pumpEventQueue();
      expect(plugin.opens, 1);
      expect(plugin.closes, 0);

      plugin.closing.complete();
      await disposal;
      await reopen;

      expect(plugin.closes, 1);
      expect(plugin.opens, 2);
      expect(plugin.initialized, isTrue);
    });
  });

  group('PluginDescriptor.systemPluginTypes', () {
    test('lists every system plugin type once', () {
      expect(PluginDescriptor.systemPluginTypes, [
        DIPlugin,
        AnalyticsPlugin,
        TelemetryPlugin,
        NetworkPlugin,
        AuthPlugin,
        NavigationPlugin,
        EnvPlugin,
        EventPlugin,
        StoragePlugin,
        SecureStoragePlugin,
      ]);
    });
  });

  group('FeatureFlagPlugin', () {
    test('keeps its settings and identity', () async {
      final flags = _Flags();
      expect(flags.settings, 'remote');
      expect(flags.name, 'flags');
      expect(flags.title, 'Flags');

      await flags.updateContext(42);
      expect(flags.context, 42);
      expect(await flags.getBool('x', defaultValue: true), isTrue);
    });
  });
}
