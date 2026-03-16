import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  group('PortableTextConfig.from', () {
    test('copies all values from source by default', () {
      PortableTextConfig.shared.apply(
        itemPadding: const EdgeInsets.all(16),
        listIndent: 32,
      );

      final scoped = PortableTextConfig.from(PortableTextConfig.shared);

      expect(scoped.itemPadding, const EdgeInsets.all(16));
      expect(scoped.listIndent, 32);
      expect(scoped.styles.keys, PortableTextConfig.shared.styles.keys);
      expect(scoped.blocks.keys, PortableTextConfig.shared.blocks.keys);
      expect(scoped.blockContainers.keys,
          PortableTextConfig.shared.blockContainers.keys);
    });

    test('overrides itemPadding when specified', () {
      PortableTextConfig.shared.apply(
        itemPadding: const EdgeInsets.only(bottom: 8),
      );

      final scoped = PortableTextConfig.from(
        PortableTextConfig.shared,
        itemPadding: EdgeInsets.zero,
      );

      expect(scoped.itemPadding, EdgeInsets.zero);
      expect(PortableTextConfig.shared.itemPadding,
          const EdgeInsets.only(bottom: 8));
    });

    test('overrides listIndent when specified', () {
      final scoped = PortableTextConfig.from(
        PortableTextConfig.shared,
        listIndent: 40,
      );

      expect(scoped.listIndent, 40);
      expect(PortableTextConfig.shared.listIndent,
          PortableTextConfig.defaultListIndent);
    });

    test('does not mutate the source config', () {
      final original = PortableTextConfig.shared;
      final originalPadding = original.itemPadding;
      final originalIndent = original.listIndent;

      PortableTextConfig.from(
        original,
        itemPadding: const EdgeInsets.all(99),
        listIndent: 99,
      );

      expect(original.itemPadding, originalPadding);
      expect(original.listIndent, originalIndent);
    });
  });

  group('PortableTextBlock with scoped config', () {
    testWidgets('uses scoped config itemPadding instead of shared',
        (WidgetTester tester) async {
      PortableTextConfig.shared.itemPadding = const EdgeInsets.only(bottom: 10);

      final scoped = PortableTextConfig.from(
        PortableTextConfig.shared,
        itemPadding: EdgeInsets.zero,
      );

      final block = TextBlockItem(children: [
        Span(text: 'Hello, World'),
      ]);

      await tester.pumpWidget(MaterialApp(
        home: PortableTextBlock(model: block, config: scoped),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, EdgeInsets.zero);
    });

    testWidgets('falls back to shared config when no scoped config is provided',
        (WidgetTester tester) async {
      PortableTextConfig.shared.itemPadding = const EdgeInsets.only(bottom: 12);

      final block = TextBlockItem(children: [
        Span(text: 'Hello, World'),
      ]);

      await tester.pumpWidget(MaterialApp(
        home: PortableTextBlock(model: block),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, const EdgeInsets.only(bottom: 12));
    });

    testWidgets(
        'scoped config with zero padding in Row enables correct center alignment',
        (WidgetTester tester) async {
      final scoped = PortableTextConfig.from(
        PortableTextConfig.shared,
        itemPadding: EdgeInsets.zero,
      );

      final block = TextBlockItem(children: [
        Span(text: 'Hello, World'),
      ]);

      await tester.pumpWidget(MaterialApp(
        home: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: PortableTextBlock(model: block, config: scoped),
            ),
          ],
        ),
      ));

      // Verify the block's padding is zero — no trailing space to
      // throw off the Row's cross-axis center alignment.
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, EdgeInsets.zero);

      // Verify the icon and text are vertically centered in the Row.
      final iconCenter = tester.getCenter(find.byIcon(Icons.star));
      final textCenter =
          tester.getCenter(find.text('Hello, World', findRichText: true));
      expect(iconCenter.dy, textCenter.dy);
    });
  });
}
