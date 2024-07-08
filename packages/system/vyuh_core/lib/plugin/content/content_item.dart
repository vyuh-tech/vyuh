import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The base interface for all schema-driven content items.
abstract interface class SchemaItem {
  /// The schema type of the content item.
  String get schemaType;
}

/// The base class for all content items. A content item represents a piece of
/// content that can be rendered on the screen and fetched from a Content Management System (CMS).
@JsonSerializable(createFactory: false)
abstract class ContentItem implements SchemaItem {
  @override
  @JsonKey(includeFromJson: false)
  final String schemaType;

  /// The layout configuration for the content item.
  @JsonKey(fromJson: typeFromFirstOfListJson<LayoutConfiguration>)
  final LayoutConfiguration<ContentItem>? layout;

  /// The parent content item of this content item. This is used internally by the content system.
  @JsonKey(includeFromJson: false)
  ContentItem? parent;

  /// Creates an instance of [ContentItem].
  ContentItem({
    required this.schemaType,
    this.layout,
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
