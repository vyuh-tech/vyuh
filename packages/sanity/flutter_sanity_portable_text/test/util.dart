import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

TextSpan? findTextSpan(bool Function(TextSpan span) predicate) {
  TextSpan? textSpan;

  for (final richText in find
      .byType(RichText)
      .evaluate()
      .map((element) => element.widget)
      .cast<RichText>()) {
    richText.text.visitChildren((span) {
      if (span is TextSpan && predicate(span)) {
        textSpan = span;
        return false;
      }

      return true;
    });
  }

  return textSpan;
}

class CustomMarkDef extends MarkDef {
  final Color color;

  static const schemaName = 'custom-mark';

  CustomMarkDef({required this.color, required super.key})
      : super(type: schemaName);

  factory CustomMarkDef.fromJson(final Map<String, dynamic> json) {
    return CustomMarkDef(
      color: Color(json['color']),
      key: json['_key'],
    );
  }
}
