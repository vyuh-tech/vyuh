import { defineType } from 'sanity';
import { CiCircleQuestion as Icon } from 'react-icons/ci';

export const missingContent = createMissingConfiguration(
  'misc.content.missing',
  'Missing Content',
);

export const missingCardLayout = createMissingConfiguration(
  'misc.card.layout.missing',
  'Missing Card Layout',
);

export const missingRouteLayout = createMissingConfiguration(
  'misc.route.layout.missing',
  'Missing Route Layout',
);

export const missingCondition = createMissingConfiguration(
  'misc.condition.missing',
  'Missing Condition',
);

export const missingAction = createMissingConfiguration(
  'misc.action.missing',
  'Missing Action',
);

function createMissingConfiguration(schemaType: string, title: string) {
  return defineType({
    name: schemaType,
    type: 'object',
    title,
    icon: Icon,
    fields: [
      {
        name: 'title',
        type: 'string',
        title: 'Title',
        readOnly: true,
        initialValue: title,
      },
    ],
    preview: {
      select: {
        title: 'title',
      },
      prepare({ title }) {
        return {
          title,
          subtitle: schemaType,
        };
      },
    },
  });
}
