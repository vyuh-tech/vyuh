import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../flutter_sanity_portable_text.dart';

part 'markdef_descriptor.g.dart';

typedef GestureRecognizerBuilder = GestureRecognizer Function(
  MarkDef mark,
  BuildContext context,
);

typedef MarkDefTextStyleBuilder = TextStyle Function(
  MarkDef mark,
  BuildContext context,
  TextStyle base,
);

typedef MarkDefFromJson = MarkDef Function(
  Map<String, dynamic> json,
);

final class MarkDefDescriptor {
  final String schemaType;
  final MarkDefFromJson fromJson;

  // We need to maintain separate style and recognizer builders as TextSpans
  // don't support recognizers on inner children.
  // Only the top-level TextSpan will be able to handle the hit-testing.
  final MarkDefTextStyleBuilder? styleBuilder;
  final GestureRecognizerBuilder? recognizerBuilder;

  MarkDefDescriptor({
    required this.schemaType,
    required this.fromJson,
    this.styleBuilder,
    this.recognizerBuilder,
  });
}

@JsonSerializable()
class MarkDef {
  @JsonKey(name: '_key')
  final String key;

  @JsonKey(name: '_type')
  final String type;

  MarkDef({required this.key, required this.type});

  factory MarkDef.fromJson(final Map<String, dynamic> json) =>
      _$MarkDefFromJson(json);
}

class MarkDefsConverter extends JsonConverter<List<MarkDef>, List<dynamic>> {
  const MarkDefsConverter();

  @override
  List toJson(final List<MarkDef> object) {
    throw UnimplementedError();
  }

  @override
  List<MarkDef> fromJson(final List<dynamic> json) {
    final markDefs = PortableTextConfig.shared.markDefs;

    final items = json.map((final item) {
      final json = item as Map<String, dynamic>;
      final type = item['_type'] as String;

      final descriptor = markDefs[type];
      final builder = descriptor?.fromJson ?? MarkDef.fromJson;

      return builder(json);
    }).toList(growable: false);

    return items;
  }
}
