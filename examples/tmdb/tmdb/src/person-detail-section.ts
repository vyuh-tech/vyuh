import { defineField, defineType } from 'sanity';
import { MdPerson as Icon } from 'react-icons/md';

export const personDetailSection = defineType({
  name: 'tmdb.person.detailSection',
  title: 'Person Detail Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      options: {
        list: [
          { value: 'hero', title: 'Hero' },
          { value: 'personalInfo', title: 'Personal Info' },
          { value: 'biography', title: 'Biography' },
          { value: 'movieCredits', title: 'Movie Credits' },
          { value: 'tvCredits', title: 'TV Credits' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      type: 'type',
    },
    prepare({ type }) {
      return {
        title: 'Person Detail Section',
        subtitle: type,
      };
    },
  },
});
