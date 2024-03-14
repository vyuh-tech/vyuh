import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class ContentExtensionDescriptor extends FeatureExtensionDescriptor {
  ContentExtensionDescriptor({
    this.contents,
    this.contentBuilders,
    this.actions,
    this.conditions,
    this.routeInitializers,
    this.routeTypes,
  }) : super(title: 'Content Extension');

  final List<ContentDescriptor>? contents;
  final List<ContentBuilder>? contentBuilders;
  final List<TypeDescriptor<ActionConfiguration>>? actions;
  final List<TypeDescriptor<ConditionConfiguration>>? conditions;
  final List<TypeDescriptor<RouteInitConfiguration>>? routeInitializers;
  final List<TypeDescriptor<RouteTypeConfiguration>>? routeTypes;
}

abstract class RouteTypeConfiguration {
  final String? title;
  final String schemaType;

  RouteTypeConfiguration({this.title, required this.schemaType});

  Page<T> create<T>(Widget child, RouteBase route);
}

abstract class RouteInitConfiguration {
  final String? title;

  RouteInitConfiguration({this.title});

  Future<void> init(RouteBase route);

  Future<void> dispose();
}
