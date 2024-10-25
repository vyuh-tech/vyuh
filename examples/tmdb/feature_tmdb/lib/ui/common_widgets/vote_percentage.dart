import 'dart:ui';

import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:flutter/material.dart';

class VotePercentage extends StatelessWidget {
  final double? voteAverage;
  final bool hasBackground;
  const VotePercentage({
    super.key,
    required this.voteAverage,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: hasBackground
            ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
            : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Container(
          padding: EdgeInsets.all(
            theme.spacing.s8,
          ),
          decoration: hasBackground
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.borderRadius.small),
                  color: theme.colorScheme.shadow.withOpacity(0.6),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🔥',
                style: theme.tmdbTheme.labelMedium,
              ),
              Gap.w4,
              Text(
                '${voteAverage.percentage}%',
                style: theme.tmdbTheme.labelMedium?.copyWith(
                  color: hasBackground
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
