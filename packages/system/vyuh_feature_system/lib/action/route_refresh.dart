import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'route_refresh.g.dart';

@JsonSerializable()
final class RouteRefreshAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.routeRefresh';
  static final typeDescriptor = TypeDescriptor(
    schemaType: RouteRefreshAction.schemaName,
    title: 'Route Refresh Action',
    fromJson: RouteRefreshAction.fromJson,
  );

  RouteRefreshAction({
    super.title,
  }) : super(schemaType: schemaName);

  factory RouteRefreshAction.fromJson(Map<String, dynamic> json) =>
      _$RouteRefreshActionFromJson(json);

  @override
  void execute(BuildContext context) async {
    final routeProxy = RouteBuilderProxy.of(context);
    routeProxy?.refresh();
  }
}
