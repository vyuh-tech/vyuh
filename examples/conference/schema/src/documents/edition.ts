import { defineField, defineType } from 'sanity';
import { HiCalendarDays as Icon } from 'react-icons/hi2';

export const edition = defineType({
  name: 'conf.edition',
  title: 'Edition',
  type: 'document',
  icon: Icon,
  fields: [
    defineField({
      name: 'conference',
      title: 'Conference',
      type: 'reference',
      to: [{ type: 'conf.conference' }],
      weak: true,
      validation: (Rule) => Rule.required(),
    }),
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
      name: 'tagline',
      title: 'Tagline',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'startDate',
      title: 'Start Date',
      type: 'datetime',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'endDate',
      title: 'End Date',
      type: 'datetime',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'url',
      title: 'Url',
      type: 'url',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'location',
      title: 'Location',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
  ],
});
