import { defineField, defineType } from 'sanity';
import { PiPlugsConnectedLight as Icon } from 'react-icons/pi';

export const liveCard = defineType({
  name: 'misc.card.live',
  type: 'object',
  title: 'Live Card',
  icon: Icon,
  fields: [
    defineField({
      name: 'includeDrafts',
      type: 'boolean',
      title: 'Include Drafts',
      description: 'Include draft documents',
      initialValue: false,
    }),
    defineField({
      name: 'document',
      type: 'reference',
      title: 'Document',
      to: [{ type: 'vyuh.document' }],
    }),
    defineField({
      name: 'size',
      type: 'string',
      title: 'Size',
      options: {
        list: [
          { title: 'Small', value: 'small' },
          { title: 'Medium', value: 'medium' },
          { title: 'Large', value: 'large' },
        ],
        layout: 'radio',
      },
      initialValue: 'medium',
    }),
  ],
  preview: {
    select: {
      docTitle: 'document.title',
      includeDrafts: 'includeDrafts',
    },
    prepare({ docTitle, includeDrafts }) {
      return {
        title: 'Live Card (with vyuh.document)',
        subtitle: `Document: ${docTitle} | Include Drafts: ${includeDrafts}`,
      };
    },
  },
});
