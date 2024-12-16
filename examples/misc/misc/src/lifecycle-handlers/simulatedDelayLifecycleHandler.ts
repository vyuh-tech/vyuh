import { defineField, defineType } from 'sanity';
import { FaClock as Icon } from 'react-icons/fa6';

export const simulatedDelayLifecycleHandler = defineType({
  name: 'misc.lifecycleHandler.simulatedDelay',
  title: 'Simulated Delay',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Simulated Delay',
    }),
    // delay field
    defineField({
      name: 'delay',
      title: 'Delay in seconds',
      description: 'Delay in seconds that will be simulated on the Client',
      type: 'number',
      initialValue: 1,
      validation: (Rule) => Rule.min(0).max(10),
    }),
  ],
  preview: {
    select: {
      title: 'title',
      delay: 'delay',
    },
    prepare({ title, delay }) {
      return {
        title,
        subtitle: `Delay: ${delay ?? 0}s`,
      };
    },
  },
});
