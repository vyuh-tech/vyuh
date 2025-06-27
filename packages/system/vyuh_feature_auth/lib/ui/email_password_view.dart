import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/email_password_form.dart';
import 'package:vyuh_feature_auth/ui/auth_form_builder.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

enum AuthActionType {
  signIn,
  signUp;

  String get title {
    switch (this) {
      case AuthActionType.signIn:
        return 'Sign In';
      case AuthActionType.signUp:
        return 'Sign Up';
    }
  }
}

class EmailPasswordView extends StatelessWidget {
  final EmailPasswordForm content;

  const EmailPasswordView({
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
          final email = values['email'] as String;
          final password = values['password'] as String;

          await content.actionType.execute(email, password);

          if (context.mounted) {
            content.action?.execute(context);
          }
        },
        endAuthState: AuthState.signedIn,
        child: (context, scope, submit) => AutofillGroup(
          child: Column(
            children: [
              EmailField(submit: submit),
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
  Future<void> execute(String email, String password) {
    switch (this) {
      case AuthActionType.signIn:
        return vyuh.auth
            .loginWithEmailPassword(email: email, password: password);
      case AuthActionType.signUp:
        return vyuh.auth
            .registerWithEmailPassword(email: email, password: password);
    }
  }
}
