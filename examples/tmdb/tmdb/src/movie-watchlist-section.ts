import { defineField, defineType } from 'sanity';
import { FaListOl as Icon } from 'react-icons/fa6';

export const movieWatchlistSection = defineType({
  name: 'tmdb.movie.watchlistSection',
  title: 'Movie Watchlist Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Movie Watchlist',
    }),
    ],
});
