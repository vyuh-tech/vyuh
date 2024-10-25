import { defineField, defineType } from 'sanity';
import { VscGithubAction as Icon } from 'react-icons/vsc';

export const hintActionText = defineType({
  name: 'auth.hintActionText',
  title: 'Hint Action',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'hint',
      title: 'Hint',
      description: 'Hint to be displayed to the user. Generally a question.',
      type: 'string',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'action',
      title: 'Action',
      description: 'Action to be performed if the hint is requested.',
      type: 'vyuh.action',
    }),
    defineField({
      name: 'alignment',
      title: 'Alignment',
      description: 'Alignment of the hint and the action within a given space.',
      type: 'string',
      initialValue: 'center',
      options: {
        layout: 'radio',
        list: [
          { title: 'Start', value: 'start' },
          { title: 'Center', value: 'center' },
          { title: 'End', value: 'end' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      hint: 'hint',
      action: 'action',
    },
    prepare(props) {
      return {
        title: `Hint Action Text (${props.hint ?? '---'})`,
        subtitle: props.action ? props.action.title : 'No action',
      };
    },
  },
});
