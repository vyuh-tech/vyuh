import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { GiLevelFour as Icon } from 'react-icons/gi';

export const levelSection: SchemaTypeDefinition = defineType({
  name: 'puzzles.level.section',
  title: 'Puzzle Level Section',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
  ],
});
