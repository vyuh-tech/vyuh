import { defineField, defineType } from 'sanity';
import { MdOutlinePlaylistAdd as Icon } from 'react-icons/md';

export const dropDownChangeAction = defineType({
  name: 'tmdb.action.dropDownSelection',
  title: 'Drop Down Selection ',
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
