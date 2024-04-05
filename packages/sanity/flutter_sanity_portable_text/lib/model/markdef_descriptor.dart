import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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

/// Builds an [InlineSpan] for a given [MarkDef].
typedef MarkDefSpanBuilder = InlineSpan Function(
  BuildContext context,
  MarkDef mark,
  String text,
  TextStyle style,
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
  final MarkDefTextStyleBuilder styleBuilder;

  /// Builds a [GestureRecognizer] for a given [MarkDef].
  final MarkDefSpanBuilder? spanBuilder;

  MarkDefDescriptor({
    required this.schemaType,
    required this.fromJson,
    required this.styleBuilder,
    this.spanBuilder,
  });
}

/// A single mark definition.
abstract class MarkDef {
  /// The key of the mark definition.
  @JsonKey(name: '_key')
  final String key;

  /// The type of the mark definition.
  @JsonKey(name: '_type')
  final String type;

  MarkDef({required this.key, required this.type});

  /// Converts a [MarkDef] to a JSON map. Should be implemented by subclasses.
  factory MarkDef.fromJson(final Map<String, dynamic> json) =>
      throw UnsupportedError('This should be implemented by the subclass.');
}
