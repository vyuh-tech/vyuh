import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets('TextBlockItem loaded from json has correct markDefs',
      (WidgetTester tester) async {
    PortableTextConfig.shared.markDefs[CustomMarkDef.schemaName] =
        MarkDefDescriptor(
      schemaType: CustomMarkDef.schemaName,
      fromJson: (json) => CustomMarkDef.fromJson(json),
      styleBuilder: (context, markDef, style) => style,
    );

    final block = TextBlockItem.fromJson({
      'children': [
        {'text': 'Hello, '},
      ],
      'markDefs': [
        {'_key': 'key', '_type': CustomMarkDef.schemaName, 'color': 0xFF0000},
      ],
    });

    expect(block.markDefs.first, isA<CustomMarkDef>());
  });

  test('The base MarkDef throw error for fromJson', () {
    expect(() => MarkDef.fromJson({}), throwsUnsupportedError);
  });
}
