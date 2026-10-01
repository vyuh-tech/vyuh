import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'document_future_builder.dart';
import 'document_stream_builder.dart';
import 'scoped_di_widget.dart';

/// A widget that builds UI based on document data fetched from a content provider.
///
/// This widget is responsible for fetching document data from a content provider
/// and building UI based on that data. It supports both static and live document
/// loading, and can be configured to allow refreshing the document.
///
/// Example usage:
/// ```dart
/// // Using the factory method to fetch by query
/// DocumentBuilder.fromQuery<BlogPost>(
///   query: '*[_type == "blog.post" && slug.current == $slug][0]',
///   fromJson: BlogPost.fromJson,
///   allowRefresh: true,
///   isLive: true,
///   buildContent: (context, post) => BlogPostView(post: post),
/// )
///
/// // Using the factory method to fetch by ID
/// DocumentBuilder.fromId<BlogPost>(
///   id: 'blog-post-123',
///   fromJson: BlogPost.fromJson,
///   allowRefresh: true,
///   buildContent: (context, post) => BlogPostView(post: post),
/// )
///
/// // Using a custom future
/// DocumentBuilder<BlogPost>(
///   fetchDocument: () => myCustomFuture,
///   allowRefresh: true,
///   buildContent: (context, post) => BlogPostView(post: post),
/// )
/// ```
final class DocumentBuilder<T> extends StatelessWidget {
  /// A function that returns a future of the document.
  final Future<T?> Function() fetchDocument;

  /// A stream of document data for live updates.
  final Stream<T?>? liveDocument;

  /// Creates a fresh subscription for live refresh/retry.
  final Stream<T?> Function()? liveDocumentFactory;

  /// Whether to allow refreshing the document.
  final bool allowRefresh;

  /// Whether to use live document updates.
  final bool isLive;

  /// A function that builds the UI for the document.
  final Widget Function(BuildContext context, T document) buildContent;

  /// Optional custom initialization function for the document.
  /// This allows for document-specific initialization logic.
  final Future<T?> Function(BuildContext context, T document)? initDocument;

  /// Creates a [DocumentBuilder] with a custom document fetching function.
  const DocumentBuilder({
    super.key,
    required this.fetchDocument,
    this.liveDocument,
    this.liveDocumentFactory,
    required this.buildContent,
    this.allowRefresh = true,
    this.isLive = false,
    this.initDocument,
  });

  /// Creates a [DocumentBuilder] that fetches a document by query.
  static DocumentBuilder<T> fromQuery<T>({
    Key? key,
    required String query,
    Map<String, String>? queryParams,
    required FromJsonConverter<T> fromJson,
    required Widget Function(BuildContext, T) buildContent,
    bool includeDrafts = false,
    bool allowRefresh = true,
    bool isLive = false,
    Future<T?> Function(BuildContext, T?)? initDocument,
  }) {
    return DocumentBuilder<T>(
      key: key,
      fetchDocument: () => vyuh.content.provider.fetchSingle(
        query,
        fromJson: fromJson,
        queryParams: queryParams,
      ),
      liveDocumentFactory: isLive
          ? () => vyuh.content.provider.live.fetchSingle(
              query,
              fromJson: fromJson,
              queryParams: queryParams,
              includeDrafts: includeDrafts,
            )
          : null,
      buildContent: buildContent,
      allowRefresh: allowRefresh,
      isLive: isLive,
      initDocument: initDocument,
    );
  }

  /// Creates a [DocumentBuilder] that fetches a document by ID.
  static DocumentBuilder<T> fromId<T>({
    Key? key,
    required String id,
    required FromJsonConverter<T> fromJson,
    required Widget Function(BuildContext, T) buildContent,
    bool includeDrafts = false,
    bool allowRefresh = true,
    bool isLive = false,
    Future<T?> Function(BuildContext, T?)? initDocument,
  }) {
    return DocumentBuilder<T>(
      key: key,
      fetchDocument: () =>
          vyuh.content.provider.fetchById(id, fromJson: fromJson),
      liveDocumentFactory: isLive
          ? () => vyuh.content.provider.live.fetchById(
              id,
              fromJson: fromJson,
              includeDrafts: includeDrafts,
            )
          : null,
      buildContent: buildContent,
      allowRefresh: allowRefresh,
      isLive: isLive,
      initDocument: initDocument,
    );
  }

  /// Creates a [DocumentBuilder] that fetches a route by path or ID.
  static DocumentBuilder<RouteBase> fromRoute({
    Key? key,
    Uri? url,
    String? routeId,
    required Widget Function(BuildContext, RouteBase) buildContent,
    bool includeDrafts = false,
    bool allowRefresh = true,
    bool isLive = false,
  }) {
    assert(
      (url != null && routeId == null) || (url == null && routeId != null),
      'Either url or routeId must be provided, but not both.',
    );

    return DocumentBuilder<RouteBase>(
      key: key,
      fetchDocument: () =>
          vyuh.content.provider.fetchRoute(path: url?.path, routeId: routeId),
      liveDocumentFactory: isLive
          ? () => vyuh.content.provider.live.fetchRoute(
              path: url?.path,
              routeId: routeId,
              includeDrafts: includeDrafts,
            )
          : null,
      initDocument: (context, document) async {
        return await document.init(context);
      },
      buildContent: buildContent,
      allowRefresh: allowRefresh,
      isLive: isLive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedDIWidget(
      debugLabel: 'Scoped DI for Document',
      child: Builder(
        builder: (context) {
          return isLive && (liveDocument != null || liveDocumentFactory != null)
              ? _buildLiveDocument(context)
              : _buildStaticDocument(context);
        },
      ),
    );
  }

  /// Builds a document with live updates using DocumentStreamBuilder
  Widget _buildLiveDocument(BuildContext context) =>
      _LiveDocument<T>(owner: this);

  /// Builds a document with one-time loading using DocumentFutureBuilder
  Widget _buildStaticDocument(BuildContext context) {
    return DocumentFutureBuilder<T>(
      allowRefresh: allowRefresh,
      future: () {
        return fetchDocument().then(
          (document) =>
              context.mounted ? _initDocument(context, document) : null,
        );
      },
      buildContent: buildContent,
    );
  }

  /// Common method to initialize a document with proper DI scope handling
  /// This ensures consistent behavior between live and static documents
  Future<T?> _initDocument(BuildContext context, T? document) async {
    if (document == null) {
      return null;
    }

    // Reset DI scope when a new document is fetched
    await context.di.reset();

    if (!context.mounted) {
      return null;
    }

    // If a custom initialization function is provided, use it
    if (initDocument != null) {
      return initDocument!(context, document);
    }

    return document;
  }
}

/// Retains a mapped single-subscription stream across unrelated parent rebuilds.
class _LiveDocument<T> extends StatefulWidget {
  final DocumentBuilder<T> owner;
  const _LiveDocument({required this.owner});
  @override
  State<_LiveDocument<T>> createState() => _LiveDocumentState<T>();
}

class _LiveDocumentState<T> extends State<_LiveDocument<T>> {
  Stream<T?>? _stream;
  int _generation = 0;
  @override
  void initState() {
    super.initState();
    if (widget.owner.liveDocumentFactory == null) {
      _stream = _map(widget.owner.liveDocument!);
    }
  }

  Stream<T?> _map(Stream<T?> stream) {
    final generation = _generation;
    return stream.asyncMap((document) async {
      if (!mounted || generation != _generation) return null;
      final value = await widget.owner._initDocument(context, document);
      return mounted && generation == _generation ? value : null;
    });
  }

  Stream<T?> _createStream() => _map(widget.owner.liveDocumentFactory!());
  @override
  void didUpdateWidget(_LiveDocument<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner.liveDocument != widget.owner.liveDocument ||
        oldWidget.owner.liveDocumentFactory !=
            widget.owner.liveDocumentFactory) {
      _generation++;
      _stream = widget.owner.liveDocumentFactory == null
          ? _map(widget.owner.liveDocument!)
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final owner = widget.owner;
    if (owner.liveDocument != null && owner.liveDocumentFactory != null) {
      throw StateError('Supply liveDocument or liveDocumentFactory, not both');
    }
    return owner.liveDocumentFactory == null
        ? DocumentStreamBuilder<T>(
            key: ValueKey(_generation),
            stream: _stream!,
            allowRefresh: owner.allowRefresh,
            buildContent: owner.buildContent,
          )
        : DocumentStreamBuilder<T>.refreshable(
            key: ValueKey(_generation),
            streamFactory: _createStream,
            allowRefresh: owner.allowRefresh,
            buildContent: owner.buildContent,
          );
  }
}
