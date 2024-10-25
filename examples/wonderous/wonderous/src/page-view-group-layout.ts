import { defineField, defineType, SchemaTypeDefinition } from 'sanity';

export const pageViewGroupLayout: SchemaTypeDefinition = defineType({
  name: 'vyuh.group.layout.pageView',
  title: 'Page View',
  type: 'object',
  fields: [
    defineField({
      name: 'showIndicator',
      title: 'Show Page Indicator',
      type: 'boolean',
    }),
    defineField({
      name: 'viewportFraction',
      title: 'Viewport Fraction',
      description: 'Max width of an item, as a fraction of the Viewport Width',
      type: 'number',
      options: {
        list: [
          { title: '0.5', value: 0.5 },
          { title: '0.75', value: 0.75 },
          { title: '0.9', value: 0.9 },
          { title: '1.0', value: 1.0 },
        ],
      },
    }),
  ],
  preview: {
    select: {
      showIndicator: 'showIndicator',
      viewportFraction: 'showIndicator',
    },
    prepare(selection) {
      return {
        title: 'Page View',
        subtitle: `Indicator : ${selection.showIndicator ? 'Yes' : 'No'} | Viewport Fraction : ${selection.viewportFraction}`,
      };
    },
  },
});
