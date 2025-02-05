library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'document.dart';
import 'vyuh_content_binding.dart';

/// A widget that renders a [Document] from the CMS.
///
/// It can display the document in a variety of ways, from a simple text
/// representation to a fully custom layout.
///
/// If the document is not found, the widget will display a "Not Found" message.
typedef DocumentBuilder<T extends ContentItem> = Widget Function(
    BuildContext, T);

/// A widget that renders a list of [Document]s from the CMS.
typedef DocumentListBuilder<T extends ContentItem> = Widget Function(
    BuildContext, List<T>);

/// A versatile content widget that handles both single and list content items.
/// It interacts with the [ContentPlugin] (either directly or via [VyuhBinding]) to fetch content from the CMS.
class VyuhContentWidget<T extends ContentItem> extends StatefulWidget {
  /// The query to fetch content from the CMS.
  final String query;

  /// The query parameters to pass to the CMS.
  final Map<String, String>? queryParams;

  /// The converter to use when converting the raw JSON data from the CMS into a [ContentItem].
  final FromJsonConverter<T> fromJson;

  /// The builder to use when the widget is displaying a single content item.
  final DocumentBuilder<T>? builder;

  /// The builder to use when the widget is displaying a list of content items.
  final DocumentListBuilder<T>? listBuilder;

  /// Creates a [VyuhContentWidget] with the given parameters.
  const VyuhContentWidget({
    super.key,
    required this.query,
    required this.fromJson,
    this.queryParams,
    this.builder,
    this.listBuilder,
  }) : assert(
          (builder != null) ^ (listBuilder != null),
          'Must provide exactly one of builder or listBuilder',
        );

  /// Creates a [VyuhContentWidget] that loads a single [Document] from the CMS.
  /// If a query is not provided, it will default to a Sanity GROQ query.
  /// This assumes that you have setup a SanityContentProvider for the [ContentPlugin].
  factory VyuhContentWidget.fromDocument({
    Key? key,
    required String identifier,
    String? query,
    Map<String, String>? queryParams,
    Widget Function(BuildContext, Document)? builder,
  }) =>
      VyuhContentWidget<Document>(
        key: key,
        query: query ??
            '*[_type == "vyuh.document" && identifier.current == \$identifier][0]',
        queryParams: queryParams ??
            {
              'identifier': identifier,
            },
        fromJson: Document.fromJson,
        builder: builder ?? _defaultDocumentBuilder,
      ) as VyuhContentWidget<T>;

  static Widget _defaultDocumentBuilder(
      BuildContext context, Document content) {
    return VyuhContentBinding.content.buildContent(context, content);
  }

  @override
  State<VyuhContentWidget<T>> createState() => _VyuhContentWidgetState<T>();
}

class _VyuhContentWidgetState<T extends ContentItem>
    extends State<VyuhContentWidget<T>> {
  /// The future that resolves when the content is loaded.
  Future<dynamic>? _contentFuture;

  @override
  void initState() {
    super.initState();

    assert(VyuhBinding.instance.initInvoked,
        'You must call VyuhContentBinding.init() before using this widget.');

    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return VyuhContentBinding.widgetBuilder.contentLoader(context);
        }

        if (snapshot.hasError) {
          return VyuhContentBinding.widgetBuilder.errorView(
            context,
            title: 'Failed to load content',
            subtitle: '''
Query: "${widget.query}"

Params: ${widget.queryParams}
''',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
            onRetry: () {
              setState(() => _fetchContent());
            },
            showRestart: false,
          );
        }

        return _buildContent(context, snapshot.data);
      },
    );
  }

  @override
  void didUpdateWidget(covariant VyuhContentWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.queryParams != widget.queryParams) {
      _fetchContent();
      return;
    }
  }

  /// Fetches the content from the CMS.
  void _fetchContent() {
    final plugin = VyuhContentBinding.content;

    // Wait for the environment to be ready before fetching content
    _contentFuture = VyuhBinding.instance.widgetReady.then((_) {
      return widget.builder != null
          ? plugin.provider.fetchSingle<T>(
              widget.query,
              fromJson: widget.fromJson,
              queryParams: widget.queryParams,
            )
          : plugin.provider.fetchMultiple<T>(
              widget.query,
              fromJson: widget.fromJson,
              queryParams: widget.queryParams,
            );
    });
  }

  /// Builds the widget based on the loaded content.
  Widget _buildContent(BuildContext context, dynamic data) {
    if (widget.builder != null) {
      final content = data as T?;
      return content != null
          ? _ContentViewWithRefresh(
              onRefresh: () => setState(() {
                _fetchContent();
              }),
              child: widget.builder!(context, content),
            )
          : VyuhContentBinding.widgetBuilder.errorView(
              context,
              title: 'No Content found',
              subtitle: '''
Query: ${widget.query}

Params: ${widget.queryParams}
''',
            );
    } else {
      final contentList = data as List<T>?;
      return contentList != null
          ? _ContentViewWithRefresh(
              onRefresh: () => setState(() {
                _fetchContent();
              }),
              child: widget.listBuilder!(context, contentList),
            )
          : VyuhContentBinding.widgetBuilder.errorView(
              context,
              title: 'No Content found',
              subtitle: 'Query: ${widget.query}',
            );
    }
  }
}

class _ContentViewWithRefresh extends StatelessWidget {
  final Widget child;

  final void Function()? onRefresh;

  const _ContentViewWithRefresh({required this.child, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: child),
        if (kDebugMode && onRefresh != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton(
              mini: true,
              onPressed: onRefresh,
              child: const Icon(Icons.refresh),
            ),
          ),
      ],
    );
  }
}
