import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'route.g.dart';

/// A route represents a page or screen in the application with configurable regions
/// and lifecycle handlers.
///
/// Routes can be:
/// * Pages with different layouts (default, tabs, single item)
/// * Dialog routes for modal content
/// * Conditional routes that adapt based on conditions
///
/// Example:
/// ```dart
/// final route = Route(
///   title: 'Home',
///   routeType: PageRouteType(),
///   path: '/home',
///   regions: [
///     Region(
///       identifier: 'body',
///       title: 'Body',
///       items: [myCard, myGroup],
///     ),
///   ],
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
///   id: 'home-route',
/// );
/// ```
@JsonSerializable()
final class Route extends RouteBase {
  static const schemaName = 'vyuh.route';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Route',
    fromJson: Route.fromJson,
    preview: () => Route(
      title: 'Preview Route',
      routeType: PageRouteType(),
      path: '/preview',
      regions: [
        Region(identifier: 'body', title: 'Body', items: [
          Card.typeDescriptor.preview!.call(),
          Group.typeDescriptor.preview!.call(),
        ]),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: 'preview-id',
    ),
  );
  static final contentBuilder = _RouteContentBuilder();

  @JsonKey(defaultValue: [])
  final List<Region> regions;

  Route? _initializedInstance;

  Route({
    required super.title,
    required super.routeType,
    required super.path,
    required this.regions,
    required super.createdAt,
    required super.updatedAt,
    required super.id,
    super.category,
    super.layout,
    super.modifiers,
    this.lifecycleHandlers,
  }) : super(schemaType: Route.schemaName) {
    setParent(regions.expand((element) => element.items));
  }

  @JsonKey(defaultValue: [], fromJson: lifecycleHandlersFromJson)
  final List<RouteLifecycleConfiguration>? lifecycleHandlers;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  static List<RouteLifecycleConfiguration>? lifecycleHandlersFromJson(
          dynamic json) =>
      listFromJson<RouteLifecycleConfiguration>(json);

  @override
  Future<RouteBase?> init(BuildContext context) async {
    if (_initializedInstance != null) {
      return _initializedInstance;
    }

    if (lifecycleHandlers != null && lifecycleHandlers!.isNotEmpty) {
      for (final config in lifecycleHandlers!) {
        await config.init(context, this);
      }
    }

    _initializedInstance = this;
    return _initializedInstance;
  }

  @override
  Future<void> dispose() async {
    if (lifecycleHandlers != null && lifecycleHandlers!.isNotEmpty) {
      for (final config in lifecycleHandlers!) {
        await config.dispose();
      }
    }
  }
}

/// A section of a route that can contain content items.
///
/// Regions help organize content within a route, for example:
/// * Header region for navigation and branding
/// * Body region for main content
/// * Footer region for additional information
///
/// Example:
/// ```dart
/// final region = Region(
///   identifier: 'body',
///   title: 'Body Content',
///   items: [myCard, myGroup],
/// );
/// ```
@JsonSerializable()
final class Region {
  final String identifier;
  final String title;

  @JsonKey(defaultValue: [])
  final List<ContentItem> items;

  Region({
    required this.identifier,
    required this.title,
    required this.items,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}

/// Descriptor for configuring route content type in the system.
///
/// Allows configuring:
/// * Lifecycle handlers for route initialization and cleanup
/// * Route types (page, dialog)
/// * Available layouts for routes
///
/// Example:
/// ```dart
/// final descriptor = RouteDescriptor(
///   lifecycleHandlers: [myHandler],
///   routeTypes: [PageRouteType.typeDescriptor],
///   layouts: [DefaultRouteLayout.typeDescriptor],
/// );
/// ```
final class RouteDescriptor extends ContentDescriptor {
  List<TypeDescriptor<RouteLifecycleConfiguration>>? lifecycleHandlers;
  List<TypeDescriptor<RouteTypeConfiguration>>? routeTypes;

  RouteDescriptor({
    this.lifecycleHandlers,
    this.routeTypes,
    super.layouts,
  }) : super(schemaType: Route.schemaName, title: 'Route');
}

final class _RouteContentBuilder extends ContentBuilder<Route> {
  _RouteContentBuilder()
      : super(
          content: Route.typeDescriptor,
          defaultLayout: DefaultRouteLayout(),
          defaultLayoutDescriptor: DefaultRouteLayout.typeDescriptor,
        );

  @override
  init(List<ContentDescriptor> descriptors) {
    super.init(descriptors);

    final rtDescriptors = descriptors.cast<RouteDescriptor>();
    final initConfigs = rtDescriptors.expand((element) =>
        element.lifecycleHandlers ??
        <TypeDescriptor<RouteLifecycleConfiguration>>[]);

    for (final config in initConfigs) {
      vyuh.content.register<RouteLifecycleConfiguration>(config);
    }

    final routeTypes = rtDescriptors.expand((element) =>
        element.routeTypes ?? <TypeDescriptor<RouteTypeConfiguration>>[]);

    for (final config in routeTypes) {
      vyuh.content.register<RouteTypeConfiguration>(config);
    }
  }
}

/// A conditional layout for routes that adapts based on specified conditions.
///
/// Allows defining different layouts for routes based on conditions like:
/// * Screen size
/// * Platform
/// * Theme mode
/// * Authentication state
///
/// Example:
/// ```dart
/// final layout = RouteConditionalLayout(
///   cases: [
///     LayoutCase(
///       condition: ScreenSize(),
///       layout: MobileLayout(),
///     ),
///   ],
///   defaultCase: DesktopLayout(),
///   condition: ScreenSize(),
/// );
/// ```
@JsonSerializable()
final class RouteConditionalLayout extends ConditionalLayout<Route> {
  static const schemaName = '${Route.schemaName}.layout.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Conditional Route Layout',
    fromJson: RouteConditionalLayout.fromJson,
  );

  RouteConditionalLayout({
    required super.cases,
    required super.defaultCase,
    required super.condition,
  }) : super(schemaType: schemaName);

  factory RouteConditionalLayout.fromJson(Map<String, dynamic> json) =>
      _$RouteConditionalLayoutFromJson(json);
}
