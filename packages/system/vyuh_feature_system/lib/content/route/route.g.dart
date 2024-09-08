// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      title: json['title'] as String? ?? 'Untitled',
      routeType: typeFromFirstOfListJson(json['routeType']),
      path: json['path'] as String,
      regions: (json['regions'] as List<dynamic>?)
              ?.map((e) => Region.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(readValue(json, 'createdAt') as String),
      updatedAt: DateTime.parse(readValue(json, 'updatedAt') as String),
      id: readValue(json, 'id') as String,
      category: json['category'] as String?,
      layout: typeFromFirstOfListJson(json['layout']),
      lifecycleHandlers: json['lifecycleHandlers'] == null
          ? []
          : Route.lifecycleHandlersFromJson(json['lifecycleHandlers']),
    );

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

RouteConditionalLayout _$RouteConditionalLayoutFromJson(
        Map<String, dynamic> json) =>
    RouteConditionalLayout(
      cases: (json['cases'] as List<dynamic>)
          .map((e) => LayoutCaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultCase: json['defaultCase'] as String,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
    );
