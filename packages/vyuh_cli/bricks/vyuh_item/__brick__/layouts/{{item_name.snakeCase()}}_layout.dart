import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:feature_{{feature_name.snakeCase()}}/content/{{item_name.snakeCase()}}.dart';

part '{{item_name.snakeCase()}}_layout.g.dart';

@JsonSerializable()
final class {{item_name.pascalCase()}}Layout extends LayoutConfiguration<{{item_name.pascalCase()}}> {
  static const schemaName = '${{{item_name.pascalCase()}}.schemaName}.layout.default';
  
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: {{item_name.pascalCase()}}Layout.fromJson,
    title: '{{item_name.titleCase()}} Layout',
  );

  {{item_name.pascalCase()}}Layout() : super(schemaType: schemaName);
  
  factory {{item_name.pascalCase()}}Layout.fromJson(Map<String, dynamic> json) => 
    _${{item_name.pascalCase()}}LayoutFromJson(json);
  
  @override
  Widget build(BuildContext context, {{item_name.pascalCase()}} content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Slug: ${content.slug}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8.0),
            Divider(color: colorScheme.surfaceContainerHighest),
            if (content.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  content.description!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
