import { defineField, defineType } from 'sanity';
import { PiPresentation as Icon } from 'react-icons/pi';

export const session = defineType({
  name: 'conf.session',
  title: 'Session',
  type: 'document',
  icon: Icon,
  fields: [
    defineField({
      name: 'edition',
      title: 'Edition',
      type: 'reference',
      to: [{ type: 'conf.edition' }],
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'speakers',
      title: 'Speakers',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'conf.speaker' }] }],
    }),
    defineField({
      name: 'tracks',
      title: 'Tracks',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'conf.track' }] }],
    }),
    defineField({
      name: 'duration',
      title: 'Duration (in minutes)',
      type: 'number',
      validation: (Rule) => Rule.required(),
    }),
  ],
  preview: {
    select: {
      title: 'title',
      speakers: 'speakers',
      track: 'tracks[0].name',
      duration: 'duration',
    },
    prepare({ title, speakers, track, duration }) {
      const speakerCount = speakers?.length || 0;
      return {
        title,
        subtitle: `${track ? `${track} - ` : ''}${speakerCount} speaker${speakerCount === 1 ? '' : 's'} (${duration} min)`,
      };
    },
  },
});
