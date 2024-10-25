import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/forgot_password_form.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

class ForgotPasswordView extends StatefulWidget {
  final String? email;
  final ForgotPasswordForm content;

  const ForgotPasswordView({super.key, this.email, required this.content});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AuthFlow(builder: (context, scope) {
      return FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EmailField(
                  submit: () => _submit(context, scope), email: widget.email),
              const SizedBox(height: 20),
              AuthActionButton(
                scope: scope,
                title: 'Send reset email',
                onPressed: (context) => _submit(context, scope),
                showError: widget.content.showLoginError,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HintAction(
                  onTap: (_) => widget.content.returnAction?.execute(context),
                  hintLabel: HintAction.defaultHintLabel(
                      context, 'Know your password? '),
                  actionLabel:
                      HintAction.defaultActionLabel(context, 'Go Back'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _submit(BuildContext context, AuthFlowScope state) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final email = _formKey.currentState?.fields['email']?.value as String;

      state.runAuthAction(
        () async {
          await vyuh.auth.sendPasswordResetEmail(email: email);
          if (context.mounted) {
            widget.content.action?.execute(context);
          }
        },
        endState: AuthState.passwordResetEmailSent,
      );
    }
  }
}
