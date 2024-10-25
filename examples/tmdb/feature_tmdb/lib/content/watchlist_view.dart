import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class WatchlistWidget extends StatelessWidget {
  const WatchlistWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.s16,
        vertical: theme.spacing.s24,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.s8,
            vertical: theme.spacing.s8,
          ),
          child: const Divider(),
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
