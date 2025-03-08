import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A widget that builds UI based on a future of [RouteBase] data.
///
/// This widget is suitable for fetching content from the CMS once, and then
/// rendering it in the app. If the app needs to fetch content multiple times,
/// use [RouteStreamBuilder] instead.
///
/// The widget requires a callback function to fetch the content. This function
/// will be called with the current context, and should return a future that
/// resolves with the content.
class RouteFutureBuilder extends StatefulWidget {
  /// The URL to fetch the content from. If this is null, the content will be
  /// fetched from the CMS using the [routeId].
  final Uri? url;

  /// The ID of the content item to fetch. If this is null, the content will be
  /// fetched from the CMS using the [url].
  final String? routeId;

  /// Whether the user should be allowed to refresh the content. Defaults to
  /// [true].
  final bool allowRefresh;

  /// The callback function to fetch the content. This function will be called
  /// with the current context, and should return a future that resolves with the
  /// content.
  final Future<RouteBase?> Function(BuildContext context,
      {String? path, String? routeId}) fetchRoute;

  /// The callback function to build the UI for the content. This function will
  /// be called with the current context, and the content item returned from the
  /// CMS.
  final Widget Function(BuildContext context, ContentItem content) buildContent;

  RouteFutureBuilder({
    super.key,
    this.url,
    this.routeId,
    required this.fetchRoute,
    required this.buildContent,
    this.allowRefresh = true,
  }) {
    debugAssertOneOfPathOrRouteId(url?.toString(), routeId);
  }

  @override
  State<RouteFutureBuilder> createState() => _RouteFutureBuilderState();
}

class _RouteFutureBuilderState extends State<RouteFutureBuilder> {
  final Observable<ObservableFuture<RouteBase?>?> _tracker = Observable(null);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  dispose() {
    final content = _tracker.value?.value;

    if (content != null) {
      Future.microtask(content.dispose);
    }

    super.dispose();
  }

  Future<RouteBase?> _refresh() {
    return runInAction(() {
      final future = _fetchRoute();
      _tracker.value = future;

      return future;
    });
  }

  ObservableFuture<RouteBase?> _fetchRoute() {
    return ObservableFuture(widget.fetchRoute(
      context,
      path: widget.url?.toString(),
      routeId: widget.routeId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return RouteBuilderProxy(
      onRefresh: _refresh,
      child: Observer(
        builder: (context) {
          final status = _tracker.value?.status;
          final isUrl = widget.url != null;
          final errorMsg =
              'Failed to load ${isUrl ? 'url' : 'routeId'}: ${isUrl ? widget.url.toString() : widget.routeId}';

          switch (status) {
            case null || FutureStatus.pending:
              return VyuhBinding.instance.widgetBuilder.routeLoader(context);

            case FutureStatus.fulfilled:
              final route = _tracker.value?.value;

              if (route == null) {
                final exception = Exception(errorMsg);

                VyuhBinding.instance.telemetry.reportError(exception);

                return VyuhBinding.instance.widgetBuilder.routeErrorView(
                  context,
                  title: 'Failed to load route from CMS',
                  error: exception,
                  onRetry: _refresh,
                );
              }

              return widget.allowRefresh
                  ? RouteContentWithRefresh(
                      child: widget.buildContent(context, route),
                    )
                  : widget.buildContent(context, route);

            case FutureStatus.rejected:
              VyuhBinding.instance.telemetry.reportError(_tracker.value?.error);

              return VyuhBinding.instance.widgetBuilder.routeErrorView(
                context,
                title: errorMsg,
                error: _tracker.value?.error,
                onRetry: _refresh,
              );
          }
        },
      ),
    );
  }
}
