import { defineField, defineType } from 'sanity';

export const venue = defineType({
  name: 'conf.venue',
  title: 'Venue',
  type: 'document',
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'Conference Center',
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
      options: {
        hotspot: true,
      },
    }),
    defineField({
      name: 'rooms',
      title: 'Rooms',
      type: 'array',
      of: [{ type: 'conf.room' }],
    }),
    defineField({
      name: 'address',
      title: 'Address',
      type: 'object',
      fields: [
        {
          name: 'street',
          title: 'Street',
          type: 'string',
          validation: (Rule) => Rule.required(),
        },
        {
          name: 'city',
          title: 'City',
          type: 'string',
          validation: (Rule) => Rule.required(),
        },
        {
          name: 'state',
          title: 'State',
          type: 'string',
          validation: (Rule) => Rule.required(),
        },
        {
          name: 'country',
          title: 'Country',
          type: 'string',
          validation: (Rule) => Rule.required(),
        },
        {
          name: 'postalCode',
          title: 'Postal Code',
          type: 'string',
          validation: (Rule) => Rule.required(),
        },
      ],
      options: {
        collapsible: true,
        collapsed: true,
      },
    }),
    defineField({
      name: 'coordinates',
      title: 'Coordinates',
      type: 'object',
      fields: [
        {
          name: 'latitude',
          title: 'Latitude',
          type: 'number',
          validation: (Rule) => Rule.required(),
        },
        {
          name: 'longitude',
          title: 'Longitude',
          type: 'number',
          validation: (Rule) => Rule.required(),
        },
      ],
      options: {
        columns: 2,
      },
    }),
    defineField({
      name: 'website',
      title: 'Website',
      type: 'url',
    }),
    defineField({
      name: 'phone',
      title: 'Phone',
      type: 'string',
    }),
    defineField({
      name: 'email',
      title: 'Email',
      type: 'string',
    }),
    defineField({
      name: 'amenities',
      title: 'Amenities',
      type: 'array',
      of: [{ type: 'string' }],
      options: {
        list: [
          { title: 'Free Parking', value: 'parking' },
          { title: 'Restaurant', value: 'restaurant' },
          { title: 'Cafe', value: 'cafe' },
          { title: 'Business Center', value: 'business' },
          { title: 'First Aid', value: 'firstaid' },
          { title: 'Security', value: 'security' },
          { title: 'Coat Check', value: 'coatcheck' },
          { title: 'Prayer Room', value: 'prayer' },
          { title: 'Lounge', value: 'lounge' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      title: 'name',
      city: 'address.city',
      state: 'address.state',
      rooms: 'rooms',
    },
    prepare({ title, city, state, rooms }) {
      const roomCount = (rooms || []).length;
      return {
        title,
        subtitle: `${city}, ${state} - ${roomCount} room${roomCount === 1 ? '' : 's'}`,
      };
    },
  },
});
