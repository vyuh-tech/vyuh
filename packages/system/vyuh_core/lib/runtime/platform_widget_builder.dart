import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

typedef AppBuilder = Widget Function(VyuhPlatform platform);
typedef Loader = Widget Function();
typedef RouteLoader = Widget Function([Uri? url, String? routeId]);
typedef ImagePlaceholderBuilder = Widget Function(
    {double? width, double? height});
typedef RouteErrorViewBuilder = Widget Function({
  required String path,
  required String title,
  String? retryLabel,
  VoidCallback? onRetry,
  dynamic error,
  String? subtitle,
});
typedef ErrorViewBuilder = Widget Function({
  required String title,
  dynamic error,
  String? retryLabel,
  VoidCallback? onRetry,
  String? subtitle,
  bool canGoHome,
});

final class PlatformWidgetBuilder {
  final AppBuilder appBuilder;
  final Loader appLoader;
  final Loader contentLoader;
  final RouteLoader routeLoader;
  final ImagePlaceholderBuilder imagePlaceholder;
  final RouteErrorViewBuilder routeErrorView;
  final ErrorViewBuilder errorView;

  PlatformWidgetBuilder({
    required this.appBuilder,
    required this.appLoader,
    required this.contentLoader,
    required this.routeLoader,
    required this.errorView,
    required this.routeErrorView,
    required this.imagePlaceholder,
  });

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
