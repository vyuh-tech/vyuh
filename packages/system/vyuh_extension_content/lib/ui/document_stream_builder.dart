import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A widget that builds UI based on a stream of document data.
///
/// This widget is similar to [DocumentFutureBuilder] but works with streams instead of futures,
/// making it suitable for live data updates from the CMS.
class DocumentStreamBuilder<T> extends StatefulWidget {
  /// The stream of document data.
  final Stream<T?> stream;

  /// A function that builds the UI for the content.
  final Widget Function(BuildContext context, T document) buildContent;

  /// Whether to allow refreshing the document, with the overlay Refresh button.
  final bool allowRefresh;

  /// Creates a [DocumentStreamBuilder].
  const DocumentStreamBuilder({
    super.key,
    required this.stream,
    required this.buildContent,
    this.allowRefresh = true,
  });

  @override
  State<DocumentStreamBuilder<T>> createState() =>
      _DocumentStreamBuilderState<T>();
}

class _DocumentStreamBuilderState<T> extends State<DocumentStreamBuilder<T>> {
  /// The observable stream of document data.
  ObservableStream<T?>? _streamTracker;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  @override
  void didUpdateWidget(DocumentStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-subscribe if the stream changes
    if (oldWidget.stream != widget.stream) {
      _disposeCurrentDocument();
      _initStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RouteBuilderProxy(
      onRefresh: () async {
        _disposeCurrentDocument();
        _initStream();
      },
      child: Observer(
        builder: (context) {
          final streamStatus = _streamTracker?.status;
          final document = _streamTracker?.value;
          final errorMsg = 'Failed to load document with query';

          // Then handle different stream statuses
          switch (streamStatus) {
            case null || StreamStatus.waiting:
              return VyuhBinding.instance.widgetBuilder.contentLoader(context);

            case StreamStatus.active:
              if (document == null) {
                final exception = Exception(errorMsg);
                VyuhBinding.instance.telemetry.reportError(exception);

                return VyuhBinding.instance.widgetBuilder.errorView(
                  context,
                  title: 'Failed to load document from CMS',
                  error: exception,
                  onRetry: () {
                    _disposeCurrentDocument();
                    _initStream();
                  },
                );
              }

              return widget.allowRefresh
                  ? RouteContentWithRefresh(
                      child: widget.buildContent(context, document),
                    )
                  : widget.buildContent(context, document);

            case StreamStatus.done:
              if (document != null) {
                return widget.allowRefresh
                    ? RouteContentWithRefresh(
                        child: widget.buildContent(context, document),
                      )
                    : widget.buildContent(context, document);
              }

              // If we're done but have no data, show an error
              final exception = Exception('No document data received');
              VyuhBinding.instance.telemetry.reportError(exception);

              return VyuhBinding.instance.widgetBuilder.errorView(
                context,
                title: errorMsg,
                error: exception,
                onRetry: () {
                  _disposeCurrentDocument();
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
    _disposeCurrentDocument();
    super.dispose();
  }

  /// Disposes the current document stream.
  void _disposeCurrentDocument() {
    _streamTracker?.close();
    _streamTracker = null;
  }

  /// Initializes the observable stream.
  void _initStream() {
    try {
      if (context.mounted) {
        _streamTracker = ObservableStream(widget.stream);
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
