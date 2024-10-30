import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { MdOutlineApps as Icon } from 'react-icons/md';
import { PathInput } from '@vyuh/sanity-schema-system';

export const tmdbMediaToggleLayout: SchemaTypeDefinition = defineType({
  name: 'tmdb.route.layout.mediaToggle',
  title: 'Tmdb Media Toggle Layout',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'subtitle',
      title: 'Subtitle',
      type: 'string',
    }),
    defineField({
      name: 'movieRoute',
      title: 'Movie Route',
      type: 'url',
      validation: (Rule) =>
        Rule.uri({
          allowRelative: true,
          scheme: ['http', 'https'],
        }),
      components: {
        input: PathInput,
      },
    }),
    defineField({
      name: 'seriesRoute',
      title: 'Series Route',
      type: 'url',
      validation: (Rule) =>
        Rule.uri({
          allowRelative: true,
          scheme: ['http', 'https'],
        }),
      components: {
        input: PathInput,
      },
    }),
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
