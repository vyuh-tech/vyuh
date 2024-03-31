import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String title;
  final String? description;
  final Function()? onTap;

  const ItemTile({
    super.key,
    required this.title,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: (description != null)
          ? Text(
              description!,
              style: theme.textTheme.labelMedium
                  ?.apply(color: theme.disabledColor),
            )
          : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded) : null,
      onTap: onTap,
    );
  }
}

class EmptyItemTile extends StatelessWidget {
  const EmptyItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'None defined',
        style: theme.textTheme.labelMedium?.apply(color: theme.disabledColor),
      ),
    );
  }
}
