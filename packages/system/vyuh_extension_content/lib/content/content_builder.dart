import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A builder for configuring and managing content types and their layouts.
///
/// Content builders are responsible for:
/// - Registering content types with the content system
/// - Managing layout configurations for content types
/// - Initializing content descriptors
/// - Building content widgets
///
/// Each content type should have its own ContentBuilder that defines:
/// - The content type descriptor
/// - The default layout
/// - Additional layout options
///
/// Example:
/// ```dart
/// class BlogPost extends ContentItem {
///   static const schemaName = 'blog.post';
///
///   static final typeDescriptor = TypeDescriptor(
///     schemaType: schemaName,
///     fromJson: BlogPost.fromJson,
///     title: 'Blog Post',
///   );
///
///   static final contentBuilder = ContentBuilder(
///     content: typeDescriptor,
///     defaultLayout: BlogPostLayout(),
///     defaultLayoutDescriptor: BlogPostLayout.typeDescriptor,
///   );
/// }
/// ```
class ContentBuilder<T extends ContentItem> {
  /// The type descriptor for the content type [T].
  ///
  /// This descriptor is used to register the content type with the
  /// content system and handle JSON serialization.
  final TypeDescriptor<T> content;

  /// The default layout configuration for content type [T].
  ///
  /// This layout is used when no other layout is specified.
  LayoutConfiguration<T> _defaultLayout;
  LayoutConfiguration<T> get defaultLayout => _defaultLayout;

  /// The type descriptor for the default layout.
  ///
  /// This descriptor is used to register the default layout type
  /// with the content system.
  TypeDescriptor<LayoutConfiguration<T>> _defaultLayoutDescriptor;
  TypeDescriptor<LayoutConfiguration<T>> get defaultLayoutDescriptor =>
      _defaultLayoutDescriptor;

  /// List of all available layout type descriptors.
  ///
  /// Includes both the default layout and any additional layouts
  /// registered through content descriptors.
  final List<TypeDescriptor<LayoutConfiguration>> _layouts = [];
  List<TypeDescriptor<LayoutConfiguration>> get layouts => _layouts;

  /// The feature that registered this content builder.
  ///
  /// Set automatically by the content system when the builder
  /// is registered.
  String? _sourceFeature;
  String? get sourceFeature => _sourceFeature;

  /// Updates the source feature for this builder and its layouts.
  ///
  /// This is called internally by the content system and should
  /// not be called directly.
  void setSourceFeature(String? featureName) {
    _sourceFeature = featureName;
    defaultLayoutDescriptor.setSourceFeature(featureName);
  }

  /// Creates a new content builder.
  ///
  /// - [content]: Type descriptor for the content type
  /// - [defaultLayout]: Default layout configuration
  /// - [defaultLayoutDescriptor]: Type descriptor for default layout
  ContentBuilder({
    required this.content,
    required LayoutConfiguration<T> defaultLayout,
    required TypeDescriptor<LayoutConfiguration<T>> defaultLayoutDescriptor,
  })  : _defaultLayout = defaultLayout,
        _defaultLayoutDescriptor = defaultLayoutDescriptor;

  /// Initializes this content builder with the given descriptors.
  ///
  /// This method:
  /// 1. Registers the content type with the content system
  /// 2. Collects all available layouts from descriptors
  /// 3. Registers layout types with the content system
  ///
  /// Must be called before using the builder.
  @mustCallSuper
  void init(List<ContentDescriptor> descriptors) {
    VyuhBinding.instance.content.register<ContentItem>(content);

    final userLayouts = descriptors.expand((element) =>
        element.layouts ?? <TypeDescriptor<LayoutConfiguration>>[]);
    final layouts = <TypeDescriptor<LayoutConfiguration>>{
      defaultLayoutDescriptor,
      ...userLayouts,
    }.toList(growable: false);

    _layouts
      ..clear()
      ..addAll(layouts);

    registerDescriptors<LayoutConfiguration>(layouts);
  }

  /// Registers a list of type descriptors with the content system.
  ///
  /// This is a helper method used by [init] to register layout types.
  /// Can also be used to register other types like modifiers.
  @protected
  void registerDescriptors<U>(Iterable<TypeDescriptor<U>> descriptors,
      {bool checkUnique = false}) {
    for (var element in descriptors) {
      if (checkUnique &&
          VyuhBinding.instance.content.isRegistered<U>(element.schemaType)) {
        continue;
      }

      VyuhBinding.instance.content.register<U>(element);
    }
  }

  /// Builds a widget for the given content item.
  ///
  /// - [content]: The content item to build
  /// - [context]: The build context
  ///
  /// If no layout is provided, uses the default layout.
  Widget build(BuildContext context, T content) {
    var layout = content.getLayout();
    if (layout == null) {
      layout = defaultLayout;
      VyuhBinding.instance.log
          .debug('No layout found for ${content.schemaType}. Using default.');
    }

    return layout.build(context, content);
  }

  /// Sets the default layout for this content builder.
  ///
  /// - [layout]: The new default layout
  /// - [fromJson]: The JSON converter for the layout
  /// - [sourceFeatureName]: The source feature for the layout
  void setDefaultLayout(
    LayoutConfiguration<T> layout, {
    required FromJsonConverter<LayoutConfiguration<T>> fromJson,
    String? sourceFeatureName,
  }) {
    _defaultLayout = layout;

    final currentLayoutSchemaType = _defaultLayoutDescriptor.schemaType;

    _defaultLayoutDescriptor = TypeDescriptor<LayoutConfiguration<T>>(
      schemaType: currentLayoutSchemaType,
      fromJson: fromJson,
      title: 'Override Layout for ${content.schemaType}',
    );
    _defaultLayoutDescriptor.setSourceFeature(sourceFeatureName);

    registerDescriptors<LayoutConfiguration>([_defaultLayoutDescriptor]);

    _layouts.removeWhere((td) => td.schemaType == currentLayoutSchemaType);
    _layouts.insert(0, _defaultLayoutDescriptor);
  }
}
