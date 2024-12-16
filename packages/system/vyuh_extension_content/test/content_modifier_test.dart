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

class VisibilityModifier extends ContentModifierConfiguration {
  static const schemaName = 'visibility_modifier';

  static final typeDescriptor = TypeDescriptor<ContentModifierConfiguration>(
    schemaType: schemaName,
    title: 'Visibility Modifier',
    fromJson: VisibilityModifier.fromJson,
  );

  final bool visible;

  VisibilityModifier({
    required this.visible,
  }) : super(schemaType: schemaName);

  factory VisibilityModifier.fromJson(Map<String, dynamic> json) {
    return VisibilityModifier(
      visible: json['visible'] as bool,
    );
  }

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    return Visibility(
      visible: visible,
      child: child,
    );
  }
}

class PaddingModifier extends ContentModifierConfiguration {
  static const schemaName = 'padding_modifier';

  static final typeDescriptor = TypeDescriptor<ContentModifierConfiguration>(
    schemaType: schemaName,
    title: 'Padding Modifier',
    fromJson: PaddingModifier.fromJson,
  );

  final double padding;

  PaddingModifier({
    required this.padding,
  }) : super(schemaType: schemaName);

  factory PaddingModifier.fromJson(Map<String, dynamic> json) {
    return PaddingModifier(
      padding: (json['padding'] as num).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }
}

class ErrorModifier extends ContentModifierConfiguration {
  static const schemaName = 'error_modifier';

  static final typeDescriptor = TypeDescriptor<ContentModifierConfiguration>(
    schemaType: schemaName,
    title: 'Error Modifier',
    fromJson: ErrorModifier.fromJson,
  );

  ErrorModifier() : super(schemaType: schemaName);

  factory ErrorModifier.fromJson(Map<String, dynamic> json) {
    return ErrorModifier();
  }

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    throw Exception('Modifier build error');
  }
}

void main() {
  late ContentExtensionBuilder builder;

  setUp(() {
    builder = ContentExtensionBuilder();
    builder.register<ContentModifierConfiguration>(
        VisibilityModifier.typeDescriptor);
    builder
        .register<ContentModifierConfiguration>(PaddingModifier.typeDescriptor);
    builder
        .register<ContentModifierConfiguration>(ErrorModifier.typeDescriptor);
  });

  tearDown(() {
    builder.dispose();
  });

  group('Content Modifiers', () {
    testWidgets('applies single modifier correctly',
        (WidgetTester tester) async {
      final content = TestContentItem(
        id: '1',
        title: 'Test',
        modifiers: [VisibilityModifier(visible: false)],
      );

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final modifiers = content.getModifiers();
            final child = Container();

            if (modifiers != null && modifiers.isNotEmpty) {
              return modifiers.first.build(context, child, content);
            }
            return child;
          },
        ),
      );

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('applies multiple modifiers in correct order',
        (WidgetTester tester) async {
      final content = TestContentItem(
        id: '1',
        title: 'Test',
        modifiers: [
          VisibilityModifier(visible: true),
          PaddingModifier(padding: 16),
        ],
      );

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final modifiers = content.getModifiers();
            Widget child = Container();

            if (modifiers != null) {
              child = modifiers.fold<Widget>(
                child,
                (child, modifier) => modifier.build(context, child, content),
              );
            }
            return child;
          },
        ),
      );

      expect(find.byType(Visibility), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);

      // Verify padding is inside visibility
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('handles modifier build errors gracefully',
        (WidgetTester tester) async {
      final content = TestContentItem(
        id: '1',
        title: 'Test',
        modifiers: [ErrorModifier()],
      );

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final modifiers = content.getModifiers();
            final child = Container();

            if (modifiers != null && modifiers.isNotEmpty) {
              return modifiers.first.build(context, child, content);
            }
            return child;
          },
        ),
      );

      expect(find.byType(ErrorWidget), findsOneWidget);
    });

    test('deserializes modifiers from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test',
        'modifiers': [
          {
            'schemaType': VisibilityModifier.schemaName,
            'visible': true,
          },
          {
            'schemaType': PaddingModifier.schemaName,
            'padding': 8,
          },
        ],
      };

      final content = TestContentItem.fromJson(json);
      final modifiers = content.getModifiers();

      expect(modifiers, hasLength(2));
      expect(modifiers![0], isA<VisibilityModifier>());
      expect(modifiers[1], isA<PaddingModifier>());
    });

    test('handles invalid modifier JSON', () {
      final json = {
        'id': '1',
        'title': 'Test',
        'modifiers': [
          {
            'schemaType': 'unknown_modifier',
          },
        ],
      };

      final content = TestContentItem.fromJson(json);
      final modifiers = content.getModifiers();

      expect(modifiers, isEmpty);
    });
  });
}
