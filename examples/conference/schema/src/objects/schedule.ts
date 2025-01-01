// schedule schema
import { defineField, defineType } from 'sanity';
import { IoTodayOutline as DayIcon } from 'react-icons/io5';
import { HiOutlinePause as BreakIcon } from 'react-icons/hi2';

export const scheduleDay = defineType({
  name: 'conf.schedule.day',
  title: 'Schedule Day',
  type: 'object',
  icon: DayIcon,
  fields: [
    defineField({
      name: 'startTime',
      title: 'Start Time',
      type: 'datetime',
      validation: (Rule) => Rule.required(),
      options: {
        dateFormat: 'YYYY-MMM-DD',
        timeFormat: 'HH:mm',
        timeStep: 15,
      },
    }),
    defineField({
      name: 'items',
      title: 'Items',
      type: 'array',
      of: [
        {
          type: 'reference',
          to: [{ type: 'conf.session' }],
        },
        { type: 'conf.schedule.break' }
      ],
    }),
  ],
  preview: {
    select: {
      startTime: 'startTime',
      items: 'items',
    },
    prepare({ startTime, items = [] }) {
      const date = new Date(startTime);
      return {
        title: date.toLocaleDateString('en-US', {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric',
        }),
        subtitle: `${items.length} items`,
        media: DayIcon,
      };
    },
  },
});

export const confBreak = defineType({
  name: 'conf.schedule.break',
  title: 'Break',
  type: 'object',
  icon: BreakIcon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
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
      duration: 'duration',
    },
    prepare({ title, duration }) {
      return {
        title,
        subtitle: `${duration} minutes`,
        media: BreakIcon,
      };
    },
  },
});
