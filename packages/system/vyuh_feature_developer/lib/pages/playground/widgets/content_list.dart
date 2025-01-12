import 'package:flutter/material.dart';

final class ContentList extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Widget? emptyStateWidget;

  const ContentList({
    super.key,
    required this.title,
    required this.items,
    this.emptyStateWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(2),
            child: Text(
              '$title (${items.length})',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.apply(
                fontWeightDelta: 2,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? (emptyStateWidget ??
                    Center(
                      child: Text(
                        'No items',
                        style: theme.textTheme.bodyMedium?.apply(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: items,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
