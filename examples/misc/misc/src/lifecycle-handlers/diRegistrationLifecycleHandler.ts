import { defineField, defineType } from 'sanity';
import { FaCode as Icon } from 'react-icons/fa6';

export const diRegistrationLifecycleHandler = defineType({
  name: 'misc.lifecycleHandler.diRegistration',
  title: 'DI Registration',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      readOnly: true,
      initialValue: 'Test DI Registration',
    }),
    // delay field
  ],
});
