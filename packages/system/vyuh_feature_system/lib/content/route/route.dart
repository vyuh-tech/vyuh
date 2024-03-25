import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/route/default_layout.dart';

part 'route.g.dart';

@JsonSerializable()
final class Route extends RouteBase {
  static const schemaName = 'vyuh.route';

  @JsonKey(fromJson: typeFromFirstOfListJson<RouteTypeConfiguration>)
  final RouteTypeConfiguration? routeType;

  @JsonKey(defaultValue: [])
  final List<Region> regions;

  Route? _initializedInstance;

  Route({
    required super.title,
    required this.routeType,
    required super.path,
    required this.regions,
    required super.createdAt,
    required super.updatedAt,
    required super.id,
    super.category,
    super.layout,
    this.lifecycleHandlers,
  }) : super(schemaType: Route.schemaName) {
    setParent(regions.expand((element) => element.items));
  }

  @JsonKey(defaultValue: [], fromJson: lifecycleHandlersFromJson)
  final List<RouteLifecycleHandler>? lifecycleHandlers;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  static List<RouteLifecycleHandler>? lifecycleHandlersFromJson(dynamic json) =>
      listFromJson<RouteLifecycleHandler>(json);

  flutter.Page<T> createPage<T>(flutter.BuildContext context) {
    final child = kDebugMode
        ? vyuh.content.buildRoute(context, routeId: id)
        : vyuh.content.buildContent(context, this);

    return routeType?.create(child, this) ?? flutter.MaterialPage(child: child);
  }

  @override
  Future<RouteBase?> init() async {
    if (_initializedInstance != null) {
      return _initializedInstance;
    }

    if (lifecycleHandlers != null && lifecycleHandlers!.isNotEmpty) {
      for (final config in lifecycleHandlers!) {
        await config.init(this);
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

final class RouteDescriptor extends ContentDescriptor {
  List<TypeDescriptor<RouteLifecycleHandler>>? lifecycleHandlers;
  List<TypeDescriptor<RouteTypeConfiguration>>? routeTypes;

  RouteDescriptor({
    this.lifecycleHandlers,
    this.routeTypes,
    super.layouts,
  }) : super(schemaType: Route.schemaName, title: 'Route');
}

final class RouteContentBuilder extends ContentBuilder<Route> {
  RouteContentBuilder()
      : super(
          content: TypeDescriptor(
              schemaType: Route.schemaName,
              title: 'Route',
              fromJson: Route.fromJson),
          defaultLayout: DefaultRouteLayout(),
          defaultLayoutDescriptor: DefaultRouteLayout.typeDescriptor,
        );

  @override
  init(List<ContentDescriptor> descriptors) {
    super.init(descriptors);

    final rtDescriptors = descriptors.cast<RouteDescriptor>();
    final initConfigs = rtDescriptors.expand((element) =>
        element.lifecycleHandlers ?? <TypeDescriptor<RouteLifecycleHandler>>[]);

    for (final config in initConfigs) {
      vyuh.content.register<RouteLifecycleHandler>(config);
    }

    final routeTypes = rtDescriptors.expand((element) =>
        element.routeTypes ?? <TypeDescriptor<RouteTypeConfiguration>>[]);

    for (final config in routeTypes) {
      vyuh.content.register<RouteTypeConfiguration>(config);
    }
  }
}
