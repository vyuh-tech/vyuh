import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart' as vt;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'tabs.g.dart';

@JsonSerializable()
final class TabsRouteLayout extends LayoutConfiguration<vt.RouteBase> {
  static const schemaName = 'vyuh.route.layout.tabs';

  final List<LinkedRoute> routes;

  TabsRouteLayout({required this.routes}) : super(schemaType: schemaName);

  factory TabsRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$TabsRouteLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vt.RouteBase content) {
    final layout = content.layout as TabsRouteLayout;

    return RouteContainer(
      content: content,
      child: DefaultTabController(
        length: layout.routes.length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: TabBar(
              tabs: layout.routes
                  .map((e) => Tab(text: e.title))
                  .toList(growable: false),
            ),
          ),
          body: TabBarView(
            children: layout.routes
                .map((e) =>
                    vyuh.content.buildRoute(context, routeId: e.route.ref))
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}

@JsonSerializable()
final class LinkedRoute {
  final String title;
  final String? description;
  final String identifier;
  final ObjectReference route;

  LinkedRoute({
    required this.title,
    required this.identifier,
    required this.route,
    this.description,
  });

  factory LinkedRoute.fromJson(Map<String, dynamic> json) =>
      _$LinkedRouteFromJson(json);
}
