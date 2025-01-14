import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'empty.g.dart';

/// A reusable empty widget that takes up no space.
/// Used as a default fallback when no content should be rendered.
const empty = SizedBox.shrink();

/// A content item that renders nothing, taking up no space in the layout.
///
/// Features:
/// * Zero-size rendering
/// * Useful as a placeholder
/// * Can be used as a fallback
/// * Supports content modifiers
///
/// Example:
/// ```dart
/// final emptyContent = Empty();
/// ```
///
/// Common uses:
/// * Default case in conditionals
/// * Placeholder in optional content areas
/// * Fallback when content is unavailable
@JsonSerializable()
class Empty extends ContentItem {
  static const schemaName = 'vyuh.empty';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Empty',
    fromJson: Empty.fromJson,
    preview: () => Empty(),
  );

  static final contentBuilder = ContentBuilder(
    content: Empty.typeDescriptor,
    defaultLayout: DefaultEmptyLayout(),
    defaultLayoutDescriptor: DefaultEmptyLayout.typeDescriptor,
  );

  Empty({
    super.layout,
    super.modifiers,
  }) : super(schemaType: Empty.schemaName);

  factory Empty.fromJson(Map<String, dynamic> json) => _$EmptyFromJson(json);
}

/// Descriptor for configuring empty content type in the system.
///
/// The empty content type doesn't support custom layouts since it always
/// renders nothing.
///
/// Example:
/// ```dart
/// final descriptor = EmptyDescriptor();
/// ```
class EmptyDescriptor extends ContentDescriptor {
  EmptyDescriptor()
      : super(schemaType: Empty.schemaName, title: 'Empty', layouts: const []);
}

/// Default layout for empty content that renders nothing.
///
/// This layout always returns a [SizedBox.shrink] regardless of any
/// configuration, ensuring the content takes up no space in the layout.
///
/// Example:
/// ```dart
/// final layout = DefaultEmptyLayout();
/// ```
final class DefaultEmptyLayout extends LayoutConfiguration<Empty> {
  static const schemaName = '${Empty.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Empty Layout',
    fromJson: DefaultEmptyLayout.fromJson,
    preview: () => DefaultEmptyLayout(),
  );

  DefaultEmptyLayout() : super(schemaType: schemaName);

  factory DefaultEmptyLayout.fromJson(Map<String, dynamic> json) =>
      DefaultEmptyLayout();

  @override
  Widget build(BuildContext context, Empty content) {
    return empty;
  }
}
