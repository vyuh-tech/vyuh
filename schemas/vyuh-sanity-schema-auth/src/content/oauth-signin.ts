import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { SiAuth0 as Icon } from 'react-icons/si';
import { RxBox as LayoutIcon } from 'react-icons/rx';

import {
  ContentDescriptor,
  ContentSchemaBuilder,
} from '@vyuh/sanity-schema-core';
import { showLoginErrorField } from './util';

export class OAuthSignInDescriptor extends ContentDescriptor {
  static schemaType = 'auth.oauthSignIn';

  constructor(props: Partial<OAuthSignInDescriptor>) {
    super(OAuthSignInDescriptor.schemaType, props);
  }
}

export class OAuthSignInSchemaBuilder extends ContentSchemaBuilder {
  private schema = defineType({
    name: OAuthSignInDescriptor.schemaType,
    title: 'OAuth Sign In',
    type: 'object',
    icon: Icon,
    fields: [
      defineField({
        name: 'authTypes',
        title: 'Authentication Type',
        description: 'The type of authentication to use',
        type: 'array',
        of: [{ type: 'string' }],
        options: {
          list: [
            { title: 'Google', value: 'google' },
            { title: 'Apple', value: 'apple' },
            { title: 'Github', value: 'github' },
            { title: 'Twitter', value: 'twitter' },
            { title: 'Facebook', value: 'facebook' },
          ],
        },
      }),
      showLoginErrorField(),
      defineField({
        name: 'action',
        title: 'Sign In Action',
        description: 'Action to invoke after a successful sign in',
        type: 'vyuh.action',
      }),
    ],
    preview: {
      select: {
        authTypes: 'authTypes',
        showLoginError: 'showLoginError',
      },
      prepare: (props) => {
        const authTypes = props.authTypes ?? [];
        return {
          title: 'OAuth Sign In',
          subtitle: `Auth types: ${authTypes.length === 0 ? 'none' : authTypes.join(', ')} | Show Login Error: ${props.showLoginError}`,
        };
      },
    },
  });

  constructor() {
    super(OAuthSignInDescriptor.schemaType);
  }

  build(descriptors: ContentDescriptor[]): SchemaTypeDefinition {
    return this.schema;
  }
}

export const defaultOAuthSignInLayout = defineType({
  name: `${OAuthSignInDescriptor.schemaType}.layout.default`,
  title: 'Default',
  type: 'object',
  icon: LayoutIcon,
  fields: [
    defineField({
      name: 'type',
      title: 'Type',
      type: 'string',
      initialValue: 'iconText',
      options: {
        list: [
          { title: 'Icon', value: 'icon' },
          { title: 'Text', value: 'text' },
          { title: 'Icon & Text', value: 'iconText' },
        ],
      },
    }),
    defineField({
      name: 'direction',
      title: 'Axis Direction',
      type: 'string',
      initialValue: 'vertical',
      options: {
        list: [
          { title: 'Vertical', value: 'vertical' },
          { title: 'Horizontal', value: 'horizontal' },
        ],
      },
    }),
  ],
  preview: {
    select: {
      type: 'type',
    },
    prepare: (props) => {
      return {
        title: 'Default',
        subtitle: `Type: ${props.type}`,
      };
    },
  },
});
