import { defineType, SchemaTypeDefinition } from 'sanity';
import { MdOutlineApps as Icon } from 'react-icons/md';

export const tmdbListlayout: SchemaTypeDefinition = defineType({
  name: 'tmdb.route.layout.list',
  title: 'Tmdb List Layout',
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
  ],
});
