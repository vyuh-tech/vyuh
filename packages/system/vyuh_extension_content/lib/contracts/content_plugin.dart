import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// Builds the widget shown for a [ContentFailure].
///
/// Example:
/// ```dart
/// UnknownContentBuilder builder = (context, failure) => switch (failure) {
///   ContentItemFailure() => ContentErrorWidget(failure: failure),
///   LayoutFailure() => LayoutErrorWidget(failure: failure),
///   _ => UnknownContentView(failure: failure),
/// };
/// ```
typedef UnknownContentBuilder =
    Widget Function(BuildContext context, ContentFailure failure);

Widget _defaultUnknownBuilder(BuildContext context, ContentFailure failure) =>
    UnknownContentView(failure: failure);

/// The base class for a Content Plugin.
///
/// Register it with `PluginDescriptor(others: [...])` and reach it through
/// `vyuh.content` (or `VyuhBinding.instance.content` in widget mode).
abstract class ContentPlugin extends Plugin {
  /// The ContentProvider for this plugin
  final ContentProvider provider;

  /// Builds the widget shown when a content type, layout, modifier, action or
  /// condition is missing. Defaults to [UnknownContentView].
  final UnknownContentBuilder unknown;

  /// Creates a new ContentPlugin with the given provider, name, and title
  ContentPlugin({
    required this.provider,
    required super.name,
    required super.title,
    UnknownContentBuilder? unknown,
  }) : unknown = unknown ?? _defaultUnknownBuilder,
       super();

  /// The type registry that maps types to their descriptors.
  /// This stores the descriptors for LayoutConfiguration, ActionConfiguration, ConditionConfiguration and
  /// possibly others in the future.
  Map<Type, Map<String, TypeDescriptor>> get typeRegistry;

  /// Builds a Widget for the given content. You can pass in an optional [layout]
  /// to override the default layout
  Widget buildContent<T extends ContentItem>(
    BuildContext context,
    T content, {
    LayoutConfiguration<T>? layout,
  });

  /// Builds a Widget for the given route url or id. This is used for top-level documents called routes.
  /// These could represent a page, dialog or a conditional-route.
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId});

  /// Sets up the plugin with the ContentExtensionBuilder.
  /// The plugin relies on the ContentExtensionBuilder to do its work.
  void attach(ExtensionBuilder extBuilder);

  /// Converts the given json to an item of type T
  T? fromJson<T>(Map<String, dynamic> json);

  /// Registers the given type descriptor
  void register<T>(TypeDescriptor<T> descriptor);

  /// Checks if the given schema type is registered for type T
  bool isRegistered<T>(String schemaType);
}

enum FieldName { id, type, key, ref, updatedAt, createdAt }
