import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// Builder for unknown content that provides a visual indicator for missing content types.
///
/// This builder is used when the system encounters a content type that:
/// * Has no registered type descriptor
/// * Is missing from the content registry
/// * Has an invalid schema type
///
/// Example:
/// ```dart
/// final builder = UnknownContentBuilder();
/// ```
class UnknownContentBuilder extends ContentBuilder<Unknown> {
  UnknownContentBuilder()
      : super(
          content: Unknown.typeDescriptor,
          defaultLayout: _DefaultUnknownLayout(),
          defaultLayoutDescriptor: _DefaultUnknownLayout.typeDescriptor,
        );
}

/// Default layout for unknown content that displays an error message.
///
/// Features:
/// * Visual error indicator
/// * Display of missing schema type
/// * Description of the issue
/// * Themed error presentation
///
/// This layout helps developers identify and fix content type registration issues
/// by providing clear feedback about what content type is missing.
final class _DefaultUnknownLayout extends LayoutConfiguration<Unknown> {
  static const schemaName = '${Unknown.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Unknown Layout',
    fromJson: _DefaultUnknownLayout.fromJson,
    preview: () => _DefaultUnknownLayout(),
  );

  _DefaultUnknownLayout() : super(schemaType: schemaName);

  factory _DefaultUnknownLayout.fromJson(Map<String, dynamic> json) =>
      _DefaultUnknownLayout();

  @override
  Widget build(BuildContext context, Unknown content) {
    final theme = Theme.of(context);

    return Container(
        color: Colors.red.shade300,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.do_not_disturb_alt_rounded,
                  color: Colors.white54,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  'Missing schemaType',
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(content.missingSchemaType,
                  style: theme.textTheme.bodyMedium?.apply(fontWeightDelta: 4)),
            ),
            Text(content.description),
          ],
        ));
  }
}
