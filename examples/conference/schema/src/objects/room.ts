import { defineField, defineType } from 'sanity';

export const room = defineType({
  name: 'conf.room',
  title: 'Room',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'Room',
    }),
    defineField({
      name: 'slug',
      title: 'Slug',
      type: 'slug',
      validation: (Rule) => Rule.required(),
      options: {
        source: (doc, options) => {
          // @ts-ignore
          return options.parent.title || '';
        }, // eslint-disable-line no-unused-vars
        maxLength: 64,
      },
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
    }),
    defineField({
      name: 'capacity',
      title: 'Capacity',
      type: 'number',
      validation: (Rule) => Rule.required().min(1),
      initialValue: 50,
    }),
    defineField({
      name: 'floor',
      title: 'Floor',
      type: 'number',
      validation: (Rule) => Rule.required(),
      initialValue: 1,
    }),
    defineField({
      name: 'facilities',
      title: 'Facilities',
      type: 'array',
      of: [{ type: 'string' }],
      options: {
        list: [
          { title: 'Audio System', value: 'audio' },
          { title: 'Video Projector', value: 'projector' },
          { title: 'Whiteboard', value: 'whiteboard' },
          { title: 'Internet/WiFi', value: 'wifi' },
          { title: 'Video Recording', value: 'recording' },
          { title: 'Live Streaming', value: 'streaming' },
          { title: 'Wheelchair Accessible', value: 'accessible' },
          { title: 'Power Outlets', value: 'power' },
          { title: 'Air Conditioning', value: 'ac' },
        ],
      },
    }),
  ],
});
