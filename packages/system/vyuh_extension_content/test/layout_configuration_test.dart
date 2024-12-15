import 'package:flutter/widgets.dart' hide runApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class TestContentItem extends ContentItem {
  static const schemaName = 'test_item';

  final String id;
  final String title;

  static final typeDescriptor = TypeDescriptor<TestContentItem>(
    schemaType: schemaName,
    title: 'Test Item',
    fromJson: TestContentItem.fromJson,
  );

  TestContentItem({
    required this.id,
    required this.title,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory TestContentItem.fromJson(Map<String, dynamic> json) {
    return TestContentItem(
      id: json['id'] as String,
      title: json['title'] as String,
      layout: typeFromFirstOfListJson<LayoutConfiguration<TestContentItem>>(
          json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
  }
}

class TestLayoutConfiguration extends LayoutConfiguration<TestContentItem> {
  static const schemaName = 'test_layout';

  static final typeDescriptor =
      TypeDescriptor<LayoutConfiguration<TestContentItem>>(
    schemaType: schemaName,
    title: 'Test Layout',
    fromJson: TestLayoutConfiguration.fromJson,
  );

  final double padding;

  TestLayoutConfiguration({
    required this.padding,
  }) : super(schemaType: schemaName);

  factory TestLayoutConfiguration.fromJson(Map<String, dynamic> json) {
    return TestLayoutConfiguration(
      padding: (json['padding'] as num).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context, TestContentItem content) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(),
    );
  }
}

class ErrorLayoutConfiguration extends LayoutConfiguration<TestContentItem> {
  static const schemaName = 'error_layout';

  static final typeDescriptor =
      TypeDescriptor<LayoutConfiguration<TestContentItem>>(
    schemaType: schemaName,
    title: 'Error Layout',
    fromJson: ErrorLayoutConfiguration.fromJson,
  );

  ErrorLayoutConfiguration() : super(schemaType: schemaName);

  factory ErrorLayoutConfiguration.fromJson(Map<String, dynamic> json) {
    return ErrorLayoutConfiguration();
  }

  @override
  Widget build(BuildContext context, TestContentItem content) {
    throw Exception('Layout build error');
  }
}

void main() {
  late ContentExtensionBuilder builder;
  late ContentBuilder<TestContentItem> contentBuilder;

  setUp(() {
    builder = ContentExtensionBuilder();
    contentBuilder = ContentBuilder<TestContentItem>(
      content: TestContentItem.typeDescriptor,
      defaultLayout: TestLayoutConfiguration(padding: 0),
      defaultLayoutDescriptor: TestLayoutConfiguration.typeDescriptor,
    );
  });

  tearDown(() {
    builder.dispose();
  });

  group('Layout Configuration', () {
    testWidgets('uses default layout when no layout specified',
        (WidgetTester tester) async {
      final content = TestContentItem(id: '1', title: 'Test');

      await tester.pumpWidget(
        Builder(
          builder: (context) => contentBuilder.build(context, content),
        ),
      );

      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);

      final padding = tester.widget<Padding>(paddingFinder);
      expect(padding.padding, equals(EdgeInsets.zero));
    });

    testWidgets('uses specified layout over default',
        (WidgetTester tester) async {
      final content = TestContentItem(
        id: '1',
        title: 'Test',
        layout: TestLayoutConfiguration(padding: 16),
      );

      await tester.pumpWidget(
        Builder(
          builder: (context) => contentBuilder.build(context, content),
        ),
      );

      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);

      final padding = tester.widget<Padding>(paddingFinder);
      expect(padding.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('handles layout build errors gracefully',
        (WidgetTester tester) async {
      final content = TestContentItem(
        id: '1',
        title: 'Test',
        layout: ErrorLayoutConfiguration(),
      );

      await tester.pumpWidget(
        Builder(
          builder: (context) => contentBuilder.build(context, content),
        ),
      );

      // Should show error view instead of crashing
      expect(find.byType(ErrorWidget), findsOneWidget);
    });

    test('deserializes layout configuration from JSON', () {
      final json = {
        'padding': 8,
      };

      final layout = TestLayoutConfiguration.fromJson(json);
      expect(layout.padding, equals(8.0));
    });

    test('handles invalid JSON deserialization', () {
      final json = {
        'padding': 'invalid',
      };

      expect(() => TestLayoutConfiguration.fromJson(json),
          throwsA(isA<TypeError>()));
    });
  });
}
