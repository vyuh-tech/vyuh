import { defineField, defineType } from 'sanity';
import { HiOutlineUserGroup as Icon } from 'react-icons/hi2';

export const conference = defineType({
  name: 'conference',
  title: 'Conference',
  type: 'document',
  icon: Icon,
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
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
});
