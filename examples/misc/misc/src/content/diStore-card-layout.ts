import { defineField, defineType } from 'sanity';
import { FaCode as Icon } from 'react-icons/fa6';

export const diStoreCardLayout = defineType({
  name: 'misc.card.layout.diStore',
  title: 'DI Store',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      type: 'string',
      title: 'Title',
      readOnly: true,
      initialValue: 'Card Layout for Scoped DI Store',
    }),
  ],
});
