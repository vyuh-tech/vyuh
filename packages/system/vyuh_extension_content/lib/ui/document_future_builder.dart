import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'document_failure.dart';

/// A widget that builds UI based on a future of document data.
///
/// This widget is suitable for fetching document content from the CMS once, and then
/// rendering it in the app. If the app needs to fetch content multiple times,
/// use [DocumentStreamBuilder] instead.
class DocumentFutureBuilder<T> extends StatefulWidget {
  /// The future that resolves with the document data.
  final Future<T?> Function() future;

  /// A function that builds the UI for the content.
  final Widget Function(BuildContext context, T document) buildContent;

  /// Whether to allow refreshing the document, with the overlay Refresh button.
  final bool allowRefresh;

  /// Whether this document is a whole route. A route that fails shows a
  /// full page with Back and Go home; other content fails inline.
  final bool isRoute;

  /// The location being shown, included in failure reports.
  final Uri? location;

  /// Identifies the document being fetched. When set, the builder refetches
  /// only when this value changes, so a parent passing a new [future]
  /// closure on every build doesn't trigger a refetch. When null, a new
  /// [future] function does.
  final Object? requestKey;

  /// Creates a [DocumentFutureBuilder].
  const DocumentFutureBuilder({
    super.key,
    required this.future,
    required this.buildContent,
    this.allowRefresh = true,
    this.isRoute = false,
    this.location,
    this.requestKey,
  });

  @override
  State<DocumentFutureBuilder<T>> createState() =>
      _DocumentFutureBuilderState<T>();
}

class _DocumentFutureBuilderState<T> extends State<DocumentFutureBuilder<T>> {
  final Observable<ObservableFuture<T?>?> _tracker = Observable(null);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(DocumentFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final keyed = oldWidget.requestKey != null || widget.requestKey != null;
    final changed = keyed
        ? oldWidget.requestKey != widget.requestKey
        : oldWidget.future != widget.future;
    if (changed) _refresh();
  }

  Future<T?> _refresh() {
    return runInAction(() {
      final future = _fetchDocument();
      _tracker.value = future;

      return future;
    });
  }

  ObservableFuture<T?> _fetchDocument() {
    final isRoute = widget.isRoute;
    // Inline failures are reported here, once per fetch. Route failures
    // report themselves through RouteFailureView.
    return ObservableFuture(
      Future<T?>.sync(widget.future).then(
        (document) {
          if (document == null && !isRoute) {
            reportFailure(
              documentFailure(isRoute: false, location: widget.location),
              emitRouteEvent: false,
            );
          }
          return document;
        },
        onError: (Object error, StackTrace stack) {
          if (!isRoute) {
            reportFailure(
              documentFailure(
                isRoute: false,
                location: widget.location,
                error: error,
                stackTrace: stack,
              ),
              emitRouteEvent: false,
            );
          }
          Error.throwWithStackTrace(error, stack);
        },
      ),
    );
  }

  /// One failure object per fetch, so route failures report exactly once.
  VyuhFailure? _failure;
  ObservableFuture<T?>? _failureSource;

  VyuhFailure _failureFor(ObservableFuture<T?> future) {
    if (!identical(_failureSource, future)) {
      _failureSource = future;
      _failure = documentFailure(
        isRoute: widget.isRoute,
        location: widget.location,
        error: future.status == FutureStatus.rejected ? future.error : null,
        stackTrace: null,
      );
    }
    return _failure!;
  }

  @override
  Widget build(BuildContext context) {
    return RouteBuilderProxy(
      onRefresh: _refresh,
      child: Observer(
        builder: (context) {
          final status = _tracker.value?.status;

          // Handle different future statuses
          switch (status) {
            case null || FutureStatus.pending:
              return widget.isRoute
                  ? vyuh.widgetBuilder.routeLoader(context, widget.location)
                  : vyuh.widgetBuilder.contentLoader(context);

            case FutureStatus.fulfilled:
              final document = _tracker.value?.value;

              if (document == null) {
                return buildDocumentFailure(
                  context,
                  failure: _failureFor(_tracker.value!),
                  isRoute: widget.isRoute,
                  onRetry: _refresh,
                );
              }

              return widget.allowRefresh
                  ? RouteContentWithRefresh(
                      child: widget.buildContent(context, document),
                    )
                  : widget.buildContent(context, document);

            case FutureStatus.rejected:
              return buildDocumentFailure(
                context,
                failure: _failureFor(_tracker.value!),
                isRoute: widget.isRoute,
                onRetry: _refresh,
              );
          }
        },
      ),
    );
  }
}
