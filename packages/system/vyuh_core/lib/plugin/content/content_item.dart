import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The base interface for all schema-driven content items.
///
/// Schema items are the foundation of Vyuh's content system. They represent
/// any content that is defined by a schema in the CMS (Content Management System).
/// All content items must implement this interface to be compatible with the
/// content system.
abstract interface class SchemaItem {
  /// The schema type of the content item.
  ///
  /// This should match the type name defined in the CMS schema.
  /// For example: 'blog.post', 'product.detail', etc.
  String get schemaType;
}

/// The base interface for all schema-driven document items.
///
/// Document items represent top-level content documents in the CMS.
/// They are typically the main content types that users create and manage.
abstract interface class DocumentItem implements SchemaItem {}

/// The base class for all content items in Vyuh.
///
/// A content item represents a piece of content that can be:
/// - Fetched from a Content Management System (CMS)
/// - Rendered on screen with a specific layout
/// - Modified with content modifiers
/// - Organized in a content hierarchy
///
/// Content items are the building blocks of a Vyuh application's content.
/// They combine data from the CMS with presentation logic to create
/// rich, interactive user interfaces.
///
/// Example:
/// ```dart
/// @JsonSerializable()
/// class BlogPost extends ContentItem {
///   static const schemaName = 'blog.post';
///
///   final String title;
///   final String content;
///
///   BlogPost({
///     required this.title,
///     required this.content,
///     super.layout,
///     super.modifiers,
///   }) : super(schemaType: schemaName);
/// }
/// ```
@JsonSerializable(createFactory: false)
abstract class ContentItem implements SchemaItem {
  @override
  @JsonKey(includeFromJson: false)
  final String schemaType;

  /// The layout configuration for the content item.
  @JsonKey(fromJson: typeFromFirstOfListJson<LayoutConfiguration>)
  final LayoutConfiguration? layout;

  @JsonKey(fromJson: modifierList)
  final List<ContentModifierConfiguration>? modifiers;

  static List<ContentModifierConfiguration>? modifierList(dynamic json) =>
      listFromJson<ContentModifierConfiguration>(json);

  /// The parent content item of this content item. This is used internally by the content system.
  @JsonKey(includeFromJson: false)
  ContentItem? parent;

  /// Creates an instance of [ContentItem].
  ContentItem({
    required this.schemaType,
    required this.layout,
    required this.modifiers,
  });

  /// Converts the JSON representation of the content item to an instance of [ContentItem].
  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final type = VyuhBinding.instance.content.provider.schemaType(json);
    return VyuhBinding.instance.content.fromJson<ContentItem>(json) ??
        Unknown(
            missingSchemaType: type,
            description:
                'This is due to a missing implementation for the ContentItem.');
  }

  /// Sets the parent content item for the given list of children.
  @protected
  void setParent(Iterable<ContentItem?> children) {
    for (final child in children) {
      child?.parent = this;
    }
  }

  /// Gets the layout to use for the [ContentItem]. By default its the [layout] itself.
  /// However this acts as an extension point for custom [ContentItem]s
  /// that may have a different strategy for applying layouts.
  LayoutConfiguration? getLayout() => layout;

  /// Gets the modifiers to use for the [ContentItem]. By default its the [modifiers] itself.
  /// However this acts as an extension point for custom [ContentItem]s
  /// that may have a different strategy for applying modifiers.
  List<ContentModifierConfiguration>? getModifiers() => modifiers;
}

/// Configuration for modifying content presentation.
///
/// Content modifiers allow you to wrap content items with additional
/// functionality or styling. They can be used to add:
/// - Animation effects
/// - Layout modifications
/// - Interaction handlers
/// - Debug overlays
///
/// Modifiers are applied in order, wrapping the content item's widget
/// tree from inside out.
///
/// Example:
/// ```dart
/// class FadeInModifier extends ContentModifierConfiguration {
///   @override
///   Widget build(BuildContext context, Widget child, ContentItem content) {
///     return FadeInAnimation(child: child);
///   }
/// }
/// ```
abstract class ContentModifierConfiguration implements SchemaItem {
  @override
  final String schemaType;

  ContentModifierConfiguration({required this.schemaType});

  factory ContentModifierConfiguration.fromJson(Map<String, dynamic> json) =>
      throw Exception('Must be implemented in subclass');

  /// Builds the modifier widget tree for the given content item.
  ///
  /// This method is called by the content system to apply the modifier
  /// to the content item's widget tree.
  Widget build(BuildContext context, Widget child, ContentItem content);
}

/// Base class for configuring the visual layout of a content item.
///
/// Layout configurations define how a content item should be presented
/// on screen. They handle:
/// - Visual structure and arrangement
/// - Responsive design
/// - Theme integration
/// - Content-specific styling
///
/// Each content type can have multiple layout variants, allowing the
/// same content to be displayed differently in different contexts.
///
/// Example:
/// ```dart
/// class BlogPostLayout extends LayoutConfiguration<BlogPost> {
///   @override
///   Widget build(BuildContext context, BlogPost content) {
///     return Column(
///       children: [
///         Text(content.title, style: Theme.of(context).textTheme.headlineLarge),
///         Text(content.content),
///       ],
///     );
///   }
/// }
/// ```
abstract class LayoutConfiguration<T extends ContentItem>
    implements SchemaItem {
  @override
  final String schemaType;

  final Type contentType;

  /// Creates an instance of [LayoutConfiguration].
  LayoutConfiguration({required this.schemaType}) : contentType = T;

  /// Converts the JSON representation of the layout configuration to an instance of [LayoutConfiguration].
  factory LayoutConfiguration.fromJson(Map<String, dynamic> json) =>
      throw Exception('Must be implemented in subclass');

  /// Builds the layout widget tree for the given content item.
  ///
  /// This method is called by the content system to render the content item
  /// with the specified layout.
  Widget build(BuildContext context, T content);
}

/// Represents a container item that can contain other content items.
///
/// Container items are used to create hierarchical content structures.
/// They can hold multiple child content items and provide:
/// - Layout organization
/// - Common styling or behavior
/// - Grouped content management
///
/// Example use cases:
/// - Page sections
/// - Grid or list containers
/// - Tab containers
abstract interface class ContainerItem implements ContentItem {}

/// Represents a root item that is the root of a content tree.
///
/// Root items are special container items that serve as the entry point
/// for a content tree. They typically represent:
/// - Pages
/// - Screens
/// - Top-level content structures
///
/// Root items are directly managed by the content system and can be
/// fetched by their unique identifiers.
abstract interface class RootItem implements ContainerItem {}
