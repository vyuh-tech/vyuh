import {
  BuiltContentSchemaBuilder,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { RouteDescriptor } from '@vyuh/sanity-schema-system';
import { menuItem, foodItemContent, selectItemAction } from './menu-item';

export const food = new FeatureDescriptor({
  name: 'food',
  title: 'Food',
  description: 'Schema for the Food feature',
  contents: [
    new RouteDescriptor({
      regionItems: [
        {
          type: foodItemContent.name,
        },
      ],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(menuItem),
    new BuiltContentSchemaBuilder(foodItemContent),
  ],
  actions: [selectItemAction],
});
