import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'route_base.g.dart';

abstract class RouteBase extends ContentItem implements RootItem {
  @JsonKey(defaultValue: 'Untitled')
  final String title;

  final String path;
  final Category? category;

  @JsonKey(fromJson: typeFromFirstOfListJson<RouteTypeConfiguration>)
  final RouteTypeConfiguration? routeType;

  @JsonKey(readValue: readValue)
  final String id;

  @JsonKey(readValue: readValue)
  final DateTime updatedAt;

  @JsonKey(readValue: readValue)
  final DateTime createdAt;

  RouteBase({
    required super.schemaType,
    this.routeType,
    required this.title,
    required this.path,
    this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required super.layout,
    required super.modifiers,
  });

  factory RouteBase.fromJson(Map<String, dynamic> json) =>
      vyuh.content.fromJson<ContentItem>(json) as RouteBase;

  Future<RouteBase?> init(BuildContext context);

  Future<void> dispose();

  Page<T> createPage<T>(BuildContext context, [LocalKey? pageKey]) {
    final child = vyuh.content.buildRoute(context, routeId: id);

    return routeType?.create(child, this, pageKey) ??
        MaterialPage(child: child, name: path, key: pageKey);
  }

  @override
  LayoutConfiguration? getLayout() {
    return super.getLayout() ?? category?.layout;
  }

  @override
  List<ContentModifierConfiguration>? getModifiers() {
    return super.getModifiers() ?? category?.modifiers;
  }
}

@JsonSerializable()
final class Category implements SchemaItem {
  @override
  String get schemaType => 'vyuh.category';

  final String identifier;
  final String title;

  @JsonKey(fromJson: typeFromFirstOfListJson<LayoutConfiguration>)
  final LayoutConfiguration? layout;

  @JsonKey(fromJson: modifierList)
  final List<ContentModifierConfiguration>? modifiers;

  static List<ContentModifierConfiguration>? modifierList(dynamic json) =>
      listFromJson<ContentModifierConfiguration>(json);

  Category({
    required this.identifier,
    required this.title,
    this.layout,
    this.modifiers,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

abstract class RouteTypeConfiguration implements SchemaItem {
  final String? title;

  @override
  final String schemaType;

  RouteTypeConfiguration({this.title, required this.schemaType});

  Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]);
}

abstract class RouteLifecycleConfiguration implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  RouteLifecycleConfiguration({this.title, required this.schemaType});

  Future<void> init(BuildContext context, RouteBase route);

  Future<void> dispose();
}
