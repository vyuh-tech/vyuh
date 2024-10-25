import { defineField, defineType } from 'sanity';
import { MdOutlineMovieFilter as Icon } from 'react-icons/md';


const dropDownItem = defineField({
    name: 'vyuh.dropDownMenu.item',
    title: 'Drop DownItem Item',
    type: 'object',
    fields: [
      defineField({
        name: 'title',
        title: 'Title',
        type: 'string',
      }),
      defineField({
        name: 'value',
        title: 'Value',
        type: 'string',
      }),
      defineField({
        name: 'action',
        title: 'Action',
        type: 'vyuh.action',
      }),
    ],
  });

export const dropdownMenu = defineType({
  name: 'vyuh.dropDownMenu',
  title: 'DropDown Menu',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
        name: 'label',
        title: 'Dropdown Label',
        type: 'string',
      }),
      defineField({
        name: 'items',
        title: 'List',
        type: 'array',
        of: [dropDownItem],
      }),
      defineField({
        name: 'selectionChanged',
        title: 'Selection Changed ',
        type: 'vyuh.action',
      }),
  ],
  preview: {
    select: {
      type: 'type',
    },
    prepare({ type }) {
      return {
        title: 'DropDown Menu',
        subtitle: type,
      };
    },
  },
});
