import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class BoxWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  const BoxWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final store = vyuh.di.get<TMDBStore>();

    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        store.toggleBrowseMode();
      },
      child: isSelected
          ? Container(
              height: theme.spacing.s40,
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.s20,
                vertical: theme.spacing.s8,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(icon, color: theme.colorScheme.onPrimary),
                  SizedBox(width: theme.spacing.s8),
                  Text(
                    title,
                    style: theme.tmdbTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            )
          : Icon(icon, color: theme.colorScheme.shadow),
    );
  }
}
