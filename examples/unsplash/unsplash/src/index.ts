import { FeatureDescriptor } from '@vyuh/sanity-schema-core';
import { RouteDescriptor } from '@vyuh/sanity-schema-system';
import {SimpleContentDescriptor, SimpleContentSchemaBuilder} from './simple-content';

export const unsplash = new FeatureDescriptor({
  name: 'unsplash',
  title: 'Unsplash',
  description: 'Schema for the Unsplash feature',
  contents: [
    new RouteDescriptor({
      regionItems: [{ type: SimpleContentDescriptor.schemaName }],
    }),
  ],
  contentSchemaBuilders: [new SimpleContentSchemaBuilder()],
});
