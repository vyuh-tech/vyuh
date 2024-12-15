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

    tearDown(() {
      builder.dispose();
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

      expect(find.text('Error'), findsOneWidget);
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

      expect(vyuh.content.isRegistered(TestContentItem.typeDescriptor), isTrue);
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
                contents: [
                  TestContentDescriptor(),
                  MockRouteDescriptor(),
                ],
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

      expect(builder.getContentBuilder(TestContentItem.schemaName),
          equals(contentBuilder1));
      expect(builder.getContentBuilder(MockRoute.schemaName),
          equals(contentBuilder2));
    });

    testWidgets('_build throws assertion for duplicate content builders',
        (tester) async {
      final contentBuilder1 = TestContentItem.contentBuilder;
      final contentBuilder2 = TestContentItem.contentBuilder;

      expect(() {
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
      }, throwsAssertionError);
    });

    testWidgets('_build throws assertion for missing content builders',
        (tester) async {
      expect(() {
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
      }, throwsAssertionError);
    });

    testWidgets('_build initializes type registrations correctly',
        (tester) async {
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

      expect(builder.isRegistered(modifier), isTrue);
      expect(builder.isRegistered(action), isTrue);
      expect(builder.isRegistered(condition), isTrue);
    });
  });
}
