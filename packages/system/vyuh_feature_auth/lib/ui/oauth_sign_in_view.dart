import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart' as vx;
import 'package:vyuh_feature_auth/content/oauth_signin.dart';
import 'package:vyuh_feature_auth/content/oauth_signin_layout.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';
import 'package:vyuh_feature_auth/ui/social_icons.dart';

class OAuthSignInView extends StatelessWidget {
  final OAuthSignIn content;
  final OAuthSignInLayout layout;

  const OAuthSignInView({
    super.key,
    required this.content,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: layout.type == OAuthLayoutType.icon
          ? _IconOnlyOAuthButtonBar(content: content)
          : Wrap(
              children: [
                for (final authType in content.authTypes)
                  _OAuthButton(
                    authType: authType,
                    action: content.action,
                    layout: layout,
                  ),
              ],
            ),
    );
  }
}

class _IconOnlyOAuthButtonBar extends StatelessWidget {
  final OAuthSignIn content;
  const _IconOnlyOAuthButtonBar({required this.content});

  @override
  Widget build(BuildContext context) {
    return AuthFlow(builder: (context, scope) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final authType in content.authTypes)
                LoaderButton(
                  title: null,
                  onPressed: () {
                    scope.runAuthAction(
                      () async {
                        await vyuh.auth.loginWithOAuth(authType);
                        if (context.mounted) {
                          content.action?.execute(context);
                        }
                      },
                    );
                  },
                  loading: scope.authState == AuthState.inProgress,
                  icon: Icon(authType.icon),
                  buttonStyle: authType.buttonStyle,
                ),
            ],
          ),
          if (content.showLoginError && scope.authState == AuthState.error)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ErrorText(error: scope.error),
            ),
        ],
      );
    });
  }
}

class _OAuthButton extends StatelessWidget {
  final OAuthType authType;
  final vx.Action? action;
  final OAuthSignInLayout layout;

  const _OAuthButton(
      {required this.authType, this.action, required this.layout});

  @override
  Widget build(BuildContext context) {
    return AuthFlow(
      builder: (context, scope) => AuthActionButton(
        scope: scope,
        buttonStyle: authType.buttonStyle,
        icon: layout.type == OAuthLayoutType.iconText ||
                layout.type == OAuthLayoutType.icon
            ? Icon(authType.icon)
            : null,
        onPressed: (context) {
          scope.runAuthAction(
            () async {
              await vyuh.auth.loginWithOAuth(authType);
              if (context.mounted) {
                action?.execute(context);
              }
            },
          );
        },
        title: layout.type == OAuthLayoutType.iconText ||
                layout.type == OAuthLayoutType.text
            ? authType.buttonTitle
            : null,
      ),
    );
  }
}

extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension on OAuthType {
  IconData get icon => switch (this) {
        OAuthType.google => SocialIcons.google,
        OAuthType.meta => SocialIcons.facebook,
        OAuthType.twitter => SocialIcons.twitter,
        OAuthType.apple => SocialIcons.apple,
        _ => Icons.account_circle_outlined,
      };

  String get buttonTitle => 'Sign in with ${name.capitalize()}';

  ButtonStyle? get buttonStyle => switch (this) {
        OAuthType.apple => const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            iconColor: WidgetStatePropertyAll(Colors.white),
          ),
        _ => null,
      };
}
