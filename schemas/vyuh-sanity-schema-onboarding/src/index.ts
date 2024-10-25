import {
  BuiltContentSchemaBuilder,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { RouteDescriptor } from '@vyuh/sanity-schema-system';
import { onboardingContent } from './onboarding-content';

export const onboarding = new FeatureDescriptor({
  name: 'onboarding',
  title: 'Onboarding',
  description: 'Schema for the Onboarding feature',
  contents: [
    new RouteDescriptor({
      regionItems: [{ type: onboardingContent.name }],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder({
      schema: onboardingContent,
      schemaType: onboardingContent.name,
    }),
  ],
});
