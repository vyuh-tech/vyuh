import 'package:flutter/widgets.dart' hide runApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'package:vyuh_test/vyuh_test.dart';

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
              routes: () => [],
            ),
            FeatureDescriptor(
              name: 'test 2',
              title: 'Test 2',
              init: () async {
                await Future.delayed(const Duration(seconds: 1));
                featureInitCount++;
              },
              routes: () => [],
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
              routes: () => [],
            ),
            FeatureDescriptor(
              name: 'duplicate',
              title: 'Test 2',
              init: () async {},
              routes: () => [],
            ),
          ],
        );

        await vyuh.getReady(tester);

        expect(vyuh.tracker.error, isStateError);
      });

      testWidgets('provides access to plugins via getPlugin', (tester) async {
        runApp(
          features: () => [],
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
              routes: () => [],
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
              routes: () => [],
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
    },
  );
}
