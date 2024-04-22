// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      title: json['title'] as String?,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layout: typeFromFirstOfListJson(json['layout']),
    );

CarouselGroupLayout _$CarouselGroupLayoutFromJson(Map<String, dynamic> json) =>
    CarouselGroupLayout();

GroupConditionalLayout _$GroupConditionalLayoutFromJson(
        Map<String, dynamic> json) =>
    GroupConditionalLayout(
      cases: (json['cases'] as List<dynamic>)
          .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCase: json['defaultCase'] as String,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );
