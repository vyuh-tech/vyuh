import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The base class for a Content Plugin
abstract class ContentPlugin extends Plugin {
  /// The ContentProvider for this plugin
  final ContentProvider provider;

  /// Creates a new ContentPlugin with the given provider, name, and title
  ContentPlugin({
    required this.provider,
    required super.name,
    required super.title,
  }) : super();

  /// The type registry that maps types to their descriptors
  Map<Type, Map<String, TypeDescriptor>> get typeRegistry;

  /// Builds a Widget for the given content
  Widget buildContent(BuildContext context, ContentItem content);

  /// Builds a Widget for the given route url or id. This is used for top-level documents called routes.
  /// These could represent a page, dialog or a conditional-route.
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId});

  /// Sets up the plugin with the given features. The plugin scans the features to extract all the content items.
  /// This plugin relies on the ContentExtensionBuilder to do its work.
  void setup(List<FeatureDescriptor> features);

  /// Converts the given json to a content item of type T
  T? fromJson<T>(Map<String, dynamic> json);

  /// Registers the given type descriptor
  register<T>(TypeDescriptor<T> descriptor);

  /// Checks if the given type descriptor is registered
  isRegistered<T>(TypeDescriptor<T> descriptor);
}
