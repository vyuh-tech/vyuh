import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'grid_layout.g.dart';

@JsonSerializable()
final class GridGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.grid';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Grid Layout',
    fromJson: GridGroupLayout.fromJson,
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
    final theme = Theme.of(context);
    final gridContent = GridView.builder(
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) =>
          vyuh.content.buildContent(context, content.items[index]),
      itemCount: content.items.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (content.title != null)
                Text(content.title!,
                    style:
                        theme.textTheme.titleMedium?.apply(fontWeightDelta: 2)),
              if (content.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(content.description!,
                      style: theme.textTheme.bodySmall),
                ),
            ],
          ),
        ),
        if (scrollable) Expanded(child: gridContent) else gridContent,
      ],
    );
  }
}
