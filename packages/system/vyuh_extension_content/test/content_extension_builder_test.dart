import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_test/vyuh_test.dart';

import 'utils.dart';

void main() {
  group('ContentExtensionBuilder Initialization', () {
    late ContentExtensionBuilder builder;
    late MockContentProvider contentProvider;

    setUp(() {
      builder = ContentExtensionBuilder();
      contentProvider = MockContentProvider();
    });

    tearDown(() async {
      if (VyuhBinding.instance.initialized) await vyuh.dispose();
      await builder.dispose();
    });

    testWidgets('init fails if MockRoute is not registered', (tester) async {
      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [TestContentItem.contentBuilder],
                contents: [TestContentDescriptor()],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: contentProvider),
        ),
      );

      await vyuh.getReady(tester);

      expect(vyuh.tracker.error, isNull);
    });

    testWidgets('init attaches to content plugin correctly', (tester) async {
      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () async => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [TestContentItem.contentBuilder],
                contents: [TestContentDescriptor()],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: contentProvider),
        ),
      );

      await vyuh.getReady(tester);

      expect(
        vyuh.content.isRegistered<ContentItem>(
          TestContentItem.typeDescriptor.schemaType,
        ),
        isTrue,
      );
    });

    testWidgets('_build collects content builders correctly', (tester) async {
      final contentBuilder1 = TestContentItem.contentBuilder;
      final contentBuilder2 = MockRoute.contentBuilder;

      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () async => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [contentBuilder1, contentBuilder2],
                contents: [TestContentDescriptor(), MockRouteDescriptor()],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: contentProvider),
        ),
      );

      await vyuh.getReady(tester);

      expect(
        builder.contentBuilder(TestContentItem.schemaName),
        equals(contentBuilder1),
      );
      expect(
        builder.contentBuilder(MockRoute.schemaName),
        equals(contentBuilder2),
      );
    });

    testWidgets(
      '_build reports a startup error for duplicate content builders',
      (tester) async {
        final contentBuilder1 = TestContentItem.contentBuilder;
        final contentBuilder2 = TestContentItem.contentBuilder;

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test_feature',
              title: 'Test Feature',
              routes: () async => [],
              extensions: [
                ContentExtensionDescriptor(
                  contentBuilders: [contentBuilder1, contentBuilder2],
                  contents: [TestContentDescriptor()],
                ),
              ],
              extensionBuilders: [builder],
            ),
          ],
          plugins: PluginDescriptor(
            content: DefaultContentPlugin(provider: contentProvider),
          ),
        );
        await vyuh.getReady(tester);
        expect(vyuh.tracker.error, isStateError);
      },
    );

    testWidgets('_build reports a startup error for missing content builders', (
      tester,
    ) async {
      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () async => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [],
                contents: [TestContentDescriptor()],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: contentProvider),
        ),
      );
      await vyuh.getReady(tester);
      expect(vyuh.tracker.error, isStateError);
    });

    testWidgets('_build initializes type registrations correctly', (
      tester,
    ) async {
      final modifier = TestModifier.typeDescriptor;
      final action = TestAction.typeDescriptor;
      final condition = TestCondition.typeDescriptor;

      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () async => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [TestContentItem.contentBuilder],
                contents: [TestContentDescriptor()],
                contentModifiers: [modifier],
                actions: [action],
                conditions: [condition],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: contentProvider),
        ),
      );

      await vyuh.getReady(tester);

      expect(
        builder.isRegistered<ContentModifierConfiguration>(modifier.schemaType),
        isTrue,
      );
      expect(
        builder.isRegistered<ActionConfiguration>(action.schemaType),
        isTrue,
      );
      expect(
        builder.isRegistered<ConditionConfiguration>(condition.schemaType),
        isTrue,
      );
    });
  });
}
