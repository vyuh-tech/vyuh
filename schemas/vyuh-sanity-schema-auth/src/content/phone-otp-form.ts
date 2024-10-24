import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { SiAuth0 as Icon } from 'react-icons/si';
import {
  ContentDescriptor,
  ContentSchemaBuilder,
} from '@vyuh/sanity-schema-core';
import { showLoginErrorField } from './util';

export class PhoneOtpFormDescriptor extends ContentDescriptor {
  static schemaType = 'auth.phoneOtpForm';

  constructor(props: Partial<PhoneOtpFormDescriptor>) {
    super(PhoneOtpFormDescriptor.schemaType, props);
  }
}

export class PhoneOtpFormSchemaBuilder extends ContentSchemaBuilder {
  private schema = defineType({
    name: PhoneOtpFormDescriptor.schemaType,
    title: 'Phone OTP Form',
    type: 'object',
    icon: Icon,
    fields: [
      showLoginErrorField(),
      defineField({
        name: 'getOtpAction',
        title: 'Get OTP Action',
        description: 'Action to invoke when user requests for OTP',
        type: 'vyuh.action',
      }),
      defineField({
        name: 'signupAction',
        title: 'Sign Up Action',
        description:
          'Action to invoke when user wants to sign up for a new account',
        type: 'vyuh.action',
      }),
    ],
    preview: {
      select: {
        showLoginError: 'showLoginError',
      },
      prepare: (props) => {
        return {
          title: 'Phone OTP Form',
          subtitle: `Show Login Error: ${props.showLoginError}`,
        };
      },
    },
  });

  constructor() {
    super(PhoneOtpFormDescriptor.schemaType);
  }

  build(descriptors: ContentDescriptor[]): SchemaTypeDefinition {
    return this.schema;
  }
}
