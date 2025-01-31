import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A versatile content widget that handles both single and list content items
/// using Vyuh's ContentProvider system.
class VyuhContentWidget<T extends ContentItem> extends StatefulWidget {
  final ContentPlugin? contentPlugin;
  final ContentExtensionDescriptor? descriptor;
  final String query;
  final FromJsonConverter<T> fromJson;
  final Map<String, String>? queryParams;
  final Widget Function(BuildContext, T)? singleBuilder;
  final Widget Function(BuildContext, List<T>)? listBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget Function(BuildContext, String)? errorBuilder;

  const VyuhContentWidget({
    super.key,
    required this.contentPlugin,
    required this.query,
    required this.fromJson,
    this.queryParams,
    this.singleBuilder,
    this.listBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.descriptor,
  }) : assert(
          (singleBuilder != null) ^ (listBuilder != null),
          'Must provide exactly one of singleBuilder or listBuilder',
        );

  static Widget defaultErrorBuilder(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }

  static Widget defaultLoadingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  State<VyuhContentWidget<T>> createState() => _VyuhContentWidgetState<T>();
}

class _VyuhContentWidgetState<T extends ContentItem>
    extends State<VyuhContentWidget<T>> {
  ContentExtensionBuilder? _extensionBuilder;
  Future<void> _envFuture = Future.value();
  Future<dynamic>? _contentFuture;

  @override
  void initState() {
    super.initState();

    _envFuture = _initialize();
    _fetchContent();
  }

  @override
  void dispose() {
    _extensionBuilder?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoader(context);
        }

        if (snapshot.hasError) {
          return _buildError(
            context,
            'Failed to load content: ${snapshot.error}',
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

    if (oldWidget.contentPlugin != widget.contentPlugin) {
      _envFuture = _initialize();
      _fetchContent();
    }
  }

  Future<void> _initialize() async {
    if (widget.contentPlugin != null) {
      await _extensionBuilder?.dispose();

      _extensionBuilder =
          ContentExtensionBuilder(getPlugin: () => widget.contentPlugin!);

      await widget.contentPlugin!.init();

      await _extensionBuilder!.init([
        if (widget.descriptor != null) widget.descriptor!,
      ]);
    }
  }

  void _fetchContent() {
    final plugin = widget.contentPlugin ?? VyuhBinding.instance.contentPlugin;
    assert(
      plugin != null,
      '''
ContentPlugin must be set before using VyuhContentWidget. This could be set in two ways:
- By passing a ContentPlugin instance to the VyuhContentWidget constructor.
- On the VyuhBinding, by calling the VyuhBinding.setContentPlugin() method. Make sure to do this before using VyuhContentWidget.
  Typically you could do this before calling Flutter's runApp().
''',
    );

    // Wait for the environment to be ready before fetching content
    _contentFuture = _envFuture.then((_) {
      return widget.singleBuilder != null
          ? plugin!.provider.fetchSingle<T>(
              widget.query,
              fromJson: widget.fromJson,
              queryParams: widget.queryParams,
            )
          : plugin!.provider.fetchMultiple<T>(
              widget.query,
              fromJson: widget.fromJson,
              queryParams: widget.queryParams,
            );
    });
  }

  Widget _buildContent(BuildContext context, dynamic data) {
    if (widget.singleBuilder != null) {
      final content = data as T?;
      return content != null
          ? widget.singleBuilder!(context, content)
          : _buildError(context, 'Content not found');
    } else {
      final contentList = data as List<T>?;
      return contentList != null
          ? widget.listBuilder!(context, contentList)
          : _buildError(context, 'Content not found');
    }
  }

  Widget _buildError(BuildContext context, String message) {
    return widget.errorBuilder?.call(context, message) ??
        VyuhContentWidget.defaultErrorBuilder(context, message);
  }

  Widget _buildLoader(BuildContext context) {
    return widget.loadingBuilder?.call(context) ??
        VyuhContentWidget.defaultLoadingBuilder(context);
  }
}
