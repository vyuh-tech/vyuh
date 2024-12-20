import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'route.g.dart';

@JsonSerializable()
final class Route extends RouteBase {
  static const schemaName = 'vyuh.route';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Route',
    fromJson: Route.fromJson,
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
