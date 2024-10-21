import { FeatureDescriptor } from '@vyuh/sanity-schema-core';
import { RouteDescriptor } from '@vyuh/sanity-schema-system';
import {SimpleContentDescriptor, SimpleContentSchemaBuilder} from './simple-content';

export const {{ name.camelCase() }} = new FeatureDescriptor({
  name: '{{ name.camelCase() }}',
  title: '{{ name.titleCase() }}',
  description: 'Schema for the {{ name.titleCase() }} feature',
  contents: [
    new RouteDescriptor({
      regionItems: [{ type: SimpleContentDescriptor.schemaName }],
    }),
  ],
  contentSchemaBuilders: [new SimpleContentSchemaBuilder()],
});
