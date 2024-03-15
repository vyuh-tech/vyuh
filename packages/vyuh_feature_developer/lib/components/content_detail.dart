import 'package:flutter/material.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class ContentDetail extends StatelessWidget {
  final ContentDescriptor content;
  const ContentDetail({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layoutCount = content.layouts?.length ?? 0;

    return ExpansionTile(
      title: Text(content.title),
      subtitle: Row(
        children: [
          Text(content.schemaType,
              style: theme.textTheme.bodyMedium
                  ?.apply(color: theme.disabledColor)),
          if (layoutCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '[$layoutCount ${layoutCount == 1 ? 'layout' : 'layouts'}]',
                style: theme.textTheme.bodySmall,
              ),
            )
        ],
      ),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.all(8),
      children: content.layouts != null && content.layouts!.isNotEmpty
          ? content.layouts!.map((e) => Text(e.title)).toList(growable: false)
          : [const Text('No layouts defined.')],
    );
  }
}
