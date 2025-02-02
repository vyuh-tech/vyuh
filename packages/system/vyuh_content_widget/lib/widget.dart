library;

import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'document.dart';
import 'vyuh_content_binding.dart';

typedef DocumentBuilder<T extends ContentItem> = Widget Function(
    BuildContext, T);
typedef DocumentListBuilder<T extends ContentItem> = Widget Function(
    BuildContext, List<T>);

/// A versatile content widget that handles both single and list content items.
/// It interacts with the [ContentPlugin] (either directly or via [VyuhBinding]) to fetch content from the CMS.
class VyuhContentWidget<T extends ContentItem> extends StatefulWidget {
  final String query;
  final Map<String, String>? queryParams;
  final FromJsonConverter<T> fromJson;

  final DocumentBuilder<T>? builder;
  final DocumentListBuilder<T>? listBuilder;

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
  VyuhContentWidget.fromDocument({
    Key? key,
    required String identifier,
    String? query,
    Map<String, String>? queryParams,
    Widget Function(BuildContext, Document)? builder,
  }) : this(
          key: key,
          query: query ??
              '*[_type == "vyuh.document" && identifier.current == \$identifier][0]',
          queryParams: queryParams ??
              {
                'identifier': identifier,
              },
          fromJson: Document.fromJson as FromJsonConverter<T>,
          builder: (builder ?? _defaultDocumentBuilder) as DocumentBuilder<T>,
        );

  static Widget _defaultDocumentBuilder(
      BuildContext context, ContentItem content) {
    return VyuhContentBinding.content.buildContent(context, content);
  }

  @override
  State<VyuhContentWidget<T>> createState() => _VyuhContentWidgetState<T>();
}

class _VyuhContentWidgetState<T extends ContentItem>
    extends State<VyuhContentWidget<T>> {
  Future<dynamic>? _contentFuture;

  @override
  void initState() {
    super.initState();

    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return VyuhBinding.instance.widgetBuilder.contentLoader(context);
        }

        if (snapshot.hasError) {
          return VyuhBinding.instance.widgetBuilder.errorView(
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

  void _fetchContent() {
    final plugin = VyuhBinding.instance.content;

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

  Widget _buildContent(BuildContext context, dynamic data) {
    if (widget.builder != null) {
      final content = data as T?;
      return content != null
          ? widget.builder!(context, content)
          : VyuhBinding.instance.widgetBuilder.errorView(
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
          ? widget.listBuilder!(context, contentList)
          : VyuhBinding.instance.widgetBuilder.errorView(
              context,
              title: 'No Content found',
              subtitle: 'Query: ${widget.query}',
            );
    }
  }
}
