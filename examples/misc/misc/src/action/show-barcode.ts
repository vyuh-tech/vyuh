import { defineField, defineType } from 'sanity';
import { FaBarcode as Icon } from 'react-icons/fa6';

export const showBarcode = defineType({
  name: 'misc.action.showBarcode',
  title: 'Show Barcode',
  type: 'object',
  icon: Icon,
  fields: [
    defineField({
      name: 'data',
      title: 'Data',
      type: 'string',
      initialValue: 'Vyuh Framework',
      validation: (Rule) => Rule.required(),
    }),
    defineField({
      name: 'barcodeType',
      title: 'Barcode Type',
      type: 'string',
      validation: (Rule) => Rule.required(),
      initialValue: 'Code128',
      options: {
        list: [
          { title: 'Code128', value: 'Code128' },
          { title: 'CodeUPCE', value: 'CodeUPCE' },
          { title: 'CodeEAN13', value: 'CodeEAN13' },
          { title: 'CodeISBN', value: 'CodeISBN' },
          { title: 'QR Code', value: 'QrCode' },
          { title: 'DataMatrix', value: 'DataMatrix' },
        ],
        layout: 'radio',
      },
    }),
  ],
  preview: {
    select: {
      barcodeType: 'barcodeType',
      data: 'data',
    },
    prepare({ barcodeType, data }) {
      return {
        title: 'Show Barcode',
        subtitle: `Data: ${data ?? '---'} | Barcode Type: ${barcodeType}`,
      };
    },
  },
});
