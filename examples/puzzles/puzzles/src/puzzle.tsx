import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import {
  GiLevelEndFlag as LevelIcon,
  GiOverkill as KillIcon,
} from 'react-icons/gi';

export const character: SchemaTypeDefinition = defineType({
  type: 'object',
  name: 'puzzles.character',
  title: 'Character',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
    defineField({
      name: 'canSail',
      title: 'Can Sail',
      type: 'boolean',
      initialValue: true,
    }),
  ],
});

export const killCondition: SchemaTypeDefinition = defineType({
  type: 'object',
  name: 'puzzles.killCondition',
  title: 'Kill Condition',
  icon: KillIcon,
  fields: [
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      options: {
        list: [
          { title: 'Absent', value: 'absent' },
          { title: 'Greater', value: 'greater' },
        ],
      },
    }),
    defineField({
      name: 'witness',
      title: 'Witness',
      type: 'string',
    }),
    defineField({
      name: 'killer',
      title: 'Killer',
      type: 'string',
    }),
    defineField({
      name: 'victim',
      title: 'Victim',
      type: 'string',
    }),
  ],
  preview: {
    select: {
      type: 'type',
      killer: 'killer',
      victim: 'victim',
      witness: 'witness',
      icon: 'icon',
    },
    prepare(killCondition) {
      const { type, killer, victim, witness, icon } = killCondition;
      if (type === 'absent') {
        return {
          title: `${witness} is absent`,
          subtitle: `${killer} kill ${victim}`,
          media: icon,
        };
      } else if (type === 'greater') {
        return {
          title: `${killer} is greater than ${victim}`,
          subtitle: `${killer} kill ${victim}`,
          media: icon,
        };
      }
      return {
        title: `Invalid Kill Condition`,
        subtitle: `${killer} kill ${victim}`,
        media: icon,
      };
    },
  },
});

export const puzzleLevel: SchemaTypeDefinition = defineType({
  name: 'puzzles.level',
  type: 'document',
  title: 'Level',
  icon: LevelIcon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'duration',
      title: 'Duration(In Seconds)',
      type: 'number',
      validation: (Rule) => Rule.min(50),
      initialValue: 99,
    }),
    defineField({
      name: 'image',
      title: 'Level Image',
      type: 'image',
    }),
    defineField({
      name: 'instructions',
      title: 'Instructions',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'characters',
      title: 'Characters',
      type: 'array',
      of: [{ type: 'puzzles.character' }],
    }),
    defineField({
      name: 'killWord',
      title: 'Kill Word',
      type: 'string',
    }),
    defineField({
      name: 'killConditions',
      title: 'Kill Conditions',
      type: 'array',
      of: [{ type: 'puzzles.killCondition' }],
    }),
  ],
  preview: {
    select: {
      title: 'title',
      media: 'image',
    },
    prepare({ title, media }) {
      return {
        title,
        media,
      };
    },
  },
});
