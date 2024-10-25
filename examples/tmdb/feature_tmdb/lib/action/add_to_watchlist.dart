import 'dart:async';

import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'add_to_watchlist.g.dart';

@JsonSerializable()
final class AddToWatchlist extends ActionConfiguration {
  static const schemaName = 'tmdb.action.addToWatchlist';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: AddToWatchlist.fromJson,
    title: 'Add to Watchlist',
  );

  AddToWatchlist({super.isAwaited}) : super(schemaType: schemaName);

  factory AddToWatchlist.fromJson(Map<String, dynamic> json) =>
      _$AddToWatchlistFromJson(json);

  @override
  FutureOr<void> execute(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    final store = vyuh.di.get<TMDBStore>();
    final routerState = GoRouterState.of(context);

    final id = routerState.movieId() ?? routerState.seriesId();
    if (id == null) {
      return null;
    }

    final movie = store.getFuture('$id.movie')?.value as Movie?;
    final series = store.getFuture('$id.series')?.value as Series?;

    if (movie != null) {
      store.addToWatchlist(movie.shortInfo());
    } else if (series != null) {
      store.addToWatchlist(series.shortInfo());
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${store.isMoviesMode ? 'movie' : 'series'} to Watchlist',
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
