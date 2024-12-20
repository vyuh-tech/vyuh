import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_test/vyuh_test.dart';

import 'utils.dart';

void main() {
  group('ContentBuilder Registration', () {
    testWidgets('registers content builder successfully', (tester) async {
      final builder = ContentExtensionBuilder();

      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () async => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [
                  TestContentItem.contentBuilder,
                  MockRoute.contentBuilder,
                ],
                contents: [
                  TestContentDescriptor(),
                ],
              ),
            ],
            extensionBuilders: [builder],
          ),
        ],
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: MockContentProvider()),
        ),
      );

      await vyuh.getReady(tester);

      expect(
          () =>
              builder.register<TestContentItem>(TestContentItem.typeDescriptor),
          returnsNormally);
    });
  });
}
