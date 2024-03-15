import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

@JsonSerializable(createFactory: false)
abstract class ContentItem {
  @JsonKey(includeFromJson: false)
  final String schemaType;

  @JsonKey(fromJson: typeFromFirstOfListJson<LayoutConfiguration>)
  final LayoutConfiguration<ContentItem>? layout;

  @JsonKey(includeFromJson: false)
  ContentItem? parent;

  ContentItem({
    required this.schemaType,
    this.layout,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final type = vyuh.content.provider.schemaType(json);
    return vyuh.content.fromJson<ContentItem>(json) ??
        Unknown(
            missingSchemaType: type,
            description:
                'This is due to a missing implementation for the ContentItem.');
  }

  @protected
  void setParent(Iterable<ContentItem?> children) {
    for (final child in children) {
      child?.parent = this;
    }
  }
}

abstract class LayoutConfiguration<T extends ContentItem> {
  final String schemaType;

  LayoutConfiguration({required this.schemaType});

  factory LayoutConfiguration.fromJson(Map<String, dynamic> json) =>
      throw Exception('Must be implemented in subclass');

  Widget build(BuildContext context, T content);
}

abstract interface class ContainerItem {}

abstract interface class RootItem {}
