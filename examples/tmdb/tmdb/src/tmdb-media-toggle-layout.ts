import { defineField, defineType, SchemaTypeDefinition } from "sanity";
import { MdOutlineApps as Icon } from 'react-icons/md';

export const tmdbMediaToggleLayout :SchemaTypeDefinition= defineType({
    name: 'tmdb.route.layout.mediaToggle',
    title: 'Tmdb Media Toggle Layout',
    type: 'object',
    icon: Icon,
    fields: [
        {
            name: 'title',
            title: 'Title',
            type: 'string',
          },
      
          {
            name: 'subtitle',
            title: 'Subtitle',
            type: 'string',
          },
          {
            name: 'movieRoute',
            title: 'Movie Route',
            type: 'string',
          },
          {
            name: 'seriesRoute',
            title: 'Series Route',
            type: 'string',
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