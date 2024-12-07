import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/plugin/content/debug_modifier.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The base interface for all schema-driven content items.
abstract interface class SchemaItem {
  /// The schema type of the content item.
  String get schemaType;
}

/// The base interface for all schema-driven document items.
abstract interface class DocumentItem implements SchemaItem {}

/// The base class for all content items. A content item represents a piece of
/// content that can be rendered on the screen and fetched from a Content Management System (CMS).
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
    final type = vyuh.content.provider.schemaType(json);
    return vyuh.content.fromJson<ContentItem>(json) ??
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

abstract class ContentModifierConfiguration implements SchemaItem {
  @override
  final String schemaType;

  ContentModifierConfiguration({required this.schemaType});

  factory ContentModifierConfiguration.fromJson(Map<String, dynamic> json) =>
      throw Exception('Must be implemented in subclass');

  Widget build(BuildContext context, Widget child, ContentItem content);
}

/// Base class for a Layout Configuration. A layout configuration is used to
/// configure the visual layout of a content item.
abstract class LayoutConfiguration<T extends ContentItem>
    implements SchemaItem {
  @override
  final String schemaType;

  /// Creates an instance of [LayoutConfiguration].
  LayoutConfiguration({required this.schemaType});

  /// Converts the JSON representation of the layout configuration to an instance of [LayoutConfiguration].
  factory LayoutConfiguration.fromJson(Map<String, dynamic> json) =>
      throw Exception('Must be implemented in subclass');

  /// Builds the layout for the content item. This transforms the content into a Flutter Widget.
  Widget build(BuildContext context, T content);
}

/// Represents a container item that can contain other content items.
abstract interface class ContainerItem {}

/// Represents a root item that is the root of a content tree.
abstract interface class RootItem {}
