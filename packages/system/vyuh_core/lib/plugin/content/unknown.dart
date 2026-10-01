import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'unknown.g.dart';

@JsonSerializable()
class Unknown extends ContentItem {
  static const schemaName = 'vyuh.unknown';
  static final typeDescriptor = TypeDescriptor(
    schemaType: Unknown.schemaName,
    fromJson: Unknown.fromJson,
    title: 'Unknown',
    preview: () =>
        Unknown(missingSchemaType: 'missing.type', description: 'Unknown Item'),
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

  String get blockType => Unknown.schemaName;
}
