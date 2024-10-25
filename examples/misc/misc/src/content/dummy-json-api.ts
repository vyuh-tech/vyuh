import { defineField, defineType } from 'sanity';
import { GiTargetDummy as Icon } from 'react-icons/gi';

export const dummyJsonApi = defineType({
  name: 'misc.apiContent.dummyJson',
  type: 'object',
  title: 'Dummy JSON API',
  icon: Icon,
  fieldsets: [
    {
      title: 'Query Parameters',
      name: 'queryParameters',
      options: { columns: 2 },
    },
  ],
  fields: [
    defineField({
      name: 'type',
      title: 'API Type',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'products',
      options: {
        list: [
          { title: 'Products', value: 'products' },
          { title: 'Search', value: 'search' },
        ],
      },
    }),
    defineField({
      name: 'searchText',
      title: 'Search Text',
      description: 'Text to search for in the API, when the type is "search"',
      type: 'string',
      fieldset: 'queryParameters',
    }),
    defineField({
      name: 'limit',
      title: 'Limit',
      description: 'Number of items to fetch from the API',
      type: 'number',
      validation: (Rule) => Rule.min(1).max(50),
      initialValue: 10,
      fieldset: 'queryParameters',
    }),
    defineField({
      name: 'skip',
      title: 'Skip',
      description: 'Number of items to skip from the API',
      type: 'number',
      validation: (Rule) => Rule.min(0),
      initialValue: 0,
      fieldset: 'queryParameters',
    }),
  ],
  preview: {
    select: {
      type: 'type',
      limit: 'limit',
      skip: 'skip',
      searchText: 'searchText',
    },
    prepare({ type, limit, skip, searchText }) {
      const parameters: any = {
        Limit: limit,
        Skip: skip,
        'Search Text': type === 'search' ? searchText : undefined,
      };

      const paramsString = Object.keys(parameters)
        .filter((key) => parameters[key] !== undefined)
        .map((x) => `${x}: ${parameters[x]}`)
        .join(' | ');

      return {
        title: `DummyJSON API (${type})`,
        subtitle: paramsString,
      };
    },
  },
});
