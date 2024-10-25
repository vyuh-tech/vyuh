import {
  BuiltContentSchemaBuilder,
  defaultLayoutConfiguration,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { CardDescriptor, RouteDescriptor } from '@vyuh/sanity-schema-system';
import {
  EmailPasswordFormDescriptor,
  EmailPasswordFormSchemaBuilder,
} from './content/email-password-form';
import { authUserCardLayout } from './card.layout.authUser';
import {
  ForgotPasswordFormDescriptor,
  ForgotPasswordFormSchemaBuilder,
} from './content/forgot-password-form';
import {
  defaultOAuthSignInLayout,
  OAuthSignInDescriptor,
  OAuthSignInSchemaBuilder,
} from './content/oauth-signin';
import {
  PhoneOtpFormDescriptor,
  PhoneOtpFormSchemaBuilder,
} from './content/phone-otp-form';
import { hintActionText } from './content/hint-action-text';
import { FormDescriptor } from '@vyuh/sanity-schema-forms';

export const auth = new FeatureDescriptor({
  name: 'auth',
  title: 'Authentication',
  description: 'A feature that provides the content items for Authentication',
  contents: [
    new RouteDescriptor({
      regionItems: [
        { type: EmailPasswordFormDescriptor.schemaType },
        { type: ForgotPasswordFormDescriptor.schemaType },
        { type: OAuthSignInDescriptor.schemaType },
        { type: PhoneOtpFormDescriptor.schemaType },
        { type: hintActionText.name },
      ],
    }),
    new FormDescriptor({
      items: [{ type: hintActionText.name }],
    }),
    new EmailPasswordFormDescriptor({
      layouts: [
        defaultLayoutConfiguration(
          `${EmailPasswordFormDescriptor.schemaType}.layout.default`,
        ),
      ],
    }),
    new ForgotPasswordFormDescriptor({
      layouts: [
        defaultLayoutConfiguration(
          `${ForgotPasswordFormDescriptor.schemaType}.layout.default`,
        ),
      ],
    }),
    new PhoneOtpFormDescriptor({
      layouts: [
        defaultLayoutConfiguration(
          `${PhoneOtpFormDescriptor.schemaType}.layout.default`,
        ),
      ],
    }),
    new OAuthSignInDescriptor({
      layouts: [defaultOAuthSignInLayout],
    }),

    new CardDescriptor({
      layouts: [authUserCardLayout],
    }),
  ],
  contentSchemaBuilders: [
    new EmailPasswordFormSchemaBuilder(),
    new ForgotPasswordFormSchemaBuilder(),
    new OAuthSignInSchemaBuilder(),
    new PhoneOtpFormSchemaBuilder(),
    new BuiltContentSchemaBuilder({
      schemaType: hintActionText.name,
      schema: hintActionText,
    }),
  ],
});
