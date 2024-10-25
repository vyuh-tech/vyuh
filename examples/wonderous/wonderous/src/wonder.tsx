import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { GiCastle as Icon } from 'react-icons/gi';
import { FaRegCalendarPlus as EventIcon } from 'react-icons/fa6';

export const wonderQuote: SchemaTypeDefinition = defineType({
  type: 'object',
  name: 'wonderous.quote',
  title: 'Quote',
  options: {
    columns: 2,
  },
  fields: [
    defineField({
      name: 'text',
      title: 'Text',
      type: 'string',
    }),
    defineField({
      name: 'author',
      title: 'Author',
      type: 'string',
    }),
  ],
});

export const wonderEvent: SchemaTypeDefinition = defineType({
  type: 'object',
  name: 'wonderous.event',
  title: 'Event',
  icon: EventIcon,
  options: {
    columns: 2,
  },
  fields: [
    defineField({
      name: 'year',
      title: 'Year',
      description: 'Year of the event. Years in BCE should be negative.',
      type: 'number',
    }),
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
  ],
  preview: {
    select: {
      title: 'title',
      year: 'year',
    },
    prepare({ title, year }) {
      return {
        title: year,
        subtitle: title,
      };
    },
  },
});

export const wonder: SchemaTypeDefinition = defineType({
  name: 'wonderous.wonder',
  type: 'document',
  title: 'Wonder',
  icon: Icon,
  fieldsets: [
    {
      name: 'timeframe',
      title: 'Timeframe',
      options: {
        columns: 2,
      },
    },
  ],
  fields: [
    defineField({
      name: 'identifier',
      title: 'Identifier',
      type: 'string',
    }),
    defineField({
      name: 'hexColor',
      title: 'Hex Color',
      description: (
        <div>
          The primary color of the wonder, expressed in hexadecimal format(
          <code>AARRGGBB</code>). Example: <code>FFFF0000</code> for red (
          <span
            style={{
              display: 'inline-block',
              width: '1rem',
              height: '1rem',
              backgroundColor: '#FF0000',
            }}
          ></span>
          ).
        </div>
      ),
      type: 'string',
    }),
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'subtitle',
      title: 'Subtitle',
      type: 'string',
    }),
    defineField({
      name: 'location',
      title: 'Location',
      type: 'object',
      fieldsets: [
        {
          name: 'geo',
          title: 'Geo Location',
          options: {
            columns: 2,
          },
        },
      ],
      fields: [
        defineField({
          name: 'place',
          title: 'Place',
          type: 'string',
        }),
        defineField({
          name: 'latitude',
          title: 'Latitude',
          type: 'number',
          fieldset: 'geo',
        }),
        defineField({
          name: 'longitude',
          title: 'Longitude',
          type: 'number',
          fieldset: 'geo',
        }),
        defineField({
          name: 'caption',
          title: 'Map Caption',
          type: 'string',
        }),
      ],
    }),
    defineField({
      name: 'video',
      title: 'YouTube Video',
      type: 'object',
      options: {
        columns: 2,
      },
      fields: [
        defineField({
          name: 'videoId',
          title: 'Video Id',
          type: 'string',
        }),
        defineField({
          name: 'caption',
          title: 'Caption',
          type: 'string',
        }),
      ],
    }),
    defineField({
      name: 'startYear',
      title: 'Start Year',
      description:
        'The year when construction started. Years in BCE should be negative.',
      type: 'number',
      fieldset: 'timeframe',
    }),
    defineField({
      name: 'endYear',
      title: 'End Year',
      description:
        'The year when construction ended. Years in BCE should be negative.',
      type: 'number',
      fieldset: 'timeframe',
    }),
    defineField({
      name: 'unsplashCollectionId',
      title: 'Unsplash Collection Id',
      type: 'string',
    }),
    defineField({
      name: 'icon',
      title: 'Icon Image',
      type: 'image',
    }),
    defineField({
      name: 'image',
      title: 'Wonder Image',
      type: 'image',
    }),
    defineField({
      name: 'backdropImage',
      title: 'Backdrop Image',
      type: 'image',
    }),
    defineField({
      name: 'primaryQuote',
      title: 'Primary Quote',
      type: 'wonderous.quote',
    }),
    defineField({
      name: 'secondaryQuote',
      title: 'Secondary Quote',
      type: 'wonderous.quote',
    }),
    defineField({
      name: 'history',
      title: 'History',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'construction',
      title: 'Construction',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'locationInfo',
      title: 'Location Info',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'events',
      title: 'Events',
      type: 'array',
      of: [{ type: 'wonderous.event' }],
    }),
  ],
  preview: {
    select: {
      title: 'title',
      subtitle: 'subtitle',
      media: 'icon',
    },
    prepare({ title, subtitle, media }) {
      return {
        title,
        subtitle,
        media,
      };
    },
  },
});
