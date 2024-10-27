// schedule schema
import { defineField, defineType } from 'sanity';
import { BsTable as ScheduleIcon } from 'react-icons/bs';
import { IoTodayOutline as DayIcon } from 'react-icons/io5';
import { HiOutlinePause as BreakIcon } from 'react-icons/hi2';

export const schedule = defineType({
  name: 'conf.schedule',
  title: 'Schedule',
  type: 'document',
  icon: ScheduleIcon,
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'startDate',
      title: 'Start Date',
      type: 'date',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'days',
      title: 'Days',
      type: 'array',
      of: [{ type: 'conf.schedule.day' }],
    }),
  ],
});

export const scheduleDay = defineType({
  name: 'conf.schedule.day',
  title: 'Schedule Day',
  type: 'object',
  icon: DayIcon,
  fields: [
    defineField({
      name: 'date',
      title: 'Date',
      type: 'date',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'startTime',
      title: 'Start Time',
      type: 'datetime',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'sessions',
      title: 'Sessions',
      type: 'array',
      of: [
        {
          type: 'reference',
          to: [{ type: 'conf.session' }, { type: 'conf.schedule.break' }],
        },
      ],
    }),
  ],
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
});
