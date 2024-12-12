import 'package:design_system/utils/extensions.dart';
import 'package:feature_misc/content/api/model.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class ListContainer extends StatelessWidget {
  final Widget title;
  final Widget child;

  const ListContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(theme.spacing.s8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(theme.spacing.s8),
            color: theme.colorScheme.surfaceDim,
            child: title,
          ),
          child,
        ],
      ),
    );
  }
}

final class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.item});

  final Product item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      title: Padding(
        padding: EdgeInsets.only(bottom: theme.spacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: theme.textTheme.titleMedium),
            Text(
              '\$${item.price}',
            ),
          ],
        ),
      ),
      subtitle: Text(item.description),
      horizontalTitleGap: 0,
      leading: ContentImage(
        url: item.thumbnail,
        width: 64,
        height: 64,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
