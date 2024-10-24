import { defineField, defineType } from 'sanity';
import { GiLevelEndFlag as LevelIcon } from 'react-icons/gi';
import { puzzleLevel } from './puzzle';

export const selectLevelAction = defineType({
  name: 'puzzles.action.selectLevel',
  title: 'Select Level',
  type: 'object',
  icon: LevelIcon,
  fields: [
    defineField({
      name: 'puzzleLevel',
      title: 'Puzzle Level',
      type: 'reference',
      weak: true,
      to: [{ type: puzzleLevel.name }],
    }),
  ],
  preview: {
    select: {
      level: 'puzzleLevel',
    },
    prepare({ level }) {
      return {
        title: `Select Level`,
        subtitle: level.title,
        media: level.image,
      };
    },
  },
});
