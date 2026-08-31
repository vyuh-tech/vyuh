import 'package:material_ui/material_ui.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';
import 'package:vyuh_feature_auth/ui/form_fields.dart';

final class AuthFormBuilder extends StatelessWidget {
  final FormGroup Function() form;
  final Widget Function(BuildContext, AuthFlowScope, VoidCallback submit) child;
  final Widget Function(BuildContext, AuthFlowScope)? footer;
  final String actionTitle;
  final Future<void> Function(FormGroup) authAction;
  final AuthState endAuthState;
  final bool showError;
  final ErrorBuilder? errorBuilder;

  const AuthFormBuilder({
    super.key,
    required this.form,
    required this.child,
    required this.actionTitle,
    this.footer,
    required this.authAction,
    required this.endAuthState,
    this.showError = true,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFlow(
      builder: (context, scope) {
        return ReactiveFormBuilder(
          form: form,
          builder: (context, formGroup, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builder(
                builder: (context) {
                  submit() => _submit(formGroup, scope);
                  return child(context, scope, submit);
                },
              ),
              const SizedBox(height: 20),
              AuthActionButton(
                scope: scope,
                title: actionTitle,
                onPressed: (_) => _submit(formGroup, scope),
                showError: showError,
                errorBuilder: errorBuilder,
              ),
              if (footer != null) footer!(context, scope),
            ],
          ),
        );
      },
    );
  }

  void _submit(FormGroup formGroup, AuthFlowScope scope) {
    FocusManager.instance.primaryFocus?.unfocus();
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      scope.runAuthAction(() => authAction(formGroup), endState: endAuthState);
    }
  }
}
