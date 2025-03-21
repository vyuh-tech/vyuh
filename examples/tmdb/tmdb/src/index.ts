import {
  BuiltContentSchemaBuilder,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import {
  APIContentDescriptor,
  RouteDescriptor,
} from '@vyuh/sanity-schema-system';
import { movieDetailSection } from './movie-section';
import { movieWatchlistSection } from './movie-watchlist-section.js';
import { seriesWatchlistSection } from './series-watchlist-section.js';
import { addToWatchlistAction } from './action/addToWatchlist';
import { personDetailSection } from './person-detail-section';
import { seriesDetailSection } from './series-section';
import { dropdownMenu } from './dropdown-menu';
import { dropDownChangeAction } from './action/drop-down-action';
import { searchSection } from './search-section';
import { tmdbMediaToggleLayout } from './tmdb-media-toggle-layout.js';
import { tmdbSingleItemLayout } from './tmdb-single-item-layout';
import { tmdbListlayout } from './tmdb-list-layout.js';
import { moviesConfig } from './api-config/movies-config';
import { seriesConfig } from './api-config/series-config';
import { genresConfig } from './api-config/genres-config';

export const tmdb = new FeatureDescriptor({
  name: 'tmdb',
  title: 'Tmdb Movies',
  description: 'Schema for the Tmdb feature',
  contents: [
    new RouteDescriptor({
      layouts: [tmdbSingleItemLayout, tmdbMediaToggleLayout, tmdbListlayout],
      regionItems: [
        {
          type: movieDetailSection.name,
        },
        {
          type: seriesDetailSection.name,
        },
        {
          type: movieWatchlistSection.name,
        },
        {
          type: seriesWatchlistSection.name,
        },
        {
          type: personDetailSection.name,
        },
        {
          type: searchSection.name,
        },
        {
          type: dropdownMenu.name,
        },
      ],
    }),
    new APIContentDescriptor({
      configurations: [moviesConfig, seriesConfig, genresConfig],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(movieDetailSection),
    new BuiltContentSchemaBuilder(seriesDetailSection),
    new BuiltContentSchemaBuilder(movieWatchlistSection),
    new BuiltContentSchemaBuilder(seriesWatchlistSection),
    new BuiltContentSchemaBuilder(personDetailSection),
    new BuiltContentSchemaBuilder(searchSection),
    new BuiltContentSchemaBuilder(dropdownMenu),
  ],
  actions: [addToWatchlistAction, dropDownChangeAction],
});
