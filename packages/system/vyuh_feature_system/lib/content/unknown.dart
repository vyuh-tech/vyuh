import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class UnknownDescriptor extends ContentDescriptor {
  UnknownDescriptor() : super(schemaType: Unknown.schemaName, title: 'Unknown');
}

class UnknownContentBuilder extends ContentBuilder<Unknown> {
  UnknownContentBuilder()
      : super(
          content: TypeDescriptor(
              schemaType: Unknown.schemaName,
              title: 'Unknown',
              fromJson: Unknown.fromJson),
          defaultLayout: DefaultUnknownLayout(),
          defaultLayoutDescriptor: DefaultUnknownLayout.typeDescriptor,
        );
}

final class DefaultUnknownLayout extends LayoutConfiguration<Unknown> {
  static const schemaName = '${Unknown.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
      schemaType: schemaName,
      title: 'Default Unknown Layout',
      fromJson: DefaultUnknownLayout.fromJson);

  DefaultUnknownLayout() : super(schemaType: schemaName);

  factory DefaultUnknownLayout.fromJson(Map<String, dynamic> json) =>
      DefaultUnknownLayout();

  @override
  Widget build(BuildContext context, Unknown content) {
    final theme = Theme.of(context);
    return Container(
        color: Colors.red.shade300,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.do_not_disturb_alt_rounded,
                  color: Colors.white54,
                  size: 32,
                ),
                const SizedBox(width: 10),
                const Text('Missing schemaType:'),
                const SizedBox(width: 4),
                Text(content.missingSchemaType,
                    style:
                        theme.textTheme.bodyMedium?.apply(fontWeightDelta: 4)),
              ],
            ),
            const SizedBox(height: 8),
            Text(content.description),
          ],
        ));
  }
}
