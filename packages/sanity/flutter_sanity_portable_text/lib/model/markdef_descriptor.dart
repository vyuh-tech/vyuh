import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../flutter_sanity_portable_text.dart';

part 'markdef_descriptor.g.dart';

/// Builds a [GestureRecognizer] for a given [MarkDef].
typedef GestureRecognizerBuilder = GestureRecognizer Function(
  BuildContext context,
  MarkDef mark,
);

/// Builds a [TextStyle] for a given [MarkDef].
typedef MarkDefTextStyleBuilder = TextStyle Function(
  BuildContext context,
  MarkDef mark,
  TextStyle base,
);

/// Deserializes a [MarkDef] from a JSON map.
typedef MarkDefFromJson = MarkDef Function(
  Map<String, dynamic> json,
);

/// Describes a [MarkDef] and its associated builders.
final class MarkDefDescriptor {
  /// The schema type of the mark.
  final String schemaType;

  /// Deserializes a [MarkDef] from a JSON map.
  final MarkDefFromJson fromJson;

  // We need to maintain separate style and recognizer builders as TextSpans
  // don't support recognizers on inner children.
  // Only the top-level TextSpan will be able to handle the hit-testing.

  /// Builds a [TextStyle] for a given [MarkDef].
  final MarkDefTextStyleBuilder? styleBuilder;

  /// Builds a [GestureRecognizer] for a given [MarkDef].
  final GestureRecognizerBuilder? recognizerBuilder;

  MarkDefDescriptor({
    required this.schemaType,
    required this.fromJson,
    this.styleBuilder,
    this.recognizerBuilder,
  });
}

/// A single mark definition.
@JsonSerializable()
class MarkDef {
  /// The key of the mark definition.
  @JsonKey(name: '_key')
  final String key;

  /// The type of the mark definition.
  @JsonKey(name: '_type')
  final String type;

  MarkDef({required this.key, required this.type});

  /// Converts a [MarkDef] to a JSON map.
  factory MarkDef.fromJson(final Map<String, dynamic> json) =>
      _$MarkDefFromJson(json);
}

/// Converts a list of [MarkDef]s from JSON.
/// It is an internal class used during the deserialization process.
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
