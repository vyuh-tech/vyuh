import { defineField, defineType } from 'sanity';
import { MdOutlineCategory as Icon } from 'react-icons/md';

export const track = defineType({
  name: 'conf.track',
  title: 'Track',
  type: 'document',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'slug',
      title: 'Slug',
      type: 'slug',
      validation: (Rule) => Rule.required(),
      options: {
        source: 'title',
        maxLength: 64,
      },
    }),
    defineField({
      name: 'icon',
      title: 'Icon',
      type: 'image',
    }),
  ],
  preview: {
    select: {
      title: 'title',
      slug: 'slug.current',
      media: 'icon',
    },
    prepare({ title, slug, media }) {
      return {
        title,
        subtitle: slug,
        media,
      };
    },
  },
});
