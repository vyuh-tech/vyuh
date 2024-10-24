import { defineField, defineType } from 'sanity';
import { FaBurger as MenuItemIcon } from 'react-icons/fa6';

const relatedItem = defineType({
  name: 'food.item.related',
  title: 'Related Item',
  type: 'object',
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
    }),
    defineField({
      name: 'calories',
      title: 'Calories',
      type: 'number',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
  ],
});

const ingredient = defineType({
  name: 'food.ingredient',
  title: 'Ingredient',
  type: 'object',
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
  ],
});

const nutritionFact = defineType({
  name: 'food.item.nutritionFact',
  title: 'Nutrition Fact',
  type: 'object',
  fields: [
    defineField({
      name: 'name',
      title: 'Name',
      type: 'string',
    }),
    defineField({
      name: 'quantity',
      title: 'Quantity',
      type: 'number',
      validation: (Rule) => Rule.min(0),
      initialValue: 1,
    }),
    defineField({
      name: 'unit',
      title: 'Unit',
      type: 'string',
      initialValue: 'g',
      options: {
        list: [
          { value: 'g', title: 'Grams' },
          { value: 'mg', title: 'Milligrams' },
          { value: 'mcg', title: 'Micrograms' },
          { value: 'cal', title: 'Calories' },
          { value: 'kcal', title: 'Kilocalories' },
        ],
      },
    }),
    defineField({
      name: 'dailyValue',
      title: 'Percent Daily Value',
      type: 'number',
      validation: (Rule) => Rule.max(100).min(0),
    }),
    defineField({
      name: 'includeInSummary',
      title: 'Include in Summary',
      type: 'boolean',
      initialValue: false,
    }),
  ],
});

export const menuItem = defineType({
  name: 'food.item',
  title: 'Menu Item',
  type: 'document',
  fields: [
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'vyuh.portableText',
    }),
    defineField({
      name: 'calories',
      title: 'Calories',
      type: 'number',
    }),
    defineField({
      name: 'ingredients',
      title: 'Ingredients',
      type: 'array',
      // @ts-ignore
      of: [ingredient],
    }),
    defineField({
      name: 'nutrition',
      title: 'Nutritional Information',
      type: 'array',
      // @ts-ignore
      of: [nutritionFact],
    }),
    defineField({
      name: 'relatedItems',
      title: 'Related Items',
      type: 'array',
      // @ts-ignore
      of: [relatedItem],
    }),
  ],
});

export const foodItemContent = defineType({
  name: 'food.item.selected',
  title: 'Selected Food Item',
  type: 'object',
  icon: MenuItemIcon,
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      initialValue: 'Selected Food Menu Item',
      readOnly: true,
    }),
  ],
});

export const selectItemAction = defineType({
  name: 'food.action.selectItem',
  title: 'Select Item',
  type: 'object',
  icon: MenuItemIcon,
  fields: [
    defineField({
      name: 'menuItem',
      title: 'Menu Item',
      type: 'reference',
      weak: true,
      to: [{ type: menuItem.name }],
    }),
  ],
  preview: {
    select: {
      item: 'menuItem.title',
      calories: 'menuItem.calories',
    },
    prepare({ item, calories }) {
      return {
        title: item,
        subtitle: `Calories: ${calories}`,
      };
    },
  },
});
