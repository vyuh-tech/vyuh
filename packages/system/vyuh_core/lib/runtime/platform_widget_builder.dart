import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
typedef AppBuilder = Widget Function(VyuhPlatform platform);

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

/// A builder for platform-specific widgets used throughout the Vyuh application.
/// 
/// This class provides a centralized way to customize the appearance and behavior
/// of common UI components in a Vyuh application. It includes builders for:
/// - App root widget ([appBuilder])
/// - Loading indicators ([appLoader], [contentLoader], [routeLoader])
/// - Error views ([errorView], [routeErrorView])
/// - Image placeholders ([imagePlaceholder])
/// 
/// Use [copyWith] to create a modified version of an existing builder:
/// ```dart
/// final customBuilder = defaultPlatformWidgetBuilder.copyWith(
///   appLoader: (context) => MyCustomLoader(),
///   errorView: (context, {title, error}) => MyCustomErrorView(title: title),
/// );
/// ```
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
