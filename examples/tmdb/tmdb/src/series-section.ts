import { defineField, defineType } from 'sanity';
import { MdOutlineMovieFilter as Icon } from 'react-icons/md';

export const seriesDetailSection = defineType({
  name: 'tmdb.series.detailSection',
  title: 'Series Detail Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'representation',
      title: 'Representation',
      type: 'string',
      initialValue: 'short',
      options: {
        list: [
          { value: 'short', title: 'Short List' },
          { value: 'long', title: 'Long List' },
        ],
      },
    }),
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      options: {
        list: [
          { value: 'hero', title: 'Hero' },
          { value: 'cast', title: 'Cast' },
          { value: 'crew', title: 'Crew' },
          { value: 'statistics', title: 'Statistics' },
          { value: 'gallery', title: 'Image Gallery' },
          { value: 'recommendations', title: 'Recommendations' },
          { value: 'reviews', title: 'Reviews' },
          { value: 'footer', title: 'Footer' },
          { value: 'trailer', title: 'Trailer' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      type: 'type',
    },
    prepare({ type }) {
      return {
        title: 'Series Detail Section',
        subtitle: type,
      };
    },
  },
});
