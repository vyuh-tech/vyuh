import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';
import 'package:vyuh_feature_auth/auth_user_card_layout.dart';
import 'package:vyuh_feature_auth/content/email_password_form.dart';
import 'package:vyuh_feature_auth/content/forgot_password_form.dart';
import 'package:vyuh_feature_auth/content/hint_action_text.dart';
import 'package:vyuh_feature_auth/content/oauth_signin.dart';
import 'package:vyuh_feature_auth/content/phone_otp_form.dart';
import 'package:vyuh_feature_system/content/index.dart';

feature({List<go.RouteBase> Function()? routes}) => FeatureDescriptor(
      name: 'auth',
      title: 'Authentication UI',
      icon: Icons.account_circle_outlined,
      extensions: [
        ContentExtensionDescriptor(contents: [
          CardDescriptor(
            layouts: [
              AuthUserCardLayout.typeDescriptor,
            ],
          ),
        ], contentBuilders: [
          EmailPasswordForm.contentBuilder,
          ForgotPasswordForm.contentBuilder,
          OAuthSignIn.contentBuilder,
          PhoneOtpForm.contentBuilder,
          HintActionText.contentBuilder,
        ])
      ],
      routes: routes ??
          () => [
                CMSRoute(path: '/login'),
                CMSRoute(path: '/signup'),
                CMSRoute(path: '/forgot-password'),
              ],
    );
