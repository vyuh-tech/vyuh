import 'package:flutter/material.dart';

/// A widget to display a list item for a content item.
///
final class ContentListItem extends StatelessWidget {
  /// The title of the content item.
  ///
  final String title;

  /// Whether the content item is selected.
  ///
  final bool isSelected;

  /// Whether the content item is special.
  ///
  final bool isSpecial;

  /// The callback to invoke when the content item is tapped.
  ///
  final VoidCallback? onTap;

  /// Creates a new content list item widget.
  ///
  const ContentListItem({
    super.key,
    required this.title,
    this.isSelected = false,
    this.isSpecial = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color:
            isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.apply(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
