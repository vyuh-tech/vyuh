import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/group/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'grid_layout.g.dart';

@JsonSerializable()
final class GridGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.grid';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Grid Layout',
    fromJson: GridGroupLayout.fromJson,
    preview: () => GridGroupLayout(),
  );

  @JsonKey(defaultValue: 2)
  final int columns;

  @JsonKey(defaultValue: 1.0)
  final double aspectRatio;

  final bool scrollable;

  GridGroupLayout(
      {this.columns = 2, this.aspectRatio = 1.0, this.scrollable = false})
      : super(schemaType: schemaName);

  factory GridGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$GridGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    final gridContent = GridView.builder(
      shrinkWrap: true,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) => VyuhBinding.instance.content
          .buildContent(context, content.items[index]),
      itemCount: content.items.length,
    );

    return GroupLayoutContainer(
      content: content,
      body: scrollable ? Expanded(child: gridContent) : gridContent,
    );
  }
}
