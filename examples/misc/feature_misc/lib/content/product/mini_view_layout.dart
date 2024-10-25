import 'package:design_system/utils/extensions.dart';
import 'package:feature_misc/content/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

part 'mini_view_layout.g.dart';

@JsonSerializable()
final class MiniViewProductCardLayout extends LayoutConfiguration<ProductCard> {
  static const schemaName = '${ProductCard.schemaName}.layout.miniView';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Mini View Layout',
    fromJson: MiniViewProductCardLayout.fromJson,
  );

  final bool showCategory;

  MiniViewProductCardLayout({this.showCategory = true})
      : super(schemaType: schemaName);

  factory MiniViewProductCardLayout.fromJson(Map<String, dynamic> json) =>
      _$MiniViewProductCardLayoutFromJson(json);

  @override
  Widget build(BuildContext context, ProductCard content) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (content.image != null)
              Padding(
                padding: EdgeInsets.only(right: theme.spacing.s8),
                child: ContentImage(
                  ref: content.image!,
                  width: 64,
                  fit: BoxFit.contain,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCategory)
                    Text(
                      content.category,
                      style: theme.textTheme.labelSmall,
                    ),
                  Text(
                    content.title,
                    style:
                        theme.textTheme.titleMedium?.apply(heightFactor: 0.75),
                  ),
                  SizedBox(height: theme.spacing.s8),
                  Text(
                    '\$${content.price}',
                    style:
                        theme.textTheme.bodyMedium?.apply(fontWeightDelta: 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
