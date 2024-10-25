import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { IoShirt as Icon } from 'react-icons/io5';
import {
  ContentDescriptor,
  ContentSchemaBuilder,
} from '@vyuh/sanity-schema-core';

export class ProductCardDescriptor extends ContentDescriptor {
  static schemaType = 'misc.productCard';

  constructor(props: Partial<ContentDescriptor> = {}) {
    super(ProductCardDescriptor.schemaType, props);
  }
}

const productCard = defineType({
  name: ProductCardDescriptor.schemaType,
  title: 'Product Card',
  type: 'object',
  icon: Icon,
  fieldsets: [
    {
      name: 'name',
      title: 'Name',
      options: { columns: 2 },
    },
    {
      name: 'details',
      title: 'Product Details',
      options: { columns: 2 },
    },
  ],
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) => Rule.required(),
      fieldset: 'name',
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
      rows: 4,
      validation: (Rule) => Rule.required(),
      fieldset: 'name',
    }),
    defineField({
      name: 'skuId',
      title: 'SKU Id',
      type: 'string',
      validation: (Rule) => Rule.required(),
      fieldset: 'details',
    }),
    defineField({
      name: 'price',
      title: 'Price',
      type: 'number',
      validation: (Rule) => Rule.required(),
      fieldset: 'details',
    }),
    defineField({
      name: 'category',
      title: 'Category',
      type: 'string',
      validation: (Rule) => Rule.required(),
      fieldset: 'details',
    }),
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
    }),
  ],
  preview: {
    select: {
      title: 'title',
      price: 'price',
      category: 'category',
      skuId: 'skuId',
      image: 'image',
    },
    prepare(selection) {
      const { title, image, price, category, skuId } = selection;
      return {
        title: `ProductCard | ${title} (${skuId})`,
        subtitle: `${category} - $${price}`,
        media: image,
      };
    },
  },
});

export class ProductCardContentBuilder extends ContentSchemaBuilder {
  private schema = productCard;

  constructor() {
    super(ProductCardDescriptor.schemaType);
  }

  build(descriptors: ContentDescriptor[]): SchemaTypeDefinition {
    return this.schema;
  }
}

export const productCardMiniViewLayout = defineType({
  name: `${ProductCardDescriptor.schemaType}.layout.miniView`,
  title: 'Mini View',
  type: 'object',
  fields: [
    defineField({
      name: 'showCategory',
      title: 'Show Category',
      type: 'boolean',
      initialValue: true,
    }),
  ],
  preview: {
    select: {
      showCategory: 'showCategory',
    },
    prepare(selection) {
      return {
        title: 'Mini View',
        subtitle: `Show Category: ${selection.showCategory ?? false}`,
      };
    },
  },
});
