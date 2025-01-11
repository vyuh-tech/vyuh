import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/group/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'list_layout.g.dart';

@JsonSerializable()
final class ListGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.list';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ListGroupLayout.fromJson,
    title: 'List layout',
    preview: () => ListGroupLayout(),
  );

  final double percentHeight;

  ListGroupLayout({this.percentHeight = 0.5}) : super(schemaType: schemaName);

  factory ListGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$ListGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    final maxScreenHeight = MediaQuery.sizeOf(context).height * percentHeight;

    return GroupLayoutContainer(
      content: content,
      body: LimitedBox(
        maxHeight: maxScreenHeight,
        child: ListView.builder(
          padding: const EdgeInsets.all(4.0),
          itemCount: content.items.length,
          itemBuilder: (context, index) =>
              vyuh.content.buildContent(context, content.items[index]),
        ),
      ),
    );
  }
}
