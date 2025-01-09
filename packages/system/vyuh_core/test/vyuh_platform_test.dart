import 'package:flutter/material.dart' hide runApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'package:vyuh_test/vyuh_test.dart';

class TestExtensionDescriptor extends ExtensionDescriptor {
  TestExtensionDescriptor() : super(title: 'Test Extension Descriptor');

  @override
  onSourceFeatureUpdated() {}
}

class TestExtensionBuilder extends ExtensionBuilder<ExtensionDescriptor> {
  TestExtensionBuilder({
    required super.title,
  }) : super(extensionType: ExtensionDescriptor);

  @override
  Future<void> onInit(List<ExtensionDescriptor> extensions) async {}

  @override
  Future<void> onDispose() async {}
}

class ErrorThrowingExtensionDescriptor extends ExtensionDescriptor {
  final String errorMessage;

  ErrorThrowingExtensionDescriptor({
    required this.errorMessage,
    required super.title,
  });

  @override
  onSourceFeatureUpdated() {}
}

class ErrorThrowingExtensionBuilder
    extends ExtensionBuilder<ErrorThrowingExtensionDescriptor> {
  final String? initErrorMessage;
  final String? disposeErrorMessage;

  ErrorThrowingExtensionBuilder({
    this.initErrorMessage,
    this.disposeErrorMessage,
    required super.title,
  }) : super(extensionType: ErrorThrowingExtensionDescriptor);

  @override
  Future<void> onInit(List<ErrorThrowingExtensionDescriptor> extensions) async {
    if (initErrorMessage != null) {
      throw Exception(initErrorMessage);
    }
  }

  @override
  Future<void> onDispose() async {
    if (disposeErrorMessage != null) {
      throw Exception(disposeErrorMessage);
    }
  }
}

class MockTelemetryProvider implements TelemetryProvider {
  @override
  String get name => 'mock_telemetry';

  @override
  String get title => 'Mock Telemetry';

  @override
  String get description => 'Mock telemetry provider for testing';

  @override
  List<NavigatorObserver> get observers => [];

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> reportError(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
    bool fatal = false,
    Map<String, dynamic>? params,
  }) async {}

  @override
  Future<void> reportFlutterError(
    FlutterErrorDetails details, {
    Map<String, dynamic>? properties,
    bool fatal = false,
  }) async {}

  @override
  Future<void> reportMessage(
    String message, {
    Map<String, dynamic>? properties,
    LogLevel? level = LogLevel.info,
    Map<String, dynamic>? params,
  }) async {}

  @override
  Future<Trace> startTrace(
    String name,
    String properties, {
    Duration? timeout,
    LogLevel? level = LogLevel.info,
  }) async {
    return MockTrace(name: name);
  }
}

class MockTrace implements Trace {
  final Map<String, String> _attributes = {};
  final Map<String, int> _metrics = {};

  final String name;

  MockTrace({required this.name});

  @override
  Map<String, String> getAttributes() => _attributes;

  @override
  int getMetric(String name) => _metrics[name] ?? 0;

  @override
  void setAttributes(Map<String, String> attributes) {
    _attributes.addAll(attributes);
  }

  @override
  void setMetric(String name, int value) {
    _metrics[name] = value;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<Trace> startChild(
    String name,
    String properties, {
    Duration? timeout,
    LogLevel? level = LogLevel.info,
  }) async {
    return MockTrace(name: name);
  }
}

void main() {
  group(
    'VyuhPlatform',
    () {
      testWidgets('starts with an uninitialized platform', (tester) async {
        expect(vyuh, isNotNull);
        expect(() => vyuh.features, throwsStateError);
        expect(() => vyuh.tracker, throwsStateError);
        expect(() => vyuh.plugins, throwsStateError);
        expect(() => vyuh.widgetBuilder, throwsStateError);
        expect(() => vyuh.rootNavigatorKey, throwsStateError);
        expect(() => vyuh.getPlugin(), throwsStateError);
      });

      testWidgets('initializes with empty features & default plugins',
          (tester) async {
        runApp(
          features: () => [],
        );

        await vyuh.getReady(tester);

        expect(vyuh, isNotNull);
        expect(vyuh.features, isEmpty);

        expect(vyuh.event, isNotNull);
        expect(vyuh.telemetry, isNotNull);
        expect(vyuh.analytics, isNotNull);
        expect(vyuh.network, isNotNull);
        expect(vyuh.router, isNotNull);
        expect(vyuh.env, isNotNull);
        expect(vyuh.content, isNotNull);
        expect(vyuh.auth, isNotNull);
        expect(vyuh.di, isNotNull);
        expect(vyuh.featureFlag, isNull);

        expect(vyuh.plugins.length,
            equals(PluginDescriptor.defaultPlugins.plugins.length));
      });

      testWidgets('initializes with single feature', (tester) async {
        var featureInitCount = 0;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                await Future.delayed(const Duration(seconds: 1));
                featureInitCount++;
              },
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
            FeatureDescriptor(
              name: 'test 2',
              title: 'Test 2',
              init: () async {
                await Future.delayed(const Duration(seconds: 1));
                featureInitCount++;
              },
              routes: () => [
                GoRoute(
                  path: '/test2',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);

        expect(vyuh.features.length, equals(2));
        expect(featureInitCount, 2);
      });

      testWidgets('throws error when two features have the same name',
          (tester) async {
        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'duplicate',
              title: 'Test 1',
              init: () async {},
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
            FeatureDescriptor(
              name: 'duplicate',
              title: 'Test 2',
              init: () async {},
              routes: () => [
                GoRoute(
                  path: '/test2',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(vyuh.tracker.error, isStateError);
      });

      testWidgets('provides access to plugins via getPlugin', (tester) async {
        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);

        expect(vyuh.getPlugin<NetworkPlugin>(), isNotNull);
      });

      testWidgets('tracks feature ready state', (tester) async {
        var initStarted = false;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                initStarted = true;
                await Future.delayed(const Duration(seconds: 1));
              },
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        // Feature initialization should not have started
        expect(initStarted, isFalse);
        expect(vyuh.featureReady('test'), isNull);

        await vyuh.getReady(tester);

        // Feature should be initialized
        expect(initStarted, isTrue);
        expect(vyuh.featureReady('test'), isA<Future<void>>());
        expect(vyuh.featureReady('non-existent'), isNull);
      });

      testWidgets('can restart platform', (tester) async {
        var initCount = 0;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                initCount++;
              },
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(initCount, equals(1));

        // Restart platform
        vyuh.restart();

        await vyuh.getReady(tester);

        // Feature should be reinitialized
        expect(initCount, equals(2));
      });

      testWidgets('initializes router with feature routes', (tester) async {
        var routeBuilderCalled = false;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              routes: () {
                routeBuilderCalled = true;
                return [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ];
              },
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(routeBuilderCalled, isTrue);
      });

      testWidgets('handles initial location', (tester) async {
        const initialPath = '/test';

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              routes: () => [
                GoRoute(
                  path: initialPath,
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
          initialLocation: initialPath,
        );

        await vyuh.getReady(tester);
        expect(vyuh.router.instance.state?.fullPath, equals(initialPath));
      });

      testWidgets('handles feature lifecycle correctly', (tester) async {
        var initCount = 0;
        var disposeCount = 0;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                initCount++;
              },
              dispose: () async {
                disposeCount++;
              },
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(initCount, equals(1));
        expect(disposeCount, equals(0));

        // Restart should trigger dispose and init
        vyuh.restart();
        await vyuh.getReady(tester);

        expect(initCount, equals(2));
        expect(disposeCount, equals(1));
      });

      testWidgets('handles extensions and extension builders', (tester) async {
        var extensionBuilderInitCalled = false;

        final mockExtension = TestExtensionDescriptor();
        final mockBuilder = TestExtensionBuilder(
          title: 'Test Extension Builder',
        );

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              extensions: [mockExtension],
              extensionBuilders: [mockBuilder],
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);

        expect(extensionBuilderInitCalled, isFalse);
      });

      testWidgets('handles feature metadata correctly', (tester) async {
        const description = 'Test Description';
        const icon = Icons.star;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              description: description,
              icon: icon,
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);

        final feature = vyuh.features.first;
        expect(feature.description, equals(description));
        expect(feature.icon, equals(icon));
      });

      testWidgets('caches route builder results', (tester) async {
        var routeBuilderCallCount = 0;
        final routes = [
          GoRoute(
            path: '/',
            builder: (_, __) => const SizedBox(),
          ),
        ];

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              routes: () {
                routeBuilderCallCount++;
                return routes;
              },
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(routeBuilderCallCount, equals(1));

        // Subsequent calls should use cached result
        final result = await vyuh.features.first.routes!();
        expect(result, equals(routes));
        expect(routeBuilderCallCount, equals(1));

        // Restart should clear cache
        vyuh.restart();
        await vyuh.getReady(tester);
        expect(routeBuilderCallCount, equals(2));
      });

      testWidgets('handles feature initialization errors', (tester) async {
        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                throw Exception('Test Error');
              },
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
        );

        await vyuh.getReady(tester);
        expect(vyuh.tracker.error, isNotNull);
        expect(vyuh.tracker.error.toString(), contains('Test Error'));
      });

      testWidgets('handles plugin overrides', (tester) async {
        final mockTelemetry = MockTelemetryProvider();

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              routes: () => [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ],
          plugins: PluginDescriptor(
            telemetry: TelemetryPlugin(providers: [mockTelemetry]),
          ),
        );

        await vyuh.getReady(tester);
        expect(vyuh.telemetry.providers.first, equals(mockTelemetry));
      });

      group('Extension System', () {
        testWidgets('handles multiple extensions of same type', (tester) async {
          final extensions = List.generate(
            3,
            (i) => TestExtensionDescriptor(),
          );
          var initCallCount = 0;

          final builder = TestExtensionBuilder(
            title: 'Test Extension Builder',
          );

          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                extensions: extensions,
                extensionBuilders: [builder],
                routes: () => [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(initCallCount, equals(0),
              reason: 'Builder should not be initialized');
        });

        testWidgets('handles extension builder initialization errors',
            (tester) async {
          final errorMessage = 'Test init error';
          final builder = ErrorThrowingExtensionBuilder(
            title: 'Error Builder',
            initErrorMessage: errorMessage,
          );

          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                extensionBuilders: [builder],
                routes: () => [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(vyuh.tracker.error, isNotNull);
          expect(vyuh.tracker.error.toString(), contains(errorMessage));
        });

        testWidgets('cleans up extensions on dispose', (tester) async {
          final builder = TestExtensionBuilder(title: 'Test Extension');

          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                extensionBuilders: [builder],
                routes: () => [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(builder.isInitialized, isTrue);
          expect(builder.isDisposed, isFalse);

          vyuh.restart();
          await vyuh.getReady(tester);

          expect(builder.isInitialized, isTrue);
          expect(builder.isDisposed, isFalse);
        });

        testWidgets('handles extension builder disposal errors',
            (tester) async {
          final errorMessage = 'Test dispose error';
          final builder = ErrorThrowingExtensionBuilder(
            title: 'Error Builder',
            disposeErrorMessage: errorMessage,
          );

          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                extensionBuilders: [builder],
                routes: () => [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(builder.isInitialized, isTrue);

          vyuh.restart();
          await vyuh.getReady(tester);

          expect(vyuh.tracker.error, isNotNull);
          expect(vyuh.tracker.error.toString(), contains(errorMessage));
        });
      });

      group('Error Handling', () {
        testWidgets('handles concurrent feature initialization errors',
            (tester) async {
          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test1',
                title: 'Test 1',
                init: () async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  throw Exception('Test Error 1');
                },
                routes: () => [
                  GoRoute(
                    path: '/',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
              FeatureDescriptor(
                name: 'test2',
                title: 'Test 2',
                init: () async {
                  await Future.delayed(const Duration(milliseconds: 50));
                  throw Exception('Test Error 2');
                },
                routes: () => [
                  GoRoute(
                    path: '/test2',
                    builder: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(vyuh.tracker.error, isNotNull);
          // Should capture the first error
          expect(vyuh.tracker.error.toString(), contains('Test Error 2'));
        });

        testWidgets('handles route builder errors', (tester) async {
          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                routes: () {
                  throw Exception('Route builder error');
                },
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(vyuh.tracker.error, isNotNull);
          expect(
              vyuh.tracker.error.toString(), contains('Route builder error'));
        });

        testWidgets('maintains platform stability after error', (tester) async {
          bool throwError = true;

          // First run with error
          runApp(
            features: () => [
              FeatureDescriptor(
                name: 'test',
                title: 'Test',
                init: () async {
                  if (throwError) {
                    throw Exception('Init error');
                  }
                },
                routes: () => [],
              ),
            ],
          );

          await vyuh.getReady(tester);
          expect(vyuh.tracker.error, isNotNull);
        });
      });
    },
  );
}
