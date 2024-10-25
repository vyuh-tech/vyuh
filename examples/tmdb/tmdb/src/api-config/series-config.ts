import { defineField, defineType } from 'sanity';
import { FaCirclePlay as Icon } from 'react-icons/fa6';

export const seriesConfig = defineType({
  name: 'tmdb.series.configsSection',
  title: 'TMDB APIs for Series',
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
          { value: 'popular', title: 'Popular Series' },
          { value: 'topRated', title: 'Top Rated Series' },
          { value: 'airingToday', title: 'Airing Today Series' },
          {
            value: 'trending.day',
            title: 'Trending Series Today',
          },
          {
            value: 'trending.week',
            title: 'Trending Series This Week',
          },
          {
            value: 'bySelectedGenre',
            title: 'Series by Selected Genre',
          },
          {
            value: 'bySelectedList',
            title: 'Series by Selected List',
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
        title: `Series ${type}`,
        subtitle: `List Type - ${resourceType}`,
      };
    },
  },
});
