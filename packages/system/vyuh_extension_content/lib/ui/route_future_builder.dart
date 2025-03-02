import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class RouteFutureBuilder extends StatefulWidget {
  final Uri? url;
  final String? routeId;

  final Future<RouteBase?> Function(BuildContext context,
      {String? path, String? routeId}) fetchRoute;
  final Widget Function(BuildContext context, ContentItem content) buildContent;

  RouteFutureBuilder({
    super.key,
    this.url,
    this.routeId,
    required this.fetchRoute,
    required this.buildContent,
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

              return _ContentWithRefresh(
                onRefresh: _refresh,
                child: widget.buildContent(context, route),
              );

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

class _ContentWithRefresh extends StatelessWidget {
  final Widget child;
  final void Function() onRefresh;

  const _ContentWithRefresh({required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
              left: 5,
              bottom: MediaQuery.of(context).viewPadding.bottom,
              child: IconButton.filledTonal(
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh,
              ))
        ],
      ),
    );
  }
}
