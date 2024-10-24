import { defineField, defineType } from 'sanity';
import { FaCirclePlay as Icon } from 'react-icons/fa6';

export const moviesConfig = defineType({
  name: 'tmdb.movie.configsSection',
  title: 'TMDB API for Movies',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      options: {
        list: [
          { value: 'carousel', title: 'Carousel' },
          { value: 'listType', title: 'List' },
        ],
      },
    }),
    defineField({
      name: 'representation',
      title: 'Representation',
      type: 'string',
      initialValue: 'short',
      hidden: (context) => context.parent?.type === 'carousel',
      options: {
        list: [
          { value: 'short', title: 'Short List' },
          { value: 'long', title: 'Long List' },
        ],
      },
    }),
    defineField({
      name: 'resourceType',
      title: 'Resource Type',
      type: 'string',
      initialValue: 'popular',
      options: {
        list: [
          { value: 'popular', title: 'Popular Movies' },
          { value: 'topRated', title: 'Top Rated Movies' },
          { value: 'upcoming', title: 'Upcoming Movies' },
          { value: 'nowPlaying', title: 'Now Playing Movies' },
          {
            value: 'trending.day',
            title: 'Movies Trending Today',
          },
          {
            value: 'trending.week',
            title: 'Movies Trending this Week',
          },
          {
            value: 'bySelectedGenre',
            title: 'Movies by Selected Genre',
          },
          {
            value: 'bySelectedList',
            title: 'Movies by Selected List',
          },
        ],
      },
    }),
    defineField({
      name: 'itemCount',
      title: 'Item Count',
      type: 'number',
      initialValue: 5,
    }),
    defineField({
      name: 'showIndicator',
      title: 'Show Indicator',
      type: 'boolean',
    }),
  ],
  preview: {
    select: {
      type: 'type',
      resourceType: 'resourceType',
    },
    prepare({ type, resourceType }) {
      return {
        title: `Movies ${type}`,
        subtitle: `List Type - ${resourceType}`,
      };
    },
  },
});
