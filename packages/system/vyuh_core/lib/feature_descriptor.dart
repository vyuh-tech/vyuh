import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/vyuh_core.dart';

/// A function that returns a void Future.
typedef VoidFutureFunction = Future<void> Function();

/// A function that returns a list of routes.
typedef RouteBuilderFunction = FutureOr<List<g.RouteBase>?> Function();

/// The essential descriptor for a feature. A feature descriptor provides
/// the necessary information to register a feature within the framework.
final class FeatureDescriptor {
  /// The name of the feature.
  final String name;

  /// The title of the feature.
  final String title;

  /// The description of the feature.
  final String? description;

  /// The icon of the feature.
  final IconData? icon;

  /// The function to initialize the feature.
  final VoidFutureFunction? init;

  /// The function to dispose the feature.
  final VoidFutureFunction? dispose;

  /// The list of extensions for the feature.
  final List<ExtensionDescriptor>? extensions;

  /// The list of extension builders exposed by this feature.
  final List<ExtensionBuilder>? extensionBuilders;

  final RouteBuilderFunction _routes;

  /// The routes for the feature.
  RouteBuilderFunction? get routes => _routes;

  /// Creates a new FeatureDescriptor.
  FeatureDescriptor({
    required this.name,
    required this.title,
    this.description,
    this.icon,
    this.init,
    this.dispose,
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
