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
      name: 'tagline',
      title: 'Tagline',
      type: 'string',
      description: 'A short description, like "Flutter GDE" or "Staff Engineer at Google"',
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
      options: {
        hotspot: true,
      },
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'social',
      title: 'Social',
      type: 'object',
      options: {
        collapsible: true,
        collapsed: true,
      },
      fields: [
        {
          name: 'twitter',
          title: 'Twitter',
          type: 'string',
          description: 'Twitter handle (without @)',
        },
        {
          name: 'github',
          title: 'GitHub',
          type: 'string',
          description: 'GitHub username',
        },
        {
          name: 'linkedin',
          title: 'LinkedIn',
          type: 'string',
          description: 'LinkedIn username',
        },
        {
          name: 'website',
          title: 'Website',
          type: 'url',
        },
      ],
    }),
  ],
  preview: {
    select: {
      title: 'name',
      tagline: 'tagline',
      media: 'photo',
    },
    prepare({ title, tagline, media }) {
      return {
        title,
        subtitle: tagline,
        media,
      };
    },
  },
});
