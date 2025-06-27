import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

final class AuthFormBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AuthFlowScope, VoidCallback submit) child;
  final Widget Function(BuildContext, AuthFlowScope)? footer;
  final String actionTitle;
  final Future<void> Function(FormBuilderState) authAction;
  final AuthState endAuthState;
  final bool showError;

  const AuthFormBuilder({
    super.key,
    required this.child,
    required this.actionTitle,
    this.footer,
    required this.authAction,
    required this.endAuthState,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFlow(builder: (context, scope) {
      return FormBuilder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) {
              submit() => _submit(context, scope);
              return child(context, scope, submit);
            }),
            const SizedBox(height: 20),
            AuthActionButton(
              scope: scope,
              title: actionTitle,
              onPressed: (context) => _submit(context, scope),
              showError: showError,
            ),
            if (footer != null) footer!(context, scope),
          ],
        ),
      );
    });
  }

  _submit(BuildContext context, AuthFlowScope scope) {
    FocusManager.instance.primaryFocus?.unfocus();
    final state = FormBuilder.of(context);
    if (state == null) {
      return;
    }

    if (state.saveAndValidate()) {
      scope.runAuthAction(() => authAction(state), endState: endAuthState);
    }
  }
}
