import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// The default ContentPlugin implementation for the Vyuh framework.
/// This plugin is responsible for fetching content from a CMS and rendering content items.
/// It uses a [ContentExtensionBuilder] to keep track of the various [ContentItem] types.
final class DefaultContentPlugin extends ContentPlugin {
  ContentExtensionBuilder? _extensionBuilder;

  DefaultContentPlugin({required super.provider})
      : super(
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
      return vyuh.widgetBuilder.errorView(context,
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
          return vyuh.widgetBuilder.errorView(context,
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
    final label = [
      url == null ? null : 'Url: $url',
      routeId == null ? null : 'RouteId: $routeId',
      'Route',
    ].firstWhere((x) => x != null);

    return ScopedDIWidget(
      debugLabel: 'Scoped DI for $label',
      child: RouteFutureBuilder(
        url: url,
        routeId: routeId,
        fetchRoute: (context, {path, routeId}) => provider
            .fetchRoute(path: path, routeId: routeId)
            .then((value) async {
          if (!context.mounted) {
            return null;
          }

          // Reset DI scope when a new route is fetched
          await context.di.reset();

          if (!context.mounted) {
            return null;
          }

          // Now initialize the new route, since the DI scope has been reset
          // and we have a clean slate for new registrations
          final finalRoute = await value?.init(context);
          return finalRoute;
        }),
        buildContent: buildContent,
      ),
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
