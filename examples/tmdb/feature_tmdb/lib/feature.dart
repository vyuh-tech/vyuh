import 'package:feature_settings/feature_settings.dart';
import 'package:feature_tmdb/action/add_to_watchlist.dart';
import 'package:feature_tmdb/action/drop_down_selection.dart';
import 'package:feature_tmdb/content/api_config_genres.dart';
import 'package:feature_tmdb/content/api_config_movies.dart';
import 'package:feature_tmdb/content/api_config_series.dart';
import 'package:feature_tmdb/content/dropdown_menu.dart';
import 'package:feature_tmdb/content/movie_detail_section.dart';
import 'package:feature_tmdb/content/movie_watchlist_section.dart';
import 'package:feature_tmdb/content/person_detail_section.dart';
import 'package:feature_tmdb/content/search_section.dart';
import 'package:feature_tmdb/content/series_detail_section.dart';
import 'package:feature_tmdb/content/series_watchlist_section.dart';
import 'package:feature_tmdb/content/tmdb_list_layout.dart';
import 'package:feature_tmdb/content/tmdb_media_toggle_layout.dart';
import 'package:feature_tmdb/content/tmdb_single_item_layout.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/store/tmdb_search_store.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'tmdb',
  title: 'TMDB',
  description:
      'Uses the TMDB API to show details of movies with ability to favorite and add to watchlists',
  icon: Icons.movie_creation_outlined,
  init: () async {
    vyuh.di.register(TMDBClient(vyuh.env.get('TMDB_API_KEY')));
    vyuh.di.register(TMDBStore());
    vyuh.di.register(TmdbSearchStore());
  },
  routes: () async {
    const prefix = 'tmdb';

    final settings = await FetchSettingsByProvider.fetchByProvider(
      identifier: prefix,
      documentId: 'drafts.a9a1a05c-76a9-449b-bfe8-e970bcb5e8db',
    );

    if (settings == null) {
      vyuh.log?.w(
        'No Settings found. Please ensure you have a settings document with identifier "$prefix"',
      );
      return [];
    }

    return routes(settings);
  },
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        APIContentDescriptor(
          configurations: [
            ApiMovieConfigsSection.typeDescriptor,
            ApiConfigGenreSelection.typeDescriptor,
            ApiSeriesConfigsSection.typeDescriptor,
          ],
        ),
        RouteDescriptor(
          layouts: [
            TmdbMediaToggleLayout.typeDescriptor,
            TmdbSingleItemLayout.typeDescriptor,
            TmdbListLayout.typeDescriptor,
          ],
        ),
      ],
      contentBuilders: [
        MovieDetailSectionBuilder(),
        SeriesDetailSectionBuilder(),
        MovieWatchlistSectionBuilder(),
        SeriesWatchlistSectionBuilder(),
        PersonDetailsSectionBuilder(),
        SearchSectionBuilder(),
        DropDownContentBuilder(),
      ],
      actions: [
        AddToWatchlist.typeDescriptor,
        DropDownSelection.typeDescriptor,
      ],
    ),
  ],
);
