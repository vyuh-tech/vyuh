import 'package:flutter/material.dart';

class ItemsAsGrid extends StatelessWidget {
  final Iterable<(String title, String? subtitle)> items;

  final int columns;
  final double childAspectRatio;

  const ItemsAsGrid({
    super.key,
    required this.items,
    this.columns = 2,
    this.childAspectRatio = 1 / 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverGrid.count(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio,
      children: items
          .map((e) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.$1,
                        style: theme.textTheme.bodyLarge,
                      ),
                      if (e.$2 != null)
                        Text(
                          e.$2!,
                          style: theme.textTheme.bodyMedium
                              ?.apply(color: theme.disabledColor),
                        ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
