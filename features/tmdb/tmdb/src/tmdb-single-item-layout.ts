import { defineType, SchemaTypeDefinition } from 'sanity';
import { MdOutlineApps as Icon } from 'react-icons/md';

export const tmdbSingleItemLayout: SchemaTypeDefinition = defineType({
  name: 'tmdb.route.layout.single',
  title: 'Tmdb Single Item Layout',
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
