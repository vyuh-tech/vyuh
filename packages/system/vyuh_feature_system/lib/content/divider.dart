import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'divider.g.dart';

/// A content item that renders a horizontal dividing line.
///
/// Features:
/// * Customizable thickness
/// * Configurable padding/indent
/// * Can be used in portable text blocks
/// * Supports theme-based styling
///
/// Example:
/// ```dart
/// final divider = Divider(
///   thickness: 2.0,
///   indent: 16.0,
/// );
/// ```
///
/// The divider can be used:
/// * Between content sections
/// * Inside portable text blocks
/// * As a visual separator in layouts
@JsonSerializable()
class Divider extends ContentItem implements PortableBlockItem {
  static const schemaName = 'vyuh.divider';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Divider',
    fromJson: Divider.fromJson,
    preview: () => Divider(),
  );

  static final contentBuilder = ContentBuilder(
    content: Divider.typeDescriptor,
    defaultLayout: DefaultDividerLayout(),
    defaultLayoutDescriptor: DefaultDividerLayout.typeDescriptor,
  );

  final double? thickness;
  final double? indent;

  Divider({
    this.thickness = 1,
    this.indent = 8,
    super.layout,
    super.modifiers,
  }) : super(schemaType: Divider.schemaName);

  factory Divider.fromJson(Map<String, dynamic> json) =>
      _$DividerFromJson(json);

  @override
  String get blockType => Divider.schemaName;
}

/// Descriptor for configuring divider content type in the system.
///
/// Allows configuring:
/// * Available layouts for dividers
/// * Custom layouts for specific use cases
///
/// Example:
/// ```dart
/// final descriptor = DividerDescriptor(
///   layouts: [
///     DefaultDividerLayout.typeDescriptor,
///   ],
/// );
/// ```
class DividerDescriptor extends ContentDescriptor {
  DividerDescriptor({super.layouts})
      : super(schemaType: Divider.schemaName, title: 'Divider');
}

/// Default layout for divider content.
///
/// Features:
/// * Renders a horizontal line with configurable thickness
/// * Applies optional padding/indent
/// * Uses theme colors for the divider
///
/// Example:
/// ```dart
/// final layout = DefaultDividerLayout();
/// ```
final class DefaultDividerLayout extends LayoutConfiguration<Divider> {
  static const schemaName = '${Divider.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Divider Layout',
    fromJson: DefaultDividerLayout.fromJson,
    preview: () => DefaultDividerLayout(),
  );

  DefaultDividerLayout()
      : super(schemaType: '${Divider.schemaName}.layout.default');

  factory DefaultDividerLayout.fromJson(Map<String, dynamic> json) =>
      DefaultDividerLayout();

  @override
  Widget build(BuildContext context, Divider content) {
    final child = f.Divider(
      thickness: content.thickness,
    );

    return content.indent != null && content.indent! > 0
        ? Padding(
            padding: EdgeInsets.all(content.indent!),
            child: child,
          )
        : child;
  }
}
