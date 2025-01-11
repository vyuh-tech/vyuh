import 'package:flutter/material.dart';

final class ContentListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isSpecial;
  final VoidCallback? onTap;

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
