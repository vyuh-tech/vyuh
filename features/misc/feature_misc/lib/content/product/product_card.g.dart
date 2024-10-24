// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCard _$ProductCardFromJson(Map<String, dynamic> json) => ProductCard(
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      skuId: json['skuId'] as String,
      category: json['category'] as String,
      layout: typeFromFirstOfListJson(json['layout']),
    );
