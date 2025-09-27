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
    // Handle internal unknown content items by converting to ContentItemFailure
    if (content is UnknownContentItem) {
      final failure = ContentItemFailure(
        schemaType: content.missingSchemaType,
        jsonPayload: content.jsonPayload,
        description: 'No ContentItem registration found for schema type: ${content.missingSchemaType}',
        suggestions: [
          'Register a TypeDescriptor for ${content.missingSchemaType}',
          'Check if the content type is properly exported',
          'Verify the schema type matches the registered type',
        ],
      );
      return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
    }

    final builder = _extensionBuilder!.contentBuilder(content.schemaType);

    // Handle missing ContentBuilder
    if (builder == null) {
      final failure = LayoutFailure(
        schemaType: content.schemaType,
        contentSchemaType: content.schemaType,
        description: 'No ContentBuilder registered for this schema type',
        suggestions: ['Register a ContentBuilder for ${content.schemaType}'],
      );
      return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
    }

    Widget contentWidget;

    // Check if we have an unknown layout configuration
    if (layout != null && layout is UnknownLayoutConfiguration) {
      final unknownLayout = layout as UnknownLayoutConfiguration;
      final failure = LayoutFailure(
        schemaType: unknownLayout.missingSchemaType,
        contentSchemaType: content.schemaType,
        jsonPayload: unknownLayout.jsonPayload,
        description: 'Unknown layout type: ${unknownLayout.missingSchemaType}',
        suggestions: [
          'Register a TypeDescriptor for ${unknownLayout.missingSchemaType}',
          'Check if the layout type is properly exported',
        ],
      );
      return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
    }

    try {
      contentWidget =
          layout?.build(context, content) ?? builder.build(context, content);
    } catch (e) {
      final failure = LayoutFailure(
        schemaType: layout?.schemaType ?? builder.defaultLayout.schemaType,
        contentSchemaType: content.schemaType,
        requestedLayoutType: layout?.schemaType,
        description: 'Failed to build layout: ${e.toString()}',
        suggestions: [
          'Check if the layout is compatible with content type ${content.schemaType}',
          'Verify layout implementation for ${layout?.schemaType ?? 'default layout'}',
        ],
      );
      return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
    }

    final modifiers = content.getModifiers();

    if (modifiers != null && modifiers.isNotEmpty) {
      // Check for unknown modifiers first
      for (int i = 0; i < modifiers.length; i++) {
        final modifier = modifiers[i];
        if (modifier is UnknownContentModifierConfiguration) {
          final modifierChain = modifiers.map((m) => m.schemaType).toList();
          final failure = ModifierFailure(
            schemaType: modifier.missingSchemaType,
            modifierChain: modifierChain,
            failedIndex: i,
            jsonPayload: modifier.jsonPayload,
            description: 'Unknown modifier type: ${modifier.missingSchemaType}',
            suggestions: [
              'Register a TypeDescriptor for ${modifier.missingSchemaType}',
              'Check if the modifier type is properly exported',
            ],
          );
          return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
        }
      }

      try {
        return modifiers.fold<Widget>(
          contentWidget,
          (child, modifier) => modifier.build(context, child, content),
        );
      } catch (e) {
        final modifierChain = modifiers.map((m) => m.schemaType).toList();
        // Try to determine which modifier failed (this is a best effort)
        final failedIndex = modifiers.length - 1; // Default to the last one

        final failure = ModifierFailure(
          schemaType: modifiers.last.schemaType,
          modifierChain: modifierChain,
          failedIndex: failedIndex,
          description: 'Failed to apply modifier: ${e.toString()}',
          suggestions: [
            'Check modifier implementation for ${modifiers.last.schemaType}',
            'Verify modifier compatibility with content type ${content.schemaType}',
          ],
        );
        return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
      }
    }

    return contentWidget;
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
