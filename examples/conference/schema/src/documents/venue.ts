import { defineField, defineType } from 'sanity';

export const venue = defineType({
  name: 'conf.venue',
  title: 'Venue',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'Conference Center',
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
          { title: 'Free WiFi', value: 'free-wifi' },
          { title: 'Paid WiFi', value: 'paid-wifi' },
          { title: 'Free Parking', value: 'free-parking' },
          { title: 'Paid Parking', value: 'paid-parking' },
          { title: 'Food Court', value: 'food-court' },
          { title: 'Cafeteria', value: 'cafeteria' },
          { title: 'Restaurant', value: 'restaurant' },
          { title: 'Coffee Shop', value: 'coffee-shop' },
          { title: 'Business Center', value: 'business-center' },
          { title: 'Fitness Center', value: 'fitness-center' },
          { title: 'Swimming Pool', value: 'swimming-pool' },
          { title: 'Spa', value: 'spa' },
          { title: 'ATM', value: 'atm' },
          { title: 'Currency Exchange', value: 'currency-exchange' },
          { title: 'Gift Shop', value: 'gift-shop' },
          { title: 'Laundry Service', value: 'laundry-service' },
          { title: 'Concierge', value: 'concierge' },
          { title: 'Valet Parking', value: 'valet-parking' },
          { title: 'Luggage Storage', value: 'luggage-storage' },
          { title: 'Room Service', value: 'room-service' },
          { title: 'First Aid', value: 'first-aid' },
          { title: 'Security', value: 'security' },
          { title: 'Coat Check', value: 'coat-check' },
          { title: 'Prayer Room', value: 'prayer-room' },
          { title: 'Lounge', value: 'lounge' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      title: 'title',
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
