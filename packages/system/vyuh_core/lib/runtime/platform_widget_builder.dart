import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'platform/powered_by_widget.dart';

part 'platform/default_route_loader.dart';
part 'platform/error_view.dart';
part 'platform/unknown_content_view.dart';

/// A builder for root Widget of the application. Typically this would be a MaterialApp or CupertinoApp.
///
/// This builder is called once during app initialization to create the root widget.
/// The [platform] parameter provides access to the Vyuh platform instance.
///
/// Example:
/// ```dart
/// AppBuilder builder = (platform) => MaterialApp(
///   home: MyHomePage(),
///   theme: platform.theme,
/// );
/// ```
typedef AppBuilder = Widget Function(
    BuildContext context, VyuhPlatform platform);

/// A builder for a widget that is shown when the app is loading.
///
/// This builder is called to create a loading indicator during app initialization
/// or when loading content. The [context] parameter provides access to the
/// current build context.
///
/// Example:
/// ```dart
/// Loader loader = (context) => const Center(
///   child: CircularProgressIndicator(),
/// );
/// ```
typedef Loader = Widget Function(BuildContext context);

/// A builder for a widget that is shown when a route is loading.
///
/// This builder is called when navigating between routes. The [url] parameter
/// contains the destination URL, and [routeId] contains the unique identifier
/// for the route.
///
/// Example:
/// ```dart
/// RouteLoader loader = (context, url, routeId) => Center(
///   child: Text('Loading $url...'),
/// );
/// ```
typedef RouteLoader = Widget Function(BuildContext context,
    [Uri? url, String? routeId]);

/// A builder for an image placeholder widget.
///
/// This builder is called to create a placeholder widget while an image is loading.
/// The [width] and [height] parameters specify the desired dimensions of the
/// placeholder.
///
/// Example:
/// ```dart
/// ImagePlaceholderBuilder builder = (context, {width, height}) => Container(
///   width: width,
///   height: height,
///   color: Colors.grey[300],
/// );
/// ```
typedef ImagePlaceholderBuilder = Widget Function(BuildContext context,
    {double? width, double? height});

/// A builder for a route error view widget.
///
/// This builder is called when an error occurs during route navigation.
/// It provides detailed error information and optional retry functionality.
///
/// Example:
/// ```dart
/// RouteErrorViewBuilder builder = (
///   context, {
///   required title,
///   retryLabel,
///   onRetry,
///   error,
///   stackTrace,
///   subtitle,
/// }) => ErrorView(
///   title: title,
///   subtitle: subtitle,
///   onRetry: onRetry,
/// );
/// ```
typedef RouteErrorViewBuilder = Widget Function(
  BuildContext context, {
  required String title,
  String? retryLabel,
  VoidCallback? onRetry,
  dynamic error,
  StackTrace? stackTrace,
  String? subtitle,
});

/// A builder for an error view widget.
///
/// This builder is called when an error occurs in the application.
/// It provides detailed error information and optional retry/restart functionality.
///
/// Example:
/// ```dart
/// ErrorViewBuilder builder = (
///   context, {
///   required title,
///   error,
///   stackTrace,
///   retryLabel,
///   onRetry,
///   subtitle,
///   showRestart,
/// }) => ErrorView(
///   title: title,
///   subtitle: subtitle,
///   onRetry: onRetry,
///   showRestart: showRestart,
/// );
/// ```
typedef ErrorViewBuilder = Widget Function(
  BuildContext context, {
  required String title,
  dynamic error,
  StackTrace? stackTrace,
  String? retryLabel,
  VoidCallback? onRetry,
  String? subtitle,
  bool showRestart,
});

/// A builder for unknown content failures.
///
/// This builder is called when content-related operations fail due to missing
/// registrations, layouts, modifiers, actions, or conditions. It provides a
/// unified way to handle all content failures across the framework.
///
/// Example:
/// ```dart
/// UnknownContentBuilder builder = (context, failure) {
///   switch (failure) {
///     case ContentItemFailure():
///       return ContentErrorWidget(failure: failure);
///     case LayoutFailure():
///       return LayoutErrorWidget(failure: failure);
///     // ... handle other failure types
///   }
/// };
/// ```
typedef UnknownContentBuilder = Widget Function(
  BuildContext context,
  ContentFailure failure,
);

/// A builder for platform-specific widgets used throughout the Vyuh application.
///
/// This class provides a centralized way to customize the appearance and behavior
/// of common UI components in a Vyuh application. It includes builders for:
/// - App root widget ([appBuilder])
/// - Loading indicators ([appLoader], [contentLoader], [routeLoader])
/// - Error views ([errorView], [routeErrorView])
/// - Unknown content handling ([unknown])
/// - Image placeholders ([imagePlaceholder])
///
/// Use [copyWith] to create a modified version of an existing builder:
/// ```dart
/// final customBuilder = defaultPlatformWidgetBuilder.copyWith(
///   appLoader: (context) => MyCustomLoader(),
///   errorView: (context, {title, error}) => MyCustomErrorView(title: title),
///   unknown: (context, failure) => MyCustomUnknownWidget(failure: failure),
/// );
/// ```
class PlatformWidgetBuilder {
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

  /// A builder for unknown content failures.
  final UnknownContentBuilder unknown;

  /// Creates a new [PlatformWidgetBuilder] instance.
  PlatformWidgetBuilder({
    required this.appBuilder,
    required this.appLoader,
    required this.contentLoader,
    required this.routeLoader,
    required this.errorView,
    required this.routeErrorView,
    required this.imagePlaceholder,
    required this.unknown,
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
    UnknownContentBuilder? unknown,
  }) {
    return PlatformWidgetBuilder(
        appBuilder: appBuilder ?? this.appBuilder,
        appLoader: appLoader ?? this.appLoader,
        contentLoader: contentLoader ?? this.contentLoader,
        routeLoader: routeLoader ?? this.routeLoader,
        errorView: errorView ?? this.errorView,
        routeErrorView: routeErrorView ?? this.routeErrorView,
        imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
        unknown: unknown ?? this.unknown);
  }

  static final system = PlatformWidgetBuilder(
      appBuilder: (_, platform) {
        return MaterialApp.router(
          theme: ThemeData.light(useMaterial3: true),
          routerConfig: platform.router.instance,
        );
      },
      appLoader: (_) => const _DefaultRouteLoader(
            delay: Duration(milliseconds: 0),
            backgroundColor: Colors.black,
            progressColor: Colors.white,
          ),
      routeLoader: (_, [__, ___]) => const _DefaultRouteLoader(
            delay: Duration(milliseconds: 0),
            backgroundColor: Colors.white30,
          ),
      contentLoader: (_) => const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(child: CircularProgressIndicator()),
                  PoweredByWidget(),
                ],
              ),
            ),
          ),
      imagePlaceholder: (_, {width, height}) => Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(color: Colors.black12),
            padding: const EdgeInsets.all(20.0),
            child: const Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey,
              size: 32,
            ),
          ),
      errorView: (
        _, {
        required title,
        retryLabel,
        onRetry,
        subtitle,
        error,
        stackTrace,
        showRestart = true,
      }) =>
          Center(
            child: _ErrorView(
              title: title,
              subtitle: subtitle,
              error: error,
              stackTrace: stackTrace,
              retryLabel: retryLabel,
              onRetry: onRetry,
            ),
          ),
      routeErrorView: (
        _, {
        required title,
        onRetry,
        retryLabel,
        subtitle,
        error,
        stackTrace,
      }) =>
          _ErrorViewScaffold(
            title: title,
            subtitle: subtitle,
            error: error,
            stackTrace: stackTrace,
            onRetry: onRetry,
            retryLabel: retryLabel,
            showRestart: true,
          ),
      unknown: (context, failure) => _UnknownContentView(failure: failure));
}
