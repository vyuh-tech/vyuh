import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/vyuh_core.dart';

typedef FeatureInitFunction = Future<void> Function();
typedef RouteBuilderFunction = FutureOr<List<g.RouteBase>?> Function();

final class FeatureDescriptor {
  final String name;
  final String title;
  final String? description;
  final IconData? icon;
  final FeatureInitFunction? init;

  final List<FeatureExtensionDescriptor>? extensions;
  final List<FeatureExtensionBuilder>? extensionBuilders;

  final RouteBuilderFunction _routes;
  RouteBuilderFunction? get routes => _routes;

  FeatureDescriptor({
    required this.name,
    required this.title,
    this.description,
    this.icon,
    this.init,
    required RouteBuilderFunction routes,
    this.extensions,
    this.extensionBuilders,
  }) : _routes = _runOnce(routes);
}

FutureOr<T?> Function() _runOnce<T>(FutureOr<T?> Function() fn) {
  var executed = false;
  T? result;

  return () async {
    if (vyuh.tracker.currentState.value != InitState.ready) {
      executed = false;
    }

    if (executed) {
      return result;
    }

    result = await fn();

    // Mark as executed only upon successful completion
    executed = true;

    return result;
  };
}
