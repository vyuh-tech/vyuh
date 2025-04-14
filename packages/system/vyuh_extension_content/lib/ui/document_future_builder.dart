import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

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

  /// Creates a [DocumentFutureBuilder].
  const DocumentFutureBuilder({
    super.key,
    required this.future,
    required this.buildContent,
    this.allowRefresh = true,
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
  dispose() {
    super.dispose();
  }

  Future<T?> _refresh() {
    return runInAction(() {
      final future = _fetchDocument();
      _tracker.value = future;

      return future;
    });
  }

  ObservableFuture<T?> _fetchDocument() {
    return ObservableFuture(widget.future());
  }

  @override
  Widget build(BuildContext context) {
    return RouteBuilderProxy(
      onRefresh: _refresh,
      child: Observer(
        builder: (context) {
          final status = _tracker.value?.status;
          final errorMsg = 'Failed to load document';

          // Handle different future statuses
          switch (status) {
            case null || FutureStatus.pending:
              return VyuhBinding.instance.widgetBuilder.contentLoader(context);

            case FutureStatus.fulfilled:
              final document = _tracker.value?.value;

              if (document == null) {
                final exception = Exception(errorMsg);

                VyuhBinding.instance.telemetry.reportError(exception);

                return VyuhBinding.instance.widgetBuilder.errorView(
                  context,
                  title: 'Failed to load document from CMS',
                  error: exception,
                  onRetry: _refresh,
                );
              }

              return widget.allowRefresh
                  ? RouteContentWithRefresh(
                      child: widget.buildContent(context, document),
                    )
                  : widget.buildContent(context, document);

            case FutureStatus.rejected:
              final error = _tracker.value?.error;
              VyuhBinding.instance.telemetry.reportError(error);

              return VyuhBinding.instance.widgetBuilder.errorView(
                context,
                title: errorMsg,
                error: error,
                onRetry: _refresh,
              );
          }
        },
      ),
    );
  }
}
