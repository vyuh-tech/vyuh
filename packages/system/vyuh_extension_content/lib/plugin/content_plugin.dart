import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// The default ContentPlugin implementation for the Vyuh framework.
/// This plugin is responsible for fetching content from a CMS and rendering content items.
/// It uses a [ContentExtensionBuilder] to keep track of the various [ContentItem] types.
final class DefaultContentPlugin extends ContentPlugin {
  ContentExtensionBuilder? _extensionBuilder;

  /// Whether to use live route updates via streams.
  /// When true, uses RouteStreamBuilder for real-time updates.
  /// When false, uses RouteFutureBuilder for one-time loading.
  final bool useLiveRoute;

  /// Whether to allow manual refreshing of the route.
  final bool allowRouteRefresh;

  DefaultContentPlugin({
    required super.provider,
    this.useLiveRoute = false,
    this.allowRouteRefresh = true,
  }) : super(
          name: 'vyuh.plugin.content',
          title: 'Content Plugin',
        );

  @override
  Map<Type, Map<String, TypeDescriptor>> get typeRegistry =>
      _extensionBuilder!.typeRegistry();

  @override
  Widget buildContent<T extends ContentItem>(
    BuildContext context,
    T content, {
    LayoutConfiguration<T>? layout,
  }) {
    final builder = _extensionBuilder!.contentBuilder(content.schemaType);

    assert(builder != null,
        'Failed to retrieve builder for schemaType: ${content.schemaType}. Is the ContentBuilder registered for this schemaType?');

    Widget? contentWidget;
    try {
      contentWidget =
          layout?.build(context, content) ?? builder?.build(context, content);
    } catch (e) {
      final possibleLayouts = [
        layout?.schemaType,
        content.layout?.schemaType,
        builder?.defaultLayout.schemaType
      ].nonNulls;
      return VyuhBinding.instance.widgetBuilder.errorView(context,
          error: e,
          title: 'Failed to build layout',
          subtitle:
              'Possible Layouts: "${possibleLayouts.join(', ')}" for Content: "${content.schemaType}"');
    }

    if (contentWidget != null) {
      final modifiers = content.getModifiers();

      if (modifiers != null && modifiers.isNotEmpty) {
        try {
          return modifiers.fold<Widget>(
            contentWidget,
            (child, modifier) => modifier.build(context, child, content),
          );
        } catch (e) {
          return VyuhBinding.instance.widgetBuilder.errorView(context,
              error: e,
              title: 'Failed to apply modifiers',
              subtitle:
                  'Modifier Chain: "${modifiers.map((m) => m.schemaType).join(' -> ')}" for Content: "${content.schemaType}"');
        }
      }

      return contentWidget;
    }

    return const SizedBox.shrink();
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) {
    return RouteBuilder(
      url: url,
      routeId: routeId,
      includeDrafts: kDebugMode,
      allowRefresh: allowRouteRefresh,
      isLive: useLiveRoute,
    );
  }

  @override
  T? fromJson<T>(Map<String, dynamic> json) {
    final type = provider.schemaType(json);
    return _extensionBuilder!.fromJson<T>(type, json);
  }

  @override
  register<T>(TypeDescriptor<T> descriptor) =>
      _extensionBuilder!.register<T>(descriptor);

  @override
  bool isRegistered<T>(String schemaType) =>
      _extensionBuilder!.isRegistered<T>(schemaType);

  @override
  Future<void> dispose() async {
    await provider.dispose();
    _extensionBuilder?.dispose();
  }

  @override
  Future<void> init() {
    return provider.init();
  }

  @override
  void attach(ExtensionBuilder extBuilder) {
    assert(extBuilder is ContentExtensionBuilder,
        '''For the $runtimeType to work, there must be one $ContentExtensionBuilder in your extension builders.
        However, you have provided a ${extBuilder.runtimeType}''');

    _extensionBuilder = extBuilder as ContentExtensionBuilder;
  }
}
