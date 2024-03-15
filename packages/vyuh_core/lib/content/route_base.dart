import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class RouteBase extends ContentItem implements RootItem {
  final String title;

  final String path;
  final String? category;

  @JsonKey(readValue: readValue)
  final String id;

  @JsonKey(readValue: readValue)
  final DateTime updatedAt;

  @JsonKey(readValue: readValue)
  final DateTime createdAt;

  RouteBase({
    required super.schemaType,
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
}
