import { defineField, defineType } from 'sanity';
import { MdOutlinePlaylistAdd as WatchlistIcon } from 'react-icons/md';

export const addToWatchlistAction = defineType({
  name: 'tmdb.action.addToWatchlist',
  title: 'Add to Watchlist',
  type: 'object',
  icon: WatchlistIcon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Add to Watchlist',
    }),
  ],
});
