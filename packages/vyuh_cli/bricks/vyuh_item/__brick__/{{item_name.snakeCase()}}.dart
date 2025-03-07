import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import './layouts/{{item_name.snakeCase()}}_layout.dart';

part '{{item_name.snakeCase()}}.g.dart';

@JsonSerializable()
final class {{item_name.pascalCase()}} extends ContentItem {
  static const schemaName = '{{feature_name.camelCase()}}.{{item_name.camelCase()}}';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: {{item_name.pascalCase()}}.fromJson,
    title: '{{item_name.titleCase()}}',
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: {{item_name.pascalCase()}}Layout(),
    defaultLayoutDescriptor: {{item_name.pascalCase()}}Layout.typeDescriptor,
  );

  static final descriptor = ContentDescriptor.createDefault(
    schemaType: schemaName,
    title: '{{item_name.titleCase()}}',
  );

  @JsonKey(name: '_id')
  final String id;

  final String title;
  final String slug;
  final String? description;

  {{item_name.pascalCase()}}({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory {{item_name.pascalCase()}}.fromJson(Map<String, dynamic> json) =>
      _${{item_name.pascalCase()}}FromJson(json);
}
