import { defineField, defineType } from 'sanity';
import { HiCalendarDays as Icon } from 'react-icons/hi2';

export const track = defineType({
  name: 'conf.track',
  title: 'Track',
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
      name: 'icon',
      title: 'Icon',
      type: 'image',
    }),
  ],
});
