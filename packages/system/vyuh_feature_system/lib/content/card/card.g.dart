// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] == null
          ? null
          : PortableTextContent.fromJson(
              json['content'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] == null
          ? null
          : Uri.parse(json['imageUrl'] as String),
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      secondaryAction: json['secondaryAction'] == null
          ? null
          : Action.fromJson(json['secondaryAction'] as Map<String, dynamic>),
      tertiaryAction: json['tertiaryAction'] == null
          ? null
          : Action.fromJson(json['tertiaryAction'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
    );

CardConditionalLayout _$CardConditionalLayoutFromJson(
        Map<String, dynamic> json) =>
    CardConditionalLayout(
      cases: (json['cases'] as List<dynamic>)
          .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCase: json['defaultCase'] as String,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );
