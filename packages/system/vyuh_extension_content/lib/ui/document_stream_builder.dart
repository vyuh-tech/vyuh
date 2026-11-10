import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'document_failure.dart';

/// Builds document UI from a stream, including errors and completion.
///
/// A supplied [stream] is subscribed once. To support refresh/retry, use
/// [DocumentStreamBuilder.refreshable] with a factory returning a fresh stream.
class DocumentStreamBuilder<T> extends StatefulWidget {
  final Stream<T?>? stream;
  final Stream<T?> Function()? streamFactory;
  final Widget Function(BuildContext context, T document) buildContent;
  final bool allowRefresh;

  /// Whether this document is a whole route. A route that fails shows a
  /// full page with Back and Go home; other content fails inline.
  final bool isRoute;

  /// The location being shown, included in failure reports.
  final Uri? location;

  const DocumentStreamBuilder({
    super.key,
    required Stream<T?> this.stream,
    required this.buildContent,
    this.allowRefresh = true,
    this.isRoute = false,
    this.location,
  }) : streamFactory = null;

  const DocumentStreamBuilder.refreshable({
    super.key,
    required Stream<T?> Function() this.streamFactory,
    required this.buildContent,
    this.allowRefresh = true,
    this.isRoute = false,
    this.location,
  }) : stream = null;

  @override
  State<DocumentStreamBuilder<T>> createState() =>
      _DocumentStreamBuilderState<T>();
}

class _DocumentStreamBuilderState<T> extends State<DocumentStreamBuilder<T>> {
  Stream<T?>? _stream;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  @override
  void didUpdateWidget(DocumentStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream ||
        oldWidget.streamFactory != widget.streamFactory) {
      _initStream();
    }
  }

  void _initStream() {
    _generation++;
    try {
      _stream = widget.streamFactory?.call() ?? widget.stream;
    } catch (error, stack) {
      _stream = Stream<T?>.error(error, stack);
    }
  }

  /// The failure for the current error, created once per distinct error so
  /// it is reported exactly once.
  VyuhFailure? _failure;
  Object? _failureSource;

  VyuhFailure _failureFor(Object? error, StackTrace? stack) {
    final source = error ?? _missingDocument;
    if (!identical(_failureSource, source)) {
      _failureSource = source;
      _failure = documentFailure(
        isRoute: widget.isRoute,
        location: widget.location,
        error: error,
        stackTrace: stack,
      );
      if (!widget.isRoute) {
        reportFailure(_failure!, emitRouteEvent: false);
      }
    }
    return _failure!;
  }

  static final _missingDocument = Object();

  Future<void> _refresh() async {
    // A single-subscription stream cannot be reused after cancellation.
    if (!mounted || widget.streamFactory == null) return;
    setState(_initStream);
  }

  @override
  Widget build(BuildContext context) {
    final canRefresh = widget.allowRefresh && widget.streamFactory != null;
    return RouteBuilderProxy(
      onRefresh: _refresh,
      child: StreamBuilder<T?>(
        // Discard the previous document/error when switching request identity.
        key: ValueKey(_generation),
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return buildDocumentFailure(
              context,
              failure: _failureFor(snapshot.error, snapshot.stackTrace),
              isRoute: widget.isRoute,
              onRetry: canRefresh ? _refresh : null,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return widget.isRoute
                ? vyuh.widgetBuilder.routeLoader(context, widget.location)
                : vyuh.widgetBuilder.contentLoader(context);
          }
          final document = snapshot.data;
          if (document == null) {
            return buildDocumentFailure(
              context,
              failure: _failureFor(null, null),
              isRoute: widget.isRoute,
              onRetry: canRefresh ? _refresh : null,
            );
          }
          final content = widget.buildContent(context, document);
          return canRefresh ? RouteContentWithRefresh(child: content) : content;
        },
      ),
    );
  }
}
