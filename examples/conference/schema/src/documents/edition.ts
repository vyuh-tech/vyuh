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
    defineField({
      name: 'sponsors',
      title: 'Sponsors',
      type: 'array',
      of: [
        {
          type: 'object',
          fields: [
            defineField({
              name: 'sponsor',
              title: 'Sponsor',
              type: 'reference',
              to: [{ type: 'conf.sponsor' }],
              validation: (Rule) => Rule.required(),
            }),
            defineField({
              name: 'level',
              title: 'Level',
              description: 'Sponsorship Level',
              type: 'string',
              validation: (Rule) => Rule.required(),
              options: {
                list: [
                  { title: 'Platinum', value: 'platinum' },
                  { title: 'Gold', value: 'gold' },
                  { title: 'Silver', value: 'silver' },
                  { title: 'Bronze', value: 'bronze' },
                ],
              },
            }),
          ],
        },
      ],
    }),
  ],
  preview: {
    select: {
      title: 'title',
      subtitle: 'tagline',
      conference: 'conference.name',
      startDate: 'startDate',
    },
    prepare({ title, subtitle, conference, startDate }) {
      return {
        title: `${conference} - ${title}`,
        subtitle: `${subtitle} (${new Date(startDate).getFullYear()})`,
      };
    },
  },
});
