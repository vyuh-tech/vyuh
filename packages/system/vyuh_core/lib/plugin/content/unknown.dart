import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'unknown.g.dart';

@JsonSerializable()
class Unknown extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.unknown';
  static final typeDescriptor = TypeDescriptor(
    schemaType: Unknown.schemaName,
    fromJson: Unknown.fromJson,
    title: 'Unknown',
  );

  final String missingSchemaType;
  final String description;

  Unknown({
    required this.missingSchemaType,
    required this.description,
    super.layout,
    super.modifiers,
  }) : super(schemaType: Unknown.schemaName);

  factory Unknown.fromJson(Map<String, dynamic> json) =>
      _$UnknownFromJson(json);

  @override
  String get blockType => Unknown.schemaName;
}
