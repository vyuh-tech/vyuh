import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/email_password_form.dart';
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

class EmailPasswordView extends StatefulWidget {
  final EmailPasswordForm content;

  const EmailPasswordView({
    super.key,
    required this.content,
  });

  @override
  State<EmailPasswordView> createState() => _EmailPasswordViewState();
}

class _EmailPasswordViewState extends State<EmailPasswordView> {
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
                EmailField(submit: () => _submit(context, scope)),
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
                        // final email = FormBuilder.of(context)
                        //     ?.instantValue['email'] as String?;
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
      final email = values!['email'] as String;
      final password = values['password'] as String;

      final actionType = widget.content.actionType;
      scope.runAuthAction(
        () async {
          await actionType.execute(email, password);

          if (context.mounted) {
            widget.content.action?.execute(context);
          }
        },
      );
    }
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
