import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { IoIosRocket as Icon } from 'react-icons/io';

const step: SchemaTypeDefinition = defineType({
  name: 'vyuh.content.onboarding.step',
  title: 'Step',
  type: 'object',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
  ],
});

export const onboardingContent: SchemaTypeDefinition = defineType({
  name: 'vyuh.content.onboarding',
  title: 'Onboarding Content',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      initialValue: 'Onboarding',
      description: `It is better to have this as the only content item in your region. 
        It works well with the "Single Item" layout for the route.`,
      type: 'string',
      readOnly: true,
    }),
    defineField({
      name: 'steps',
      title: 'Steps',
      type: 'array',
      // @ts-ignore
      of: [step],
      validation: (Rule: any) =>
        Rule.required().min(2).error('At least 2 steps are required.'),
    }),
    defineField({
      name: 'doneAction',
      title: 'Done Action',
      type: 'vyuh.action',
    }),
  ],
  preview: {
    select: {
      steps: 'steps',
    },
    prepare(selection: any) {
      return {
        title: 'Onboarding Steps',
        subtitle: `Count: ${selection.steps.length}`,
      };
    },
  },
});
