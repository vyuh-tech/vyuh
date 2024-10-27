import {
  BuiltContentSchemaBuilder,
  DefaultFieldsModifier,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import {
  DocumentDescriptor,
  DocumentListDescriptor,
  DocumentSectionDescriptor,
  GroupDescriptor,
} from '@vyuh/sanity-schema-system';
import { wonder, wonderEvent, wonderQuote } from './wonder';
import { wonderSection } from './section';
import { pageViewGroupLayout } from './page-view-group-layout';
import { wonderListQuery, wonderQuery } from './query-configurations';
import { defineField, defineType } from 'sanity';

export const wonderous = new FeatureDescriptor({
  name: 'wonderous',
  title: 'Wonderous',
  description: 'Schema for the Wonderous feature',
  contents: [
    new GroupDescriptor({
      layouts: [pageViewGroupLayout],
    }),
    new DocumentDescriptor({
      documentTypes: [
        {
          type: wonder.name,
        },
      ],
      queryConfigurations: [wonderQuery],
    }),
    new DocumentSectionDescriptor({
      configurations: [wonderSection],
    }),
    new DocumentListDescriptor({
      queryConfigurations: [wonderListQuery],
      listItemConfigurations: [
        defineType({
          name: `${wonder.name}.listItem`,
          title: 'Wonder List Item',
          type: 'object',
          fields: [
            defineField({
              name: 'title',
              title: 'Title',
              type: 'string',
              readOnly: true,
              initialValue: 'Wonder List Item',
            }),
          ],
        }),
      ],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(wonderQuote),
    new BuiltContentSchemaBuilder(wonderEvent),
    new BuiltContentSchemaBuilder(wonder),
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [
        { type: wonderQuote.name },
        { type: wonderEvent.name },
        { type: wonderSection.name },
      ],
    }),
  ],
});
