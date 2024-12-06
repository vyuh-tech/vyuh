import 'package:feature_misc/content/product/default_layout.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'product_card.g.dart';

@JsonSerializable(createToJson: false)
final class ProductCard extends ContentItem {
  static const schemaName = 'misc.productCard';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Product Card',
    fromJson: ProductCard.fromJson,
  );

  static final contentBuilder = ContentBuilder<ProductCard>(
    content: ProductCard.typeDescriptor,
    defaultLayout: DefaultProductCardLayout(),
    defaultLayoutDescriptor: DefaultProductCardLayout.typeDescriptor,
  );

  final String title;
  final String description;
  final ImageReference? image;
  final double price;
  final String skuId;
  final String category;

  ProductCard({
    required this.title,
    required this.description,
    this.image,
    required this.price,
    required this.skuId,
    required this.category,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory ProductCard.fromJson(Map<String, dynamic> json) =>
      _$ProductCardFromJson(json);
}

final class ProductCardDescriptor extends ContentDescriptor {
  ProductCardDescriptor({super.layouts})
      : super(schemaType: ProductCard.schemaName, title: 'Product Card');
}
