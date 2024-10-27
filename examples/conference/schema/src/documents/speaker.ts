// speaker schema
import { defineField, defineType } from 'sanity';
import { MdCoPresent as Icon } from 'react-icons/md';

export const speaker = defineType({
  name: 'conf.speaker',
  title: 'Speaker',
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
      name: 'bio',
      title: 'Bio',
      type: 'text',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'photo',
      title: 'Photo',
      type: 'image',
      validation: (Rule) => Rule.required(),
    }),
  ],
});
