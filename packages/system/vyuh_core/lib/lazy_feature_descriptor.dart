import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A callback that loads a [FeatureDescriptor], potentially using
/// Dart's deferred import mechanism for web code splitting.
///
/// Example usage with deferred imports:
/// ```dart
/// import 'package:feature_food/feature_food.dart' deferred as food;
///
/// final loader = () async {
///   await food.loadLibrary();
///   return food.feature;
/// };
/// ```
typedef DeferredFeatureLoader = Future<FeatureDescriptor> Function();

/// Describes a feature that should be loaded lazily — only when
/// one of its route prefixes is first navigated to.
///
/// This enables:
/// - Web code splitting via Dart's `deferred as` imports
/// - Faster app startup by deferring init/extension registration
/// - Smaller initial bundle on web
///
/// On native platforms (iOS, Android), `loadLibrary()` is a no-op so the
/// same code works everywhere — it simply defers initialization.
///
/// Example:
/// ```dart
/// import 'package:feature_food/feature_food.dart' deferred as food;
///
/// LazyFeatureDescriptor(
///   name: 'food',
///   title: 'Food',
///   routePrefixes: ['/food'],
///   loader: () async {
///     await food.loadLibrary();
///     return food.feature;
///   },
/// )
/// ```
final class LazyFeatureDescriptor {
  /// Unique name for this feature. Must match the inner
  /// [FeatureDescriptor.name] returned by [loader].
  final String name;

  /// Human-readable title shown in the loading UI while the feature
  /// is being downloaded and initialized.
  final String title;

  /// Optional description of what this feature does.
  final String? description;

  /// Optional icon for the loading indicator.
  final IconData? icon;

  /// Route path prefixes that belong to this feature.
  /// When any URL matching these prefixes is navigated to,
  /// the feature is loaded.
  ///
  /// Example: `['/food', '/food-admin']`
  final List<String> routePrefixes;

  /// The function that loads the actual [FeatureDescriptor].
  /// This is where `deferred as` loading happens.
  final DeferredFeatureLoader loader;

  /// Optional list of feature names this feature depends on.
  /// If a dependency is also lazy, it will be loaded first.
  /// If a dependency is already loaded (eager or previously loaded lazy),
  /// it is skipped.
  final List<String> dependencies;

  /// Optional feature flag name. If provided and a [FeatureFlagPlugin]
  /// is registered, the feature is only loaded when the flag evaluates
  /// to true.
  final String? featureFlag;

  LazyFeatureDescriptor({
    required this.name,
    required this.title,
    required this.routePrefixes,
    required this.loader,
    this.description,
    this.icon,
    this.dependencies = const [],
    this.featureFlag,
  }) : assert(routePrefixes.isNotEmpty,
            'At least one route prefix is required for lazy feature "$name"');
}
