import { defineField, defineType } from 'sanity';
import { wonder } from './wonder';

export const wonderQuery = defineType({
  name: `${wonder.name}.query`,
  title: 'Wonder Query',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Wonder Query with identifier',
    }),
  ],
});

export const wonderListQuery = defineType({
  name: `${wonder.name}.query.list`,
  title: 'Wonder List Query',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'List of Wonders',
    }),
  ],
});
