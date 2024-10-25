import { defineType, SchemaTypeDefinition } from 'sanity';
import { GiLevelEndFlag as LevelIcon } from 'react-icons/gi';

export const puzzlesLevelLayout: SchemaTypeDefinition = defineType({
  name: 'puzzles.route.layout.level',
  title: 'Puzzles Level Layout',
  type: 'object',
  icon: LevelIcon,
  fields: [
    {
      name: 'title',
      title: 'Title',
      type: 'string',
      initialValue: 'Puzzles Level Layout',
      readOnly: true,
    },
  ],
  preview: {
    select: {
      title: 'title',
    },
    prepare(selection) {
      return {
        title: selection.title,
      };
    },
  },
});
