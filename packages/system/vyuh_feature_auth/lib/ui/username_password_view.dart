import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/username_password_form.dart';
import 'package:vyuh_feature_auth/ui/auth_form_builder.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/email_password_view.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

class UsernamePasswordView extends StatelessWidget {
  final UsernamePasswordForm content;

  const UsernamePasswordView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AuthFormBuilder(
        actionTitle: content.actionType.title,
        showError: content.showLoginError,
        authAction: (formState) async {
          final values = formState.value;
          final username = values['username'] as String;
          final password = values['password'] as String;

          await content.actionType.execute(username, password);

          if (context.mounted) {
            content.action?.execute(context);
          }
        },
        endAuthState: AuthState.signedIn,
        child: (context, scope, submit) => AutofillGroup(
          child: Column(
            children: [
              UsernameField(submit: submit),
              const SizedBox(height: 8),
              PasswordField(
                showPasswordVisibilityToggle:
                    content.showPasswordVisibilityToggle,
                submit: submit,
              ),
              if (content.actionType == AuthActionType.signIn)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: HintAction(
                      hintLabel: const SizedBox.shrink(),
                      actionLabel: HintAction.defaultActionLabel(
                          context, "Forgot your password?"),
                      onTap: (_) {
                        content.forgotPasswordAction?.execute(context);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        footer: (context, scope) => Column(
          children: [
            if (content.actionType == AuthActionType.signIn)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HintAction(
                  hintLabel: HintAction.defaultHintLabel(
                      context, "Don't have an account? "),
                  actionLabel:
                      HintAction.defaultActionLabel(context, "Sign Up"),
                  onTap: (_) {
                    content.signupAction?.execute(context);
                  },
                ),
              ),
            if (content.actionType == AuthActionType.signUp)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HintAction(
                  hintLabel: HintAction.defaultHintLabel(
                      context, "Already have an account? "),
                  actionLabel: HintAction.defaultActionLabel(context, "Login"),
                  onTap: (_) {
                    content.loginAction?.execute(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on AuthActionType {
  Future<void> execute(String username, String password) {
    switch (this) {
      case AuthActionType.signIn:
        // For now, we'll use the email/password methods with username as email
        // This can be extended later to support proper username authentication
        return vyuh.auth
            .loginWithEmailPassword(email: username, password: password);
      case AuthActionType.signUp:
        // For now, we'll use the email/password methods with username as email
        // This can be extended later to support proper username authentication
        return vyuh.auth
            .registerWithEmailPassword(email: username, password: password);
    }
  }
}
