import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// Builds document UI from a stream, including errors and completion.
///
/// A supplied [stream] is subscribed once. To support refresh/retry, use
/// [DocumentStreamBuilder.refreshable] with a factory returning a fresh stream.
class DocumentStreamBuilder<T> extends StatefulWidget {
  final Stream<T?>? stream;
  final Stream<T?> Function()? streamFactory;
  final Widget Function(BuildContext context, T document) buildContent;
  final bool allowRefresh;

  const DocumentStreamBuilder({
    super.key,
    required Stream<T?> this.stream,
    required this.buildContent,
    this.allowRefresh = true,
  }) : streamFactory = null;

  const DocumentStreamBuilder.refreshable({
    super.key,
    required Stream<T?> Function() this.streamFactory,
    required this.buildContent,
    this.allowRefresh = true,
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
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to load document',
              error: snapshot.error,
              stackTrace: snapshot.stackTrace,
              onRetry: canRefresh ? _refresh : null,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return vyuh.widgetBuilder.contentLoader(context);
          }
          final document = snapshot.data;
          if (document == null) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'No document data received',
              error: StateError('No document data received'),
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
