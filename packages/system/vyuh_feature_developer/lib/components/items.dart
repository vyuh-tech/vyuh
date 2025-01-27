import 'package:flutter/material.dart';

/// A widget to display a list item for an item.
///
final class ItemTile extends StatelessWidget {
  /// The title of the item.
  ///
  final String title;

  /// The description of the item.
  ///
  final String? description;

  /// The callback to invoke when the item is tapped.
  ///
  final Function()? onTap;

  /// Creates a new item tile widget.
  ///
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

/// A widget to display an empty item tile.
///
final class EmptyItemTile extends StatelessWidget {
  /// Creates a new empty item tile widget.
  ///
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
