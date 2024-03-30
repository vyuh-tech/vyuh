import 'package:flutter/material.dart';

class ItemsAsGrid extends StatelessWidget {
  final List<Widget> children;

  final int columns;
  final double childAspectRatio;

  const ItemsAsGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.childAspectRatio = 1 / 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio,
      children: children,
    );
  }
}

class ItemCard extends StatelessWidget {
  final String title;
  final String? description;
  final bool asCard;

  const ItemCard({
    super.key,
    required this.title,
    this.description,
    this.asCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge,
        ),
        if (description != null)
          Text(
            description!,
            style:
                theme.textTheme.labelMedium?.apply(color: theme.disabledColor),
          ),
      ],
    );

    return asCard
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          )
        : child;
  }
}

class EmptyItemCard extends StatelessWidget {
  const EmptyItemCard({super.key});

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
