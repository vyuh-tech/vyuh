import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:feature_wonderous/ui/formatters.dart';
import 'package:flutter/material.dart';

final class WonderEventsSection extends StatelessWidget {
  final Wonder wonder;
  const WonderEventsSection({super.key, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WonderSection(
      child: Column(
        children: [
          WonderHeader(wonder: wonder),
          SizedBox(height: theme.spacing.s16),
          for (final event in wonder.events) WonderEvent(event: event),
        ],
      ),
    );
  }
}

class WonderEvent extends StatelessWidget {
  final Event event;
  const WonderEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final year = event.year.formattedYear.split(' ').join('\n');
    return Container(
      padding: EdgeInsets.all(theme.spacing.s8),
      margin: EdgeInsets.symmetric(vertical: theme.spacing.s8),
      color: theme.colorScheme.surfaceDim,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(
                year,
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
            ),
            SizedBox(width: theme.sizing.s2),
            VerticalDivider(color: theme.colorScheme.surface),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.s8),
                child: Text(
                  event.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
