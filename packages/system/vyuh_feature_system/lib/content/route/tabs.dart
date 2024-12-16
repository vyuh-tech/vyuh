import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nanoid/nanoid.dart';
import 'package:vyuh_core/vyuh_core.dart' as vt;
import 'package:vyuh_core/vyuh_core.dart';

part 'tabs.g.dart';

@JsonSerializable()
final class TabsRouteLayout extends LayoutConfiguration<vt.RouteBase> {
  static const schemaName = 'vyuh.route.layout.tabs';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Tabs Route Layout',
    fromJson: TabsRouteLayout.fromJson,
  );

  final List<LinkedRoute> routes;

  TabsRouteLayout({required this.routes}) : super(schemaType: schemaName);

  factory TabsRouteLayout.fromJson(Map<String, dynamic> json) =>
      _$TabsRouteLayoutFromJson(json);

  @override
  Widget build(BuildContext context, vt.RouteBase content) {
    final layout = content.layout as TabsRouteLayout;

    return DefaultTabController(
      length: layout.routes.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: layout.routes
                .map((e) => Tab(
                      text: e.title,
                      icon: e.title == null
                          ? const Icon((Icons.question_mark))
                          : null,
                    ))
                .toList(growable: false),
          ),
        ),
        body: TabBarView(
          children: layout.routes
              .map(
                  (e) => vyuh.content.buildRoute(context, routeId: e.route.ref))
              .toList(growable: false),
        ),
      ),
    );
  }
}

@JsonSerializable()
final class LinkedRoute {
  final String? title;
  final String? description;
  final String identifier;
  final ObjectReference route;

  LinkedRoute({
    this.title,
    String? identifier,
    required this.route,
    this.description,
  }) : identifier = identifier ?? nanoid();

  factory LinkedRoute.fromJson(Map<String, dynamic> json) =>
      _$LinkedRouteFromJson(json);
}
