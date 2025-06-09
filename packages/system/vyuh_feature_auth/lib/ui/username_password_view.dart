import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/username_password_form.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/email_password_view.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

class UsernamePasswordView extends StatefulWidget {
  final UsernamePasswordForm content;

  const UsernamePasswordView({
    super.key,
    required this.content,
  });

  @override
  State<UsernamePasswordView> createState() => _UsernamePasswordViewState();
}

class _UsernamePasswordViewState extends State<UsernamePasswordView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AuthFlow(builder: (context, scope) {
      return FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UsernameField(submit: () => _submit(context, scope)),
                const SizedBox(height: 8),
                PasswordField(
                  showPasswordVisibilityToggle:
                      widget.content.showPasswordVisibilityToggle,
                  submit: () => _submit(context, scope),
                ),
                if (widget.content.actionType == AuthActionType.signIn)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: HintAction(
                        hintLabel: const SizedBox.shrink(),
                        actionLabel: HintAction.defaultActionLabel(
                            context, "Forgot your password?"),
                        onTap: (_) {
                          widget.content.forgotPasswordAction?.execute(context);
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                AuthActionButton(
                  scope: scope,
                  title: widget.content.actionType.title,
                  onPressed: (context) => _submit(context, scope),
                  showError: widget.content.showLoginError,
                ),
                if (widget.content.actionType == AuthActionType.signIn)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: HintAction(
                      hintLabel: HintAction.defaultHintLabel(
                          context, "Don't have an account? "),
                      actionLabel:
                          HintAction.defaultActionLabel(context, "Sign Up"),
                      onTap: (_) {
                        widget.content.signupAction?.execute(context);
                      },
                    ),
                  ),
                if (widget.content.actionType == AuthActionType.signUp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: HintAction(
                      hintLabel: HintAction.defaultHintLabel(
                          context, "Already have an account? "),
                      actionLabel:
                          HintAction.defaultActionLabel(context, "Login"),
                      onTap: (_) {
                        widget.content.loginAction?.execute(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _submit(BuildContext context, AuthFlowScope scope) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState?.value;
      final username = values!['username'] as String;
      final password = values['password'] as String;

      final actionType = widget.content.actionType;
      scope.runAuthAction(
        () async {
          await actionType.execute(username, password);

          if (context.mounted) {
            widget.content.action?.execute(context);
          }
        },
      );
    }
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
