import { FeatureDescriptor } from '@vyuh/sanity-schema-core';
import { MdSearch as Icon } from 'react-icons/md';
import { defineField, defineType, SchemaTypeDefinition } from 'sanity';

export const searchSection = defineType({
  name: 'tmdb.search',
  title: 'Search',
  icon: Icon,
  type: 'object',
  fields: [
    defineField({
      name: 'loaderMessage',
      title: 'Loader Message',
      type: 'string',
    }),
    defineField({
      name: 'emptyMessage',
      title: 'Empty Message',
      type: 'string',
    }),
    defineField({
      name: 'emptyView',
      title: 'Empty View',
      type: 'vyuh.apiContent',
    }),
    defineField({
      name: 'searchTypes',
      title: 'Search Type',
      type: 'array',
      of: [{ type: 'string' }],
      options: {
        list: [
          { value: 'all', title: 'All' },
          { value: 'movies', title: 'Movies' },
          { value: 'series', title: 'Series' },
          { value: 'people', title: 'People' },
          { value: 'all', title: 'All' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      searchType: 'searchType',
    },
    prepare(props) {
      return {
        title: 'Search Section',
        subtitle: `${props.searchType.join(', ')}`,
      };
    },
  },
});
