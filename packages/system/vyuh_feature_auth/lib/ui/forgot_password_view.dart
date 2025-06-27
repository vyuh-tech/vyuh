import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/forgot_password_form.dart';
import 'package:vyuh_feature_auth/ui/auth_form_builder.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

class ForgotPasswordView extends StatelessWidget {
  final String? email;
  final ForgotPasswordForm content;

  const ForgotPasswordView({super.key, this.email, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AuthFormBuilder(
        actionTitle: 'Send reset email',
        showError: content.showLoginError,
        authAction: (formState) async {
          final email = formState.fields['email']?.value as String;

          await vyuh.auth.sendPasswordResetEmail(email: email);
          if (context.mounted) {
            content.action?.execute(context);
          }
        },
        endAuthState: AuthState.passwordResetEmailSent,
        child: (context, scope, submit) => EmailField(
          submit: submit,
          email: email,
        ),
        footer: (context, scope) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: HintAction(
            onTap: (_) => content.returnAction?.execute(context),
            hintLabel:
                HintAction.defaultHintLabel(context, 'Know your password? '),
            actionLabel: HintAction.defaultActionLabel(context, 'Go Back'),
          ),
        ),
      ),
    );
  }
}
