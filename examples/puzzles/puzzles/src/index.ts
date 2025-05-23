import {
  BuiltContentSchemaBuilder,
  DefaultFieldsModifier,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { character, killCondition, puzzleLevel } from './puzzle';
import { levelSection } from './section';
import { RouteDescriptor } from '@vyuh/sanity-schema-system';
import { puzzlesLevelLayout } from './level-layout';
import { selectLevelAction } from './level-action';

export const puzzles = new FeatureDescriptor({
  name: 'puzzles',
  title: 'Puzzles',
  description: 'Schema for the Puzzles feature',
  contents: [
    new RouteDescriptor({
      layouts: [puzzlesLevelLayout],
      regionItems: [
        {
          type: levelSection.name,
        },
      ],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(character),
    new BuiltContentSchemaBuilder(killCondition),
    new BuiltContentSchemaBuilder(puzzleLevel),
    new BuiltContentSchemaBuilder(levelSection),
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [
        { type: character.name },
        { type: killCondition.name },
        { type: puzzleLevel.name },
        { type: levelSection.name },
      ],
    }),
  ],
  actions: [selectLevelAction],
});
