import {
  BuiltContentSchemaBuilder,
  DefaultFieldsModifier,
  defaultLayoutConfiguration,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { partOfDay } from './condition/part-of-day.ts';
import {
  APIContentDescriptor,
  CardDescriptor,
  DocumentDescriptor,
  RouteDescriptor,
} from '@vyuh/sanity-schema-system';
import { dummyJsonApi } from './content/dummy-json-api.ts';
import {
  ProductCardContentBuilder,
  ProductCardDescriptor,
  productCardMiniViewLayout,
} from './content/product-card.ts';
import {
  missingAction,
  missingCardLayout,
  missingCondition,
  missingContent,
  missingRouteLayout,
} from './content/missing.ts';
import { showBarcode } from './action/show-barcode.ts';
import { simulatedDelayLifecycleHandler } from './lifecycle-handlers/simulatedDelayLifecycleHandler.ts';
import { diRegistrationLifecycleHandler } from './lifecycle-handlers/diRegistrationLifecycleHandler.ts';
import { diStoreCardLayout } from './content/diStore-card-layout.ts';
import { liveCard } from './content/live-card.ts';
import { scoreCard } from './content/score-card.ts';

export const misc = new FeatureDescriptor({
  name: 'misc',
  title: 'Miscellaneous',
  description:
    'The Miscellaneous feature contains a variety of custom content types, conditions, actions, layouts to demonstrate the capabilities of the Vyuh Framework.',
  conditions: [partOfDay, missingCondition],
  actions: [showBarcode, missingAction],
  contents: [
    new RouteDescriptor({
      regionItems: [
        { type: ProductCardDescriptor.schemaType },
        { type: missingContent.name },
        { type: liveCard.name },
      ],
      layouts: [missingRouteLayout],
      lifecycleHandlers: [
        simulatedDelayLifecycleHandler,
        diRegistrationLifecycleHandler,
      ],
    }),
    new DocumentDescriptor({
      items: [{ type: scoreCard.name }],
    }),
    new CardDescriptor({
      layouts: [missingCardLayout, diStoreCardLayout],
    }),
    new APIContentDescriptor({
      configurations: [dummyJsonApi],
    }),
    new ProductCardDescriptor({
      layouts: [
        defaultLayoutConfiguration(
          `${ProductCardDescriptor.schemaType}.layout.default`,
        ),
        productCardMiniViewLayout,
      ],
    }),
  ],
  contentSchemaBuilders: [
    new ProductCardContentBuilder(),
    new BuiltContentSchemaBuilder(missingContent),
    new BuiltContentSchemaBuilder(liveCard),
    new BuiltContentSchemaBuilder(scoreCard),
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [{ type: scoreCard.name }],
    }),
  ],
});
