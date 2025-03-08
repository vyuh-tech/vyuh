import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A widget that builds UI based on a stream of [RouteBase] data.
///
/// This widget is similar to [RouteFutureBuilder] but works with streams instead of futures,
/// making it suitable for live data updates from the CMS.
class RouteStreamBuilder extends StatefulWidget {
  /// The URL to fetch the route for.
  final Uri? url;

  /// The route ID to fetch the route for.
  final String? routeId;

  /// A function that returns a stream of [RouteBase] data.
  final Stream<RouteBase?> Function(BuildContext context,
      {String? path, String? routeId, bool includeDrafts}) fetchRoute;

  /// A function that builds the UI for the content.
  final Widget Function(BuildContext context, ContentItem content) buildContent;

  /// Whether to include draft content.
  final bool includeDrafts;

  /// Whether to allow refreshing the route, with the overlay Refresh button.
  final bool allowRefresh;

  /// Creates a [RouteStreamBuilder].
  ///
  /// Either [url] or [routeId] must be provided, but not both.
  RouteStreamBuilder({
    super.key,
    this.url,
    this.routeId,
    required this.fetchRoute,
    required this.buildContent,
    this.includeDrafts = false,
    this.allowRefresh = true,
  }) {
    debugAssertOneOfPathOrRouteId(url?.toString(), routeId);
  }

  @override
  State<RouteStreamBuilder> createState() => _RouteStreamBuilderState();
}

class _RouteStreamBuilderState extends State<RouteStreamBuilder> {
  /// The observable stream of route data.
  ObservableStream<RouteBase?>? _streamTracker;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  @override
  void didUpdateWidget(RouteStreamBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-subscribe if the URL or route ID changes
    if (oldWidget.url != widget.url ||
        oldWidget.routeId != widget.routeId ||
        oldWidget.includeDrafts != widget.includeDrafts) {
      _disposeCurrentRoute();
      _initStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle the case where stream initialization failed
    if (_streamTracker == null) {
      final errorMsg = 'Failed to initialize stream for route';
      final exception = Exception(errorMsg);

      return VyuhBinding.instance.widgetBuilder.routeErrorView(
        context,
        title: errorMsg,
        error: exception,
        onRetry: () {
          _disposeCurrentRoute();
          _initStream();
        },
      );
    }

    return RouteBuilderProxy(
      onRefresh: _refresh,
      child: Observer(
        builder: (context) {
          final streamStatus = _streamTracker!.status;
          final route = _streamTracker!.value;
          final error = _streamTracker!.error;
          final isUrl = widget.url != null;
          final errorMsg =
              'Failed to load ${isUrl ? 'url' : 'routeId'}: ${isUrl ? widget.url.toString() : widget.routeId}';

          // Handle error state first
          if (error != null) {
            VyuhBinding.instance.telemetry.reportError(error);

            return VyuhBinding.instance.widgetBuilder.routeErrorView(
              context,
              title: errorMsg,
              error: error,
              onRetry: () {
                _disposeCurrentRoute();
                _initStream();
              },
            );
          }

          // Then handle different stream statuses
          switch (streamStatus) {
            case StreamStatus.waiting:
              return VyuhBinding.instance.widgetBuilder.routeLoader(context);

            case StreamStatus.active:
              if (route == null) {
                final exception = Exception(errorMsg);
                VyuhBinding.instance.telemetry.reportError(exception);

                return VyuhBinding.instance.widgetBuilder.routeErrorView(
                  context,
                  title: 'Failed to load route from CMS',
                  error: exception,
                  onRetry: () {
                    _disposeCurrentRoute();
                    _initStream();
                  },
                );
              }

              return widget.allowRefresh
                  ? RouteContentWithRefresh(
                      child: widget.buildContent(context, route),
                    )
                  : widget.buildContent(context, route);

            case StreamStatus.done:
              if (route != null) {
                return widget.allowRefresh
                    ? RouteContentWithRefresh(
                        child: widget.buildContent(context, route),
                      )
                    : widget.buildContent(context, route);
              }

              // If we're done but have no data, show an error
              final exception = Exception('No route data received');
              VyuhBinding.instance.telemetry.reportError(exception);

              return VyuhBinding.instance.widgetBuilder.routeErrorView(
                context,
                title: errorMsg,
                error: exception,
                onRetry: () {
                  _disposeCurrentRoute();
                  _initStream();
                },
              );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _disposeCurrentRoute();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (!mounted) return;

    setState(() {
      _disposeCurrentRoute();
    });

    // Allow the UI to update and show loading state
    await Future.microtask(() {});

    if (!mounted) return;

    setState(() {
      _initStream();
    });
  }

  /// Disposes the current route and stream tracker.
  void _disposeCurrentRoute() {
    if (_streamTracker == null) return;

    // Dispose the current route if it exists
    final route = _streamTracker!.value;
    if (route != null) {
      Future.microtask(route.dispose);
    }

    // Explicitly close the ObservableStream to prevent memory leaks
    _streamTracker!.close();
    _streamTracker = null;
  }

  /// Initializes the observable stream.
  void _initStream() {
    try {
      final stream = widget.fetchRoute(
        context,
        path: widget.url?.toString(),
        routeId: widget.routeId,
        includeDrafts: widget.includeDrafts,
      );

      if (context.mounted) {
        _streamTracker = ObservableStream(stream);
      }
    } catch (e, stack) {
      // Handle initialization errors
      if (context.mounted) {
        VyuhBinding.instance.telemetry.reportError(e, stackTrace: stack);
        // We'll let the Observer handle the error state
        _streamTracker = ObservableStream(Stream.error(e));
      }
    }
  }
}
