import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { SiAuth0 as Icon } from 'react-icons/si';
import {
  ContentDescriptor,
  ContentSchemaBuilder,
} from '@vyuh/sanity-schema-core';
import { showLoginErrorField } from './util';

export class ForgotPasswordFormDescriptor extends ContentDescriptor {
  static schemaType = 'auth.forgotPasswordForm';

  constructor(props: Partial<ForgotPasswordFormDescriptor>) {
    super(ForgotPasswordFormDescriptor.schemaType, props);
  }
}

export class ForgotPasswordFormSchemaBuilder extends ContentSchemaBuilder {
  private schema = defineType({
    name: ForgotPasswordFormDescriptor.schemaType,
    title: 'Forgot Password Form',
    type: 'object',
    icon: Icon,
    fields: [
      showLoginErrorField(),
      defineField({
        name: 'action',
        title: 'Password Reset Action',
        description: 'Action to invoke after a successful password reset',
        type: 'vyuh.action',
      }),
      defineField({
        name: 'returnAction',
        title: 'Return Action',
        description: 'Action to invoke if the user wants to return back',
        type: 'vyuh.action',
      }),
    ],
    preview: {
      select: {
        showLoginError: 'showLoginError',
      },
      prepare: (props) => {
        return {
          title: 'Forgot Password Form',
          subtitle: `Show Login Error: ${props.showLoginError}`,
        };
      },
    },
  });

  constructor() {
    super(ForgotPasswordFormDescriptor.schemaType);
  }

  build(descriptors: ContentDescriptor[]): SchemaTypeDefinition {
    return this.schema;
  }
}
