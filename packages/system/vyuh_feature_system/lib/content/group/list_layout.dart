import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'list_layout.g.dart';

@JsonSerializable()
final class ListGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.list';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ListGroupLayout.fromJson,
    title: 'List layout',
  );

  ListGroupLayout() : super(schemaType: schemaName);

  factory ListGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$ListGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    final theme = Theme.of(context);
    final maxScreenHeight = MediaQuery.sizeOf(context).height * 0.8;

    return LimitedBox(
      maxHeight: maxScreenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content.title!, style: theme.textTheme.titleMedium),
            ),
          if (content.description != null)
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child:
                  Text(content.description!, style: theme.textTheme.bodySmall),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: content.items.length,
              itemBuilder: (context, index) =>
                  vyuh.content.buildContent(context, content.items[index]),
            ),
          ),
        ],
      ),
    );
  }
}
