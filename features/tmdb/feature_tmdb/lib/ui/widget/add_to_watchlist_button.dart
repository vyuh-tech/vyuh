import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

class AddToWatchlistButton extends StatelessWidget {
  const AddToWatchlistButton({
    super.key,
    required this.item,
  });

  final FeaturedShow item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        final store = vyuh.di.get<TMDBStore>();
        store.addToWatchlist(
          item.isMovie
              ? (item as Movie).shortInfo()
              : (item as Series).shortInfo(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Added ${item.isMovie ? 'Movie' : 'Series'} to Watchlist'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        height: theme.sizing.s14,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(theme.borderRadius.small),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.playlist_add,
              color: theme.colorScheme.onPrimary,
            ),
            SizedBox(width: theme.spacing.s8),
            Text(
              'Add to Watchlist',
              style: theme.tmdbTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
