import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class RouteBase extends ContentItem implements RootItem {
  final String title;

  final String path;
  final String? category;

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
    super.layout,
  });

  factory RouteBase.fromJson(Map<String, dynamic> json) =>
      vyuh.content.fromJson<ContentItem>(json) as RouteBase;

  Future<RouteBase?> init();

  Future<void> dispose();

  Page<T> createPage<T>(BuildContext context, [LocalKey? pageKey]) {
    final child = vyuh.content.buildRoute(context, routeId: id);

    return routeType?.create(child, this, pageKey) ??
        MaterialPage(child: child, name: path, key: pageKey);
  }
}

abstract class RouteTypeConfiguration implements SchemaItem {
  final String? title;

  @override
  final String schemaType;

  RouteTypeConfiguration({this.title, required this.schemaType});

  Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]);
}
