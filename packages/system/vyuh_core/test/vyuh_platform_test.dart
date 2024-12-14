import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
    },
  );
}

extension on VyuhPlatform {
  Future<void> getReady(WidgetTester tester) async {
    final completer = Completer<void>();
    when(
        (_) =>
            tracker.currentState.value == InitState.ready ||
            tracker.currentState.value == InitState.error, () {
      completer.complete();
    });

    await tester.pumpAndSettle();

    return completer.future;
  }
}
