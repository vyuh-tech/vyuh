import { defineField, defineType } from 'sanity';
import { HiOutlineUserGroup as Icon } from 'react-icons/hi2';

export const conference = defineType({
  name: 'conf.conference',
  title: 'Conference',
  type: 'document',
  icon: Icon,
  fields: [
    defineField({
      name: 'identifier',
      title: 'Identifier',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'icon',
      title: 'Icon',
      type: 'image',
      validation: (Rule) => Rule.required(),
    }),
  ],
  preview: {
    select: {
      title: 'title',
      subtitle: 'identifier',
    },
  },
});
