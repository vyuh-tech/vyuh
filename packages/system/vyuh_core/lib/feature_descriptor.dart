import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/vyuh_core.dart';

/// A function that returns a list of routes.
typedef RouteBuilderFunction = FutureOr<List<g.RouteBase>?> Function(
    VyuhPlatform platform);

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
  final Future<void> Function(VyuhPlatform)? init;

  /// The function to dispose the feature.
  final Future<void> Function()? dispose;

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
  }) : _routes = _runOnce(routes) {
    // Set the source feature in all extension builders
    for (final extensionBuilder in extensionBuilders ?? <ExtensionBuilder>[]) {
      extensionBuilder.setSourceFeature(name);
    }

    // Set the source feature in all extensions
    for (final extension in extensions ?? <ExtensionDescriptor>[]) {
      extension.setSourceFeature(name);
    }
  }
}

FutureOr<T?> Function(VyuhPlatform) _runOnce<T>(
    FutureOr<T?> Function(VyuhPlatform) fn) {
  var executed = false;
  T? result;

  return (VyuhPlatform platform) async {
    // This check is needed to reset the executed flag
    // when the feature is reinitialized
    if (platform.tracker.currentState.value != InitState.ready) {
      executed = false;
    }

    if (executed) {
      return result;
    }

    result = await fn(platform);

    // Mark as executed only upon successful completion
    executed = true;

    return result;
  };
}
