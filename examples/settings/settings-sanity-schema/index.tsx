import {
  BuiltContentSchemaBuilder,
  DefaultFieldsModifier,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { FaCog as Icon } from 'react-icons/fa';

const tabSchema: SchemaTypeDefinition = defineType({
  name: 'common.tab',
  title: 'Tab',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule: any) => Rule.required(),
    }),
    defineField({
      name: 'iconIdentifier',
      title: 'Icon Identifier',
      type: 'string',
      options: {
        list: [
          { title: 'Home', value: 'home' },
          { title: 'Categories', value: 'categories' },
          { title: 'Settings', value: 'settings' },
          { title: 'Account', value: 'account' },
          { title: 'Menu', value: 'menu' },
          { title: 'Search', value: 'search' },
          { title: 'Cart', value: 'cart' },
          { title: 'Notifications', value: 'notifications' },
          { title: 'Messages', value: 'messages' },
          { title: 'Plus', value: 'plus' },
          { title: 'Movies', value: 'movies' },
          { title: 'TV Series', value: 'series' },
          { title: 'Food', value: 'food' },
          { title: 'Watchlist', value: 'watchlist' },
        ],
      },
    }),
    defineField({
      name: 'path',
      title: 'Path',
      type: 'string',
      validation: (Rule: any) => Rule.required(),
    }),
  ],
});
export const settings = new FeatureDescriptor({
  name: 'common',
  title: 'Common Settings',
  contents: [],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(
      defineType({
        name: 'common.settings',
        title: 'Settings',
        type: 'document',
        icon: Icon,
        fields: [
          defineField({
            name: 'title',
            title: 'Title',
            type: 'string',
          }),
          defineField({
            name: 'identifier',
            title: 'Identifier',
            description: 'An identifier for usage in a query',
            type: 'string',
            validation: (Rule: any) => Rule.required(),
          }),
          defineField({
            name: 'tabs',
            title: 'Tabs',
            type: 'array',
            of: [tabSchema],
            validation: (Rule: any) => Rule.min(2),
          }),
        ],
      }),
    ),
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [{ type: 'common.settings' }],
    }),
  ],
});
