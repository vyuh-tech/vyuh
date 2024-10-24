import { defineField, defineType } from 'sanity';
import { GoClock as Icon } from 'react-icons/go';

export const partOfDay = defineType({
  name: 'misc.condition.partOfDay',
  title: 'Part of Day',
  description:
    'Uses the following values: morning | afternoon | evening | night',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Part of Day',
    }),
  ],
  preview: {
    prepare(selection) {
      return {
        title: 'Part of Day',
        subtitle: 'morning | afternoon | evening | night',
      };
    },
  },
});
