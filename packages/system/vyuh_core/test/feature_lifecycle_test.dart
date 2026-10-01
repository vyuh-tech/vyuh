import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

void main() {
  lazyTransactionTests();
  routerTransactionTests();
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });
  vc.FeatureDescriptor feature(
    String name, {
    List<String> dependencies = const [],
    vc.VoidFutureFunction? init,
    vc.VoidFutureFunction? dispose,
  }) => vc.FeatureDescriptor(
    name: name,
    title: name,
    dependencies: dependencies,
    init: init,
    dispose: dispose,
    routes: () => [
      GoRoute(path: '/$name', builder: (_, _) => const SizedBox()),
    ],
  );
  testWidgets(
    'dependent initialization waits for its service while unrelated features run',
    (tester) async {
      final service = Completer<void>();
      final events = <String>[];
      vc.runApp(
        features: () => [
          feature(
            'consumer',
            dependencies: ['service'],
            init: () async {
              events.add('consumer');
            },
          ),
          feature(
            'service',
            init: () async {
              events.add('service-start');
              await service.future;
              events.add('service-ready');
            },
          ),
          feature(
            'independent',
            init: () async {
              events.add('independent');
              service.complete();
            },
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      expect(
        events.indexOf('service-ready'),
        lessThan(events.indexOf('consumer')),
      );
      expect(
        events.indexOf('independent'),
        lessThan(events.indexOf('consumer')),
      );
    },
  );
  testWidgets('missing dependencies fail startup with a useful error', (
    tester,
  ) async {
    vc.runApp(
      features: () => [
        feature('consumer', dependencies: ['missing']),
      ],
    );
    await vc.vyuh.getReady(tester);
    expect(vc.vyuh.tracker.error, isStateError);
  });
  testWidgets('disposal runs feature hooks before plugin services disappear', (
    tester,
  ) async {
    var disposed = false;
    vc.runApp(
      features: () => [
        feature(
          'test',
          dispose: () async {
            expect(vc.VyuhBinding.instance.initialized, isTrue);
            disposed = true;
          },
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await vc.vyuh.dispose();
    expect(disposed, isTrue);
  });
  testWidgets('lazy cycles fail before navigation starts', (tester) async {
    vc.runApp(
      features: () => [],
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'a',
          title: 'a',
          routePrefixes: ['/a'],
          dependencies: ['b'],
          loader: () async => feature('a'),
        ),
        vc.LazyFeatureDescriptor(
          name: 'b',
          title: 'b',
          routePrefixes: ['/b'],
          dependencies: ['a'],
          loader: () async => feature('b'),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    expect(vc.vyuh.tracker.error, isStateError);
  });
  testWidgets('concurrent lazy loads activate a feature once', (tester) async {
    var calls = 0;
    final loaded = Completer<vc.FeatureDescriptor>();
    vc.runApp(
      features: () => [feature('home')],
      initialLocation: '/home',
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'lazy',
          title: 'lazy',
          routePrefixes: ['/lazy'],
          loader: () {
            calls++;
            return loaded.future;
          },
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    final first = vc.vyuh.loadFeature('lazy');
    final second = vc.vyuh.loadFeature('lazy');
    loaded.complete(feature('lazy'));
    await Future.wait([first, second]);
    expect(calls, 1);
    expect(vc.vyuh.features.where((f) => f.name == 'lazy'), hasLength(1));
  });
  testWidgets(
    'a rejected lazy loader can be retried without an unhandled error',
    (tester) async {
      var calls = 0;
      vc.runApp(
        features: () => [feature('home')],
        initialLocation: '/home',
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'lazy',
            title: 'lazy',
            routePrefixes: ['/lazy'],
            loader: () async {
              if (++calls == 1) throw StateError('download');
              return feature('lazy');
            },
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await expectLater(vc.vyuh.loadFeature('lazy'), throwsStateError);
      await vc.vyuh.loadFeature('lazy');
      expect(vc.vyuh.isFeatureLoaded('lazy'), isTrue);
    },
  );

  testWidgets(
    'lazy route failure does not publish a feature and releases its state',
    (tester) async {
      var attempts = 0;
      var disposals = 0;
      vc.runApp(
        features: () => [feature('home')],
        initialLocation: '/home',
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'lazy',
            title: 'Lazy',
            routePrefixes: ['/lazy'],
            loader: () async => vc.FeatureDescriptor(
              name: 'lazy',
              title: 'Lazy',
              dispose: () async {
                disposals++;
              },
              routes: () {
                if (++attempts == 1) {
                  throw StateError('Route generation failed');
                }
                return [
                  GoRoute(path: '/lazy', builder: (_, _) => const SizedBox()),
                ];
              },
            ),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      // Load explicitly before the initial route widget is pumped.
      await expectLater(vc.vyuh.loadFeature('lazy'), throwsStateError);
      expect(vc.vyuh.features.where((f) => f.name == 'lazy'), isEmpty);
      expect(disposals, 1);
      await vc.vyuh.loadFeature('lazy');
      expect(vc.vyuh.isFeatureLoaded('lazy'), isTrue);
      expect(attempts, 2);
    },
  );
}

class TransactionDescriptor extends vc.ExtensionDescriptor {
  final bool fail;
  TransactionDescriptor({this.fail = false}) : super(title: 'Transaction');
  @override
  void onSourceFeatureUpdated() {}
}

class TransactionBuilder extends vc.ExtensionBuilder<TransactionDescriptor> {
  final List<vc.ExtensionDescriptor> registrations = [];
  TransactionBuilder()
    : super(title: 'Transaction', extensionType: TransactionDescriptor);
  @override
  VoidCallback captureLazyState(vc.ExtensionDescriptor descriptor) {
    final before = List<vc.ExtensionDescriptor>.of(registrations);
    return () {
      registrations
        ..clear()
        ..addAll(before);
    };
  }

  @override
  void registerLazy(vc.ExtensionDescriptor descriptor) {
    registrations.add(descriptor);
    if ((descriptor as TransactionDescriptor).fail) {
      throw StateError('registration');
    }
  }
}

void lazyTransactionTests() {
  vc.FeatureDescriptor home([TransactionBuilder? builder]) =>
      vc.FeatureDescriptor(
        name: 'home',
        title: 'Home',
        extensionBuilders: builder == null ? null : [builder],
        routes: () => [
          GoRoute(path: '/home', builder: (_, _) => const SizedBox()),
        ],
      );
  testWidgets(
    'failed incremental registration rolls back all contributions and retries',
    (tester) async {
      final builder = TransactionBuilder();
      var attempts = 0, disposed = 0;
      vc.runApp(
        features: () => [home(builder)],
        initialLocation: '/home',
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'lazy',
            title: 'Lazy',
            routePrefixes: ['/lazy'],
            loader: () async => vc.FeatureDescriptor(
              name: 'lazy',
              title: 'Lazy',
              extensions: [
                TransactionDescriptor(),
                TransactionDescriptor(fail: ++attempts == 1),
              ],
              dispose: () async {
                disposed++;
              },
              routes: () => [
                GoRoute(path: '/lazy', builder: (_, _) => const SizedBox()),
              ],
            ),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await expectLater(vc.vyuh.loadFeature('lazy'), throwsStateError);
      expect(builder.registrations, isEmpty);
      expect(disposed, 1);
      expect(vc.vyuh.isFeatureLoaded('lazy'), isFalse);
      expect(
        vc.vyuh.router.instance.configuration.routes.whereType<GoRoute>().any(
          (r) => r.path == '/lazy',
        ),
        isTrue,
      );
      await vc.vyuh.loadFeature('lazy');
      expect(builder.registrations, hasLength(2));
    },
  );
  testWidgets('disposal cancels a pending loader before it can initialize', (
    tester,
  ) async {
    final loaded = Completer<vc.FeatureDescriptor>();
    var initialized = false;
    vc.runApp(
      features: () => [home()],
      initialLocation: '/home',
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'lazy',
          title: 'Lazy',
          routePrefixes: ['/lazy'],
          loader: () => loaded.future,
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    final request = vc.vyuh.loadFeature('lazy');
    final rejected = expectLater(request, throwsStateError);
    await vc.vyuh.dispose();
    loaded.complete(
      vc.FeatureDescriptor(
        name: 'lazy',
        title: 'Lazy',
        routes: () => [],
        init: () async {
          initialized = true;
        },
      ),
    );
    await rejected;
    expect(initialized, isFalse);
    expect(vc.vyuh.features, isEmpty);
  });
  testWidgets(
    'disposal waits for entered lazy initialization and its cleanup',
    (tester) async {
      final entered = Completer<void>(), finish = Completer<void>();
      var cleaned = false;
      vc.runApp(
        features: () => [home()],
        initialLocation: '/home',
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'lazy',
            title: 'Lazy',
            routePrefixes: ['/lazy'],
            loader: () async => vc.FeatureDescriptor(
              name: 'lazy',
              title: 'Lazy',
              routes: () => [],
              init: () async {
                entered.complete();
                await finish.future;
              },
              dispose: () async {
                expect(vc.VyuhBinding.instance.initialized, isTrue);
                cleaned = true;
              },
            ),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      final rejected = expectLater(
        vc.vyuh.loadFeature('lazy'),
        throwsStateError,
      );
      await entered.future;
      final disposal = vc.vyuh.dispose();
      finish.complete();
      await disposal;
      await rejected;
      expect(cleaned, isTrue);
      expect(vc.vyuh.features, isEmpty);
    },
  );
}

class FailingNavigation extends vc.NavigationPlugin {
  final delegate = vc.DefaultNavigationPlugin();
  bool failNext = true;
  FailingNavigation()
    : super(name: 'test.navigation', title: 'Test navigation');
  @override
  GoRouter get instance => delegate.instance;
  @override
  Future<void> init() => delegate.init();
  @override
  Future<void> dispose() => delegate.dispose();
  @override
  void initRouter({
    String? initialLocation,
    required List<RouteBase> routes,
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) => delegate.initRouter(
    initialLocation: initialLocation,
    routes: routes,
    rootNavigatorKey: rootNavigatorKey,
  );
  @override
  void replaceRoutes(List<RouteBase> routes) {
    delegate.replaceRoutes(routes);
    if (failNext) {
      failNext = false;
      throw StateError('router publication');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError(invocation.memberName.toString());
}

void routerTransactionTests() {
  testWidgets(
    'router publication failure restores routes and extension state',
    (tester) async {
      final navigation = FailingNavigation(), builder = TransactionBuilder();
      vc.runApp(
        plugins: vc.PluginDescriptor(navigation: navigation),
        features: () => [
          vc.FeatureDescriptor(
            name: 'home',
            title: 'Home',
            extensionBuilders: [builder],
            routes: () => [
              GoRoute(path: '/home', builder: (_, _) => const SizedBox()),
            ],
          ),
        ],
        initialLocation: '/home',
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'lazy',
            title: 'Lazy',
            routePrefixes: ['/lazy'],
            loader: () async => vc.FeatureDescriptor(
              name: 'lazy',
              title: 'Lazy',
              extensions: [TransactionDescriptor()],
              routes: () => [
                GoRoute(path: '/lazy', builder: (_, _) => const SizedBox()),
              ],
            ),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      final before = List<RouteBase>.of(
        navigation.instance.configuration.routes,
      );
      await expectLater(vc.vyuh.loadFeature('lazy'), throwsStateError);
      expect(navigation.instance.configuration.routes, orderedEquals(before));
      expect(builder.registrations, isEmpty);
      expect(vc.vyuh.isFeatureLoaded('lazy'), isFalse);
      await vc.vyuh.loadFeature('lazy');
      expect(builder.registrations, hasLength(1));
    },
  );
}
