import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { TbSection as Icon } from 'react-icons/tb';

export const wonderSection: SchemaTypeDefinition = defineType({
  name: 'wonderous.wonder.section',
  title: 'Wonder Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      options: {
        list: [
          { title: 'Hero', value: 'hero' },
          { title: 'Facts & History', value: 'history' },
          { title: 'Construction', value: 'construction' },
          { title: 'Location Info', value: 'locationInfo' },
          { title: 'Events', value: 'events' },
          { title: 'Photos', value: 'photos' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      title: 'title',
      type: 'type',
    },
    prepare(selection) {
      return {
        title: `Wonder Section (${selection.title ?? '---'})`,
        subtitle: `Type: ${selection.type ?? '---'}`,
      };
    },
  },
});
