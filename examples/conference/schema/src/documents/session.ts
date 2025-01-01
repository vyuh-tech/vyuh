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
    defineField({
      name: 'format',
      title: 'Format',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'talk',
      options: {
        list: [
          { title: 'Intro', value: 'intro' },
          { title: 'Keynote', value: 'keynote' },
          { title: 'Talk', value: 'talk' },
          { title: 'Workshop', value: 'workshop' },
          { title: 'Panel', value: 'panel' },
          { title: 'Lightning Talk', value: 'lightning' },
          { title: 'Breakout', value: 'breakout' },
          { title: 'Networking', value: 'networking' },
          { title: 'Outro', value: 'outro' },
        ],
      },
    }),
    defineField({
      name: 'level',
      title: 'Level',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'all',
      options: {
        list: [
          { title: 'Beginner', value: 'beginner' },
          { title: 'Intermediate', value: 'intermediate' },
          { title: 'Advanced', value: 'advanced' },
          { title: 'All Levels', value: 'all' },
        ],
      },
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
        subtitle: `${track ? `${track} - ` : ''} ${speakerCount} speaker${speakerCount === 1 ? '' : 's'} (${duration} min)`,
      };
    },
  },
});
