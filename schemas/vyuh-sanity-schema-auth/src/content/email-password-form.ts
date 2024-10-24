import { defineField, defineType, SchemaTypeDefinition } from 'sanity';
import { SiAuth0 as Icon } from 'react-icons/si';
import {
  ContentDescriptor,
  ContentSchemaBuilder,
} from '@vyuh/sanity-schema-core';
import { showLoginErrorField } from './util';

export class EmailPasswordFormDescriptor extends ContentDescriptor {
  static schemaType = 'auth.emailPasswordForm';

  constructor(props: Partial<EmailPasswordFormDescriptor>) {
    super(EmailPasswordFormDescriptor.schemaType, props);
  }
}

export class EmailPasswordFormSchemaBuilder extends ContentSchemaBuilder {
  private schema = defineType({
    name: EmailPasswordFormDescriptor.schemaType,
    title: 'Email Password Form',
    type: 'object',
    icon: Icon,
    fields: [
      defineField({
        name: 'actionType',
        title: 'Auth Action Type',
        description: 'The type of authentication action to perform',
        type: 'string',
        initialValue: 'signIn',
        options: {
          list: [
            { title: 'Sign In', value: 'signIn' },
            { title: 'Sign Up', value: 'signUp' },
          ],
        },
      }),
      defineField({
        name: 'showPasswordVisibilityToggle',
        title: 'Show Password Visibility Toggle',
        type: 'boolean',
        initialValue: true,
      }),
      showLoginErrorField(),
      defineField({
        name: 'action',
        title: 'Action',
        description:
          'Action to invoke after signing in or after registering a new user',
        type: 'vyuh.action',
      }),
      defineField({
        name: 'forgotPasswordAction',
        title: 'Forgot Password Action',
        description:
          'Action to invoke when user requests to reset their password',
        type: 'vyuh.action',
        hidden: (context) => context.parent.actionType !== 'signIn',
      }),
      defineField({
        name: 'signupAction',
        title: 'Sign Up Action',
        description:
          'Action to invoke when user wants to sign up for a new account',
        type: 'vyuh.action',
        hidden: (context) => context.parent.actionType !== 'signIn',
      }),
      defineField({
        name: 'loginAction',
        title: 'Login Action',
        description:
          'Action to invoke when user wants to login to an existing account',
        type: 'vyuh.action',
        hidden: (context) => context.parent.actionType !== 'signUp',
      }),
    ],
    preview: {
      select: {
        showPasswordVisibilityToggle: 'showPasswordVisibilityToggle',
        showLoginError: 'showLoginError',
      },
      prepare: (props) => {
        return {
          title: 'Email Password Form',
          subtitle: `Show Password Visibility Toggle: ${props.showPasswordVisibilityToggle} | Show Login Error: ${props.showLoginError}`,
        };
      },
    },
  });

  constructor() {
    super(EmailPasswordFormDescriptor.schemaType);
  }

  build(descriptors: ContentDescriptor[]): SchemaTypeDefinition {
    return this.schema;
  }
}
