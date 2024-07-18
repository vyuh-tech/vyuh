import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A builder for root Widget of the application. Typically this would be a MaterialApp or CupertinoApp.
typedef AppBuilder = Widget Function(VyuhPlatform platform);

/// A builder for a widget that is shown when the app is loading.
typedef Loader = Widget Function();

/// A builder for a widget that is shown when a route is loading.
typedef RouteLoader = Widget Function([Uri? url, String? routeId]);

/// A builder for an image placeholder widget.
typedef ImagePlaceholderBuilder = Widget Function(
    {double? width, double? height});

/// A builder for a route error view widget.
typedef RouteErrorViewBuilder = Widget Function({
  required String title,
  String? retryLabel,
  VoidCallback? onRetry,
  dynamic error,
  StackTrace? stackTrace,
  String? subtitle,
});

/// A builder for an error view widget.
typedef ErrorViewBuilder = Widget Function({
  required String title,
  dynamic error,
  StackTrace? stackTrace,
  String? retryLabel,
  VoidCallback? onRetry,
  String? subtitle,
  bool showRestart,
});

/// A builder for platform specific widgets.
final class PlatformWidgetBuilder {
  /// A builder for the app widget. This becomes the root of the widget tree.
  /// Typically this would return a [MaterialApp] or [CupertinoApp].
  final AppBuilder appBuilder;

  /// A loader widget that is shown when the app is loading.
  final Loader appLoader;

  /// A loader widget that is shown when the content is loading.
  final Loader contentLoader;

  /// A loader widget that is shown when a route is loading.
  final RouteLoader routeLoader;

  /// A builder for the image placeholder widget.
  final ImagePlaceholderBuilder imagePlaceholder;

  /// A builder for the route error view widget.
  final RouteErrorViewBuilder routeErrorView;

  /// A builder for the error view widget.
  final ErrorViewBuilder errorView;

  /// Creates a new [PlatformWidgetBuilder] instance.
  PlatformWidgetBuilder({
    required this.appBuilder,
    required this.appLoader,
    required this.contentLoader,
    required this.routeLoader,
    required this.errorView,
    required this.routeErrorView,
    required this.imagePlaceholder,
  });

  /// Creates a copy of this [PlatformWidgetBuilder] but with the given fields
  PlatformWidgetBuilder copyWith({
    AppBuilder? appBuilder,
    Loader? appLoader,
    Loader? contentLoader,
    RouteLoader? routeLoader,
    ImagePlaceholderBuilder? imagePlaceholder,
    RouteErrorViewBuilder? routeErrorView,
    ErrorViewBuilder? errorView,
  }) {
    return PlatformWidgetBuilder(
        appBuilder: appBuilder ?? this.appBuilder,
        appLoader: appLoader ?? this.appLoader,
        contentLoader: contentLoader ?? this.contentLoader,
        routeLoader: routeLoader ?? this.routeLoader,
        errorView: errorView ?? this.errorView,
        routeErrorView: routeErrorView ?? this.routeErrorView,
        imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder);
  }
}
