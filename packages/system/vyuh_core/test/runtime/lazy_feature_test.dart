import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import 'helpers.dart';

/// Flags read from a map; missing flags use their default.
final class _Flags extends vc.FeatureFlagPlugin<Map<String, bool>, void> {
  _Flags(Map<String, bool> flags)
    : super(settings: flags, name: 'test.flags', title: 'Flags');

  @override
  Future<bool> getBool(String featureName, {bool defaultValue = false}) async =>
      settings[featureName] ?? defaultValue;

  @override
  Future<String> getString(String featureName, {String defaultValue = ''}) =>
      throw UnimplementedError();

  @override
  Future<int> getInt(String featureName, {int defaultValue = 0}) =>
      throw UnimplementedError();

  @override
  Future<double> getDouble(String featureName, {double defaultValue = 0.0}) =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> getJson(
    String featureName, {
    Map<String, dynamic> defaultValue = const {},
  }) => throw UnimplementedError();

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {}

  @override
  Future<void> updateContext(void context) async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}
}

/// An event plugin that cannot deliver [vc.FeatureLoadedEvent]s.
final class _FailingLoadedEvents extends vc.EventPlugin {
  final inner = vc.DefaultEventPlugin();

  _FailingLoadedEvents() : super(name: 'test.events', title: 'Events');

  @override
  void emit<T extends vc.VyuhEvent>(T event) {
    if (event is vc.FeatureLoadedEvent) throw StateError('bus is down');
    inner.emit(event);
  }

  @override
  vc.DisposeFunction on<T extends vc.VyuhEvent>(
    vc.VyuhEventListener<T> listener,
  ) => inner.on<T>(listener);

  @override
  vc.DisposeFunction once<T extends vc.VyuhEvent>(
    vc.VyuhEventListener<T> listener,
  ) => inner.once<T>(listener);

  @override
  Future<void> init() => inner.init();

  @override
  Future<void> dispose() => inner.dispose();
}

vc.LazyFeatureDescriptor _lazy(
  String name, {
  List<String> dependencies = const [],
  String? featureFlag,
  Future<vc.FeatureDescriptor> Function()? loader,
}) => vc.LazyFeatureDescriptor(
  name: name,
  title: name.toUpperCase(),
  routePrefixes: ['/$name'],
  dependencies: dependencies,
  featureFlag: featureFlag,
  loader:
      loader ??
      () async => feature(name, routes: [page('/$name'), page('/$name/sub')]),
);

void main() {
  tearDown(disposePlatform);

  testWidgets('navigating to a lazy route loads the feature, then opens the '
      'exact location', (tester) async {
    vc.runApp(features: () => [home()], lazyFeatures: () => [_lazy('reports')]);
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/reports/sub');
    await tester.pumpAndSettle();

    expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);
    expect(find.text('page /reports/sub'), findsOneWidget);
  });

  testWidgets('a failed lazy route can be retried from the failure page', (
    tester,
  ) async {
    var attempts = 0;
    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [
        _lazy(
          'reports',
          loader: () async {
            if (++attempts == 1) throw StateError('offline');
            return feature('reports', routes: [page('/reports')]);
          },
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/reports');
    await tester.pumpAndSettle();
    expect(find.text('Could not load REPORTS'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('page /reports'), findsOneWidget);
  });

  testWidgets('a lazy feature turned off by its flag shows why, with no '
      'retry', (tester) async {
    final failures = <vc.VyuhFailure>[];
    vc.runApp(
      plugins: vc.PluginDescriptor(
        others: [
          _Flags({'reports.enabled': false}),
        ],
      ),
      features: () => [
        feature('home', routes: [page('/')]),
      ],
      lazyFeatures: () => [_lazy('reports', featureFlag: 'reports.enabled')],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();
    final cancel = vc.vyuh.event.on<vc.FeatureLoadFailedEvent>(
      (e) => failures.add(e.failure),
    );
    addTearDown(cancel);

    vc.vyuh.router.go('/reports');
    await tester.pumpAndSettle();

    expect(find.text('REPORTS is not available'), findsOneWidget);
    expect(
      find.text('This part of the app is turned off right now.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsNothing);
    expect(failures.single.kind, vc.FailureKind.featureDisabled);
    expect(
      failures.single.error.toString(),
      'Feature "reports" is disabled (flag: "reports.enabled")',
    );
    expect(vc.vyuh.isFeatureLoaded('reports'), isFalse);
  });

  testWidgets('a lazy feature whose flag is on loads', (tester) async {
    vc.runApp(
      plugins: vc.PluginDescriptor(
        others: [
          _Flags({'reports.enabled': true}),
        ],
      ),
      features: () => [home()],
      lazyFeatures: () => [_lazy('reports', featureFlag: 'reports.enabled')],
    );
    await vc.vyuh.getReady(tester);

    await vc.vyuh.loadFeature('reports');
    expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);
  });

  testWidgets('a flag is ignored when no feature flag plugin is registered', (
    tester,
  ) async {
    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [_lazy('reports', featureFlag: 'reports.enabled')],
    );
    await vc.vyuh.getReady(tester);

    await vc.vyuh.loadFeature('reports');
    expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);
  });

  testWidgets('lazy dependencies load first, and eager ones are awaited', (
    tester,
  ) async {
    final order = <String>[];
    Future<vc.FeatureDescriptor> load(String name) async {
      order.add(name);
      return feature(name);
    }

    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [
        _lazy('base', loader: () => load('base')),
        _lazy(
          'reports',
          dependencies: ['base', 'home'],
          loader: () => load('reports'),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    await vc.vyuh.loadFeature('reports');
    expect(order, ['base', 'reports']);
    expect(vc.vyuh.isFeatureLoaded('base'), isTrue);

    // An already loaded lazy dependency is not loaded again.
    vc.vyuh.router.go('/reports');
    await tester.pumpAndSettle();
    expect(order, ['base', 'reports']);
  });

  testWidgets('a lazy dependency that is not registered fails startup', (
    tester,
  ) async {
    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [
        _lazy('reports', dependencies: ['missing']),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(
      vc.vyuh.tracker.error,
      isA<StateError>().having(
        (e) => e.message,
        'message',
        'No feature registered for dependency: missing',
      ),
    );
  });

  testWidgets('loading an unknown feature fails', (tester) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);

    await expectLater(
      vc.vyuh.loadFeature('nope'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'No lazy feature registered with name: nope',
        ),
      ),
    );
  });

  testWidgets('a loader that returns a differently named feature fails', (
    tester,
  ) async {
    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [
        _lazy('reports', loader: () async => feature('other')),
      ],
    );
    await vc.vyuh.getReady(tester);

    await expectLater(
      vc.vyuh.loadFeature('reports'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('loaded a descriptor named "other"'),
        ),
      ),
    );
    expect(vc.vyuh.isFeatureLoaded('reports'), isFalse);
  });

  testWidgets('a lifecycle event that cannot be emitted does not fail the '
      'load', (tester) async {
    final printed = <String?>[];
    final print = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message);

    vc.runApp(
      plugins: vc.PluginDescriptor(event: _FailingLoadedEvents()),
      features: () => [home()],
      lazyFeatures: () => [_lazy('reports')],
    );
    await vc.vyuh.getReady(tester);
    expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);

    await vc.vyuh.loadFeature('reports');
    debugPrint = print;
    expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);
    expect(
      printed.where((m) => m!.contains('could not emit')),
      hasLength(2),
      reason: 'one for the eager feature, one for the lazy one',
    );
  });
}
