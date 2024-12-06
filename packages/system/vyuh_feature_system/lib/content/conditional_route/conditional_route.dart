import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'conditional_route.g.dart';

@JsonSerializable()
final class CaseRouteItem {
  final String? value;

  final ObjectReference? item;

  CaseRouteItem({this.value, this.item});

  factory CaseRouteItem.fromJson(Map<String, dynamic> json) =>
      _$CaseRouteItemFromJson(json);
}

@JsonSerializable()
final class ConditionalRoute extends RouteBase {
  static const schemaName = 'vyuh.conditionalRoute';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Conditional Route',
    fromJson: ConditionalRoute.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: ConditionalRoute.typeDescriptor,
    defaultLayout: DefaultConditionalRouteLayout(),
    defaultLayoutDescriptor: DefaultConditionalRouteLayout.typeDescriptor,
  );

  @JsonKey(defaultValue: [])
  final List<CaseRouteItem>? cases;
  final String? defaultCase;
  final Condition? condition;

  RouteBase? _initializedInstance;

  ConditionalRoute({
    this.condition,
    this.cases,
    this.defaultCase,
    required super.title,
    required super.path,
    required super.createdAt,
    required super.updatedAt,
    required super.id,
    super.layout,
    super.category,
    super.modifiers,
  }) : super(schemaType: ConditionalRoute.schemaName, routeType: null);

  factory ConditionalRoute.fromJson(Map<String, dynamic> json) =>
      _$ConditionalRouteFromJson(json);

  @override
  Future<RouteBase?> init() async {
    return this;
  }

  Future<RouteBase?> evaluate(BuildContext context) async {
    if (_initializedInstance != null) {
      return _initializedInstance;
    }

    final value = (await condition?.execute(context)) ?? defaultCase;
    final caseItem = (cases ?? []).firstWhereOrNull((x) => x.value == value);

    final ref = caseItem?.item;
    RouteBase? leafRoute;

    if (ref != null) {
      final route = await vyuh.content.provider.fetchRoute(routeId: ref.ref);
      leafRoute = await route?.init();
    }

    _initializedInstance = leafRoute;
    return _initializedInstance;
  }

  @override
  Future<void> dispose() => Future.value();
}

class ConditionalRouteDescriptor extends ContentDescriptor {
  ConditionalRouteDescriptor({super.layouts})
      : super(
            schemaType: ConditionalRoute.schemaName,
            title: 'Conditional Route');
}
