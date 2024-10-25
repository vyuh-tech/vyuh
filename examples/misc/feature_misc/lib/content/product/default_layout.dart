import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_misc/content/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

part 'default_layout.g.dart';

@JsonSerializable()
final class DefaultProductCardLayout extends LayoutConfiguration<ProductCard> {
  static const schemaName = '${ProductCard.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Product',
    fromJson: DefaultProductCardLayout.fromJson,
  );

  DefaultProductCardLayout() : super(schemaType: schemaName);

  factory DefaultProductCardLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultProductCardLayoutFromJson(json);

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
              ClipRRect(
                borderRadius: BorderRadius.circular(theme.borderRadius.small),
                child: ContentImage(
                  ref: content.image!,
                  width: 150,
                ),
              ),
            Gap.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.category,
                    style: theme.textTheme.labelSmall,
                  ),
                  Text(
                    content.title,
                    style:
                        theme.textTheme.titleMedium?.apply(heightFactor: 0.75),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      content.description,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
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
