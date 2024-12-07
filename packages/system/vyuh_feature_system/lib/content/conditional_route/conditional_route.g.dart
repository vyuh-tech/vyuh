// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditional_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaseRouteItem _$CaseRouteItemFromJson(Map<String, dynamic> json) =>
    CaseRouteItem(
      value: json['value'] as String?,
      item: json['item'] == null
          ? null
          : ObjectReference.fromJson(json['item'] as Map<String, dynamic>),
    );

ConditionalRoute _$ConditionalRouteFromJson(Map<String, dynamic> json) =>
    ConditionalRoute(
      condition: json['condition'] == null
          ? null
          : Condition.fromJson(json['condition'] as Map<String, dynamic>),
      cases: (json['cases'] as List<dynamic>?)
              ?.map((e) => CaseRouteItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      defaultCase: json['defaultCase'] as String?,
      title: json['title'] as String? ?? 'Untitled',
      path: json['path'] as String,
      createdAt: DateTime.parse(readValue(json, 'createdAt') as String),
      updatedAt: DateTime.parse(readValue(json, 'updatedAt') as String),
      id: readValue(json, 'id') as String,
      layout: typeFromFirstOfListJson(json['layout']),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
