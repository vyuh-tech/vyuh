import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'route_base.g.dart';

/// Base class for all route content items in Vyuh.
///
/// Routes represent navigable content in a Vyuh application. They combine
/// content from the CMS with routing configuration to create dynamic,
/// content-driven navigation.
///
/// Key features:
/// - Content-driven routing using CMS data
/// - Customizable route types and transitions
/// - Category-based organization
/// - Lifecycle management
abstract class RouteBase extends ContentItem implements RootItem {
  /// The title of the route, displayed in navigation UI.
  @JsonKey(defaultValue: 'Untitled')
  final String title;

  /// The URL path for this route.
  /// This is used to match URLs and generate links.
  final String path;

  /// Optional category for organizing routes.
  final Category? category;

  /// Configuration for how this route should be presented.
  /// Defines transitions, animations, and other route-specific behavior.
  @JsonKey(fromJson: typeFromFirstOfListJson<RouteTypeConfiguration>)
  final RouteTypeConfiguration? routeType;

  /// Unique identifier for this route.
  @JsonKey(readValue: readValue)
  final String id;

  /// When this route was last updated in the CMS.
  @JsonKey(readValue: readValue)
  final DateTime updatedAt;

  /// When this route was created in the CMS.
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
      VyuhBinding.instance.content.fromJson<ContentItem>(json) as RouteBase;

  /// Initialize the route when it becomes active.
  ///
  /// This is called when the route is first navigated to.
  /// Use this to set up any route-specific state or resources.
  /// Return null to prevent the route from being shown.
  Future<RouteBase?> init(BuildContext context);

  /// Clean up the route when it is no longer active.
  ///
  /// This is called when navigating away from the route.
  /// Use this to clean up any resources initialized in [init].
  Future<void> dispose();

  /// Create a Flutter page for this route.
  ///
  /// This method combines the route's content with its configuration
  /// to create a Flutter page that can be used in navigation.
  /// The [pageKey] is used for Flutter's page-based navigation system.
  Page<T> createPage<T>(BuildContext context, [LocalKey? pageKey]) {
    final child = VyuhBinding.instance.content.buildRoute(context, routeId: id);

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

/// A category for organizing routes.
///
/// Categories help structure routes in a hierarchical manner.
/// They can be used to:
/// - Group related routes
/// - Create navigation menus
/// - Filter and sort routes
///
/// Example:
/// ```dart
/// final category = Category(
///   title: 'Blog',
///   description: 'Blog posts and articles',
///   icon: Icons.article,
/// );
/// ```
@JsonSerializable()
class Category implements SchemaItem {
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

/// Configuration for how a route should be presented.
///
/// Route type configurations define the visual and behavioral aspects
/// of route transitions. They control:
/// - Page transitions and animations
/// - Route presentation mode (full-screen, modal, etc.)
/// - Route-specific UI elements
///
/// Example:
/// ```dart
/// class FadeRouteType extends RouteTypeConfiguration {
///   @override
///   Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]) {
///     return FadePage(
///       child: child,
///       key: pageKey,
///     );
///   }
/// }
/// ```
abstract class RouteTypeConfiguration implements SchemaItem {
  final String? title;

  @override
  final String schemaType;

  RouteTypeConfiguration({this.title, required this.schemaType});

  Page<T> create<T>(Widget child, RouteBase route, [LocalKey? pageKey]);
}

/// Configuration for managing route lifecycle events.
///
/// Route lifecycle configurations handle the initialization and cleanup
/// of route-specific resources. They can:
/// - Load route-specific data
/// - Set up route state
/// - Clean up resources
/// - Handle route-specific events
///
/// Example:
/// ```dart
/// class BlogLifecycle extends RouteLifecycleConfiguration {
///   @override
///   Future<void> init(BuildContext context, RouteBase route) async {
///     await loadBlogData();
///   }
///
///   @override
///   Future<void> dispose() async {
///     await saveBlogState();
///   }
/// }
/// ```
abstract class RouteLifecycleConfiguration implements SchemaItem {
  @override
  final String schemaType;

  final String? title;

  RouteLifecycleConfiguration({this.title, required this.schemaType});

  Future<void> init(BuildContext context, RouteBase route);

  Future<void> dispose();
}
