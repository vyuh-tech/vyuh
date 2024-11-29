import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

final class AuthFormBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AuthFlowScope) child;
  final Widget Function(BuildContext, AuthFlowScope)? footer;
  final String actionTitle;
  final Future<void> Function(FormBuilderState) authAction;
  final AuthState endAuthState;

  const AuthFormBuilder({
    super.key,
    required this.child,
    required this.actionTitle,
    this.footer,
    required this.authAction,
    required this.endAuthState,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFlow(builder: (context, scope) {
      return FormBuilder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) => child(context, scope)),
            const SizedBox(height: 20),
            AuthActionButton(
              scope: scope,
              title: actionTitle,
              onPressed: (context) => _submit(context, scope),
              showError: true,
            ),
            if (footer != null) footer!(context, scope),
          ],
        ),
      );
    });
  }

  _submit(BuildContext context, AuthFlowScope scope) {
    final state = FormBuilder.of(context);
    if (state == null) {
      return;
    }

    if (state.saveAndValidate()) {
      scope.runAuthAction(() => authAction(state), endState: endAuthState);
    }
  }
}
