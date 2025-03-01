import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { MdOutlineSportsTennis as Icon } from 'react-icons/md';
import { GiTabletopPlayers } from 'react-icons/gi';

// @ts-ignore
export const scoreCard: SchemaTypeDefinition = defineType({
  name: 'misc.content.scoreCard',
  title: 'Score Card',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'player1',
      title: 'Player 1',
      type: 'string',
    }),
    defineField({
      name: 'player2',
      title: 'Player 2',
      type: 'string',
    }),
    defineField({
      name: 'games',
      title: 'Games',
      type: 'array',
      icon: GiTabletopPlayers,
      validation: (Rule) => Rule.max(7),
      of: [
        defineField({
          name: 'game',
          title: 'Game',
          type: 'object',
          fields: [
            defineField({
              name: 'score1',
              title: 'Score 1',
              description: 'Score for Player 1',
              type: 'number',
            }),
            defineField({
              name: 'score2',
              title: 'Score 2',
              description: 'Score for Player 2',
              type: 'number',
            }),
          ],
          options: { columns: 2 },
          preview: {
            select: {
              score1: 'score1',
              score2: 'score2',
            },
            prepare({ score1, score2 }) {
              return {
                title: `${score1 ?? 0} - ${score2 ?? 0}`,
                media: GiTabletopPlayers,
              };
            },
          },
        }),
      ],
    }),
  ],
  preview: {
    select: {
      player1: 'player1',
      player2: 'player2',
      games: 'games',
    },
    prepare({
      player1,
      player2,
      games,
    }: {
      player1: string;
      player2: string;
      games: any[];
    }) {
      const winningPlayer =
        games?.reduce(
          (winner, game, index) =>
            game.score1 > game.score2
              ? `${player1 ?? 'P1'}`
              : game.score2 > game.score1
                ? `${player2 ?? 'P2'}`
                : winner,
          '',
        ) || 'No winner';

      return {
        title: `${player1 ?? 'P1'} vs ${player2 ?? 'P2'}`,
        subtitle: `Winner: ${winningPlayer}`,
      };
    },
  },
});
