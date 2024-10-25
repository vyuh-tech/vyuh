import { defineType } from 'sanity';
import { FaCirclePlay as Icon } from 'react-icons/fa6';

export const genresConfig = defineType({
  name: 'tmdb.apiConfig.genres',
  title: 'TMDB API for Genres (Movies/Series)',
  type: 'object',
  icon: Icon,
  fields: [
    {
      name: 'title',
      title: 'Title',
      type: 'string',
      initialValue: 'Movie/Series Genres',
    },
    {
      name: 'allowModeToggle',
      title: 'Allow Mode Toggle',
      type: 'boolean',
      initialValue: false,
    },
    {
      name: 'action',
      title: 'Action',
      type: 'vyuh.action',
    },
  ],
});
