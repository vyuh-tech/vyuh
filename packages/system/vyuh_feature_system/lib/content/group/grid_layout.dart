import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'grid_layout.g.dart';

@JsonSerializable()
final class GridGroupLayout extends LayoutConfiguration<Group> {
  static const schemaName = '${Group.schemaName}.layout.grid';

  @JsonKey(defaultValue: 2)
  final int columns;

  @JsonKey(defaultValue: 1.0)
  final double aspectRatio;

  GridGroupLayout({this.columns = 2, this.aspectRatio = 1.0})
      : super(schemaType: schemaName) {
    assert(columns >= 2, 'Minimum of 2 columns is required');
  }

  factory GridGroupLayout.fromJson(Map<String, dynamic> json) =>
      _$GridGroupLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.title != null)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(content.title!, style: theme.textTheme.titleMedium),
          ),
        if (content.description != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
            child: Text(content.description!, style: theme.textTheme.bodySmall),
          ),
        GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
          ),
          children: content.items
              .map((e) => vyuh.content.buildContent(context, e))
              .toList(
                growable: false,
              ),
        ),
      ],
    );
  }
}
