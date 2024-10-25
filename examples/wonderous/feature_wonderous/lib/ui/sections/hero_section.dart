import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:feature_wonderous/ui/formatters.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart'
    hide Divider, Card;

final class WonderHeroSection extends StatelessWidget {
  final Wonder wonder;
  const WonderHeroSection({super.key, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WonderSection(
      child: Container(
        color: wonder.color,
        padding: EdgeInsets.all(theme.spacing.s16),
        child: Column(
          children: [
            ContentImage(
              ref: wonder.icon,
            ),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.spacing.s8),
                  child: Text(
                    wonder.subtitle,
                    style: theme.textTheme.bodyMedium
                        ?.apply(color: wonder.textColor),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            Text(
              wonder.title,
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.displayMedium?.apply(color: wonder.textColor),
            ),
            Text(
              wonder.location.place,
              style: theme.textTheme.bodyMedium?.apply(color: wonder.textColor),
            ),
            const Divider(),
            Text(
              '${wonder.startYear.formattedYear} to ${wonder.endYear.formattedYear}',
              style: theme.textTheme.bodyMedium
                  ?.apply(color: wonder.textColor, fontWeightDelta: 2),
            ),
            SizedBox(height: theme.spacing.s16),
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(theme.borderRadius.medium),
              child: ContentImage(ref: wonder.image),
            ),
          ],
        ),
      ),
    );
  }
}
