import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/oauth_signin.dart';
import 'package:vyuh_feature_auth/content/oauth_signin_layout.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';
import 'package:vyuh_feature_auth/ui/social_icons.dart';

class OAuthSignInView extends StatefulWidget {
  final OAuthSignIn content;
  final OAuthSignInLayout layout;

  const OAuthSignInView({
    super.key,
    required this.content,
    required this.layout,
  });

  @override
  State<OAuthSignInView> createState() => _OAuthSignInViewState();
}

class _OAuthSignInViewState extends State<OAuthSignInView> {
  LoginMethod _invokedMethod = LoginMethod.unknown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AuthFlow(
        builder: (context, scope) {
          final buttons = [
            for (final authType in widget.content.authTypes)
              LoaderButton(
                onPressed: () {
                  _invokedMethod = authType.loginMethod;
                  scope.runAuthAction(
                    () async {
                      await vyuh.auth.loginWithOAuth(authType);
                      if (context.mounted) {
                        widget.content.action?.execute(context);
                      }
                    },
                  );
                },
                loading: _invokedMethod == authType.loginMethod &&
                    scope.authState == AuthState.inProgress,
                icon: widget.layout.type == OAuthLayoutType.iconText ||
                        widget.layout.type == OAuthLayoutType.icon
                    ? Icon(authType.icon)
                    : null,
                title: widget.layout.type == OAuthLayoutType.iconText ||
                        widget.layout.type == OAuthLayoutType.text
                    ? authType.buttonTitle
                    : null,
                buttonStyle: authType.buttonStyle,
              ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.layout.direction == Axis.horizontal)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  runAlignment: WrapAlignment.spaceEvenly,
                  alignment: WrapAlignment.center,
                  children: buttons,
                ),
              if (widget.layout.direction == Axis.vertical)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: buttons,
                ),
              if (widget.content.showLoginError &&
                  scope.authState == AuthState.error)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ErrorText(error: scope.error),
                ),
            ],
          );
        },
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
        OAuthType.meta => SocialIcons.meta,
        OAuthType.twitter => SocialIcons.twitter,
        OAuthType.apple => SocialIcons.apple,
        OAuthType.github => SocialIcons.github,
        OAuthType.microsoft => SocialIcons.microsoft,
        OAuthType.linkedin => SocialIcons.linkedIn,
        _ => Icons.account_circle_outlined,
      };

  String get buttonTitle => name.capitalize();

  ButtonStyle? get buttonStyle => switch (this) {
        OAuthType.apple => const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            iconColor: WidgetStatePropertyAll(Colors.white),
          ),
        _ => null,
      };
}
