import { defineField, defineType } from 'sanity';
import { FaListOl as Icon } from 'react-icons/fa6';

export const seriesWatchlistSection = defineType({
  name: 'tmdb.series.watchlistSection',
  title: 'Series Watchlist Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Series Watchlist',
    }),
    ],
});
