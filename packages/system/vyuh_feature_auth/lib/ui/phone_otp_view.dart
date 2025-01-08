import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart';

class PhoneOTPView extends StatefulWidget {
  final PhoneOtpForm content;

  const PhoneOTPView({
    super.key,
    required this.content,
  });

  @override
  State<PhoneOTPView> createState() => _PhoneOTPViewState();
}

class _PhoneOTPViewState extends State<PhoneOTPView> {
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
              PhoneInputField(submit: (context) => _submit(context, scope)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: HintAction(
                    hintLabel: const SizedBox.shrink(),
                    actionLabel:
                        HintAction.defaultActionLabel(context, "Get OTP"),
                    onTap: (_) {
                      widget.content.getOtpAction?.execute(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OtpInputField(
                submit: (context) => _submit(context, scope),
              ),
              const SizedBox(height: 20),
              AuthActionButton(
                scope: scope,
                title: 'Login',
                onPressed: (context) => _submit(context, scope),
                showError: widget.content.showLoginError,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HintAction(
                  hintLabel: HintAction.defaultHintLabel(
                      context, "Don't have an account? "),
                  actionLabel:
                      HintAction.defaultActionLabel(context, "Sign Up"),
                  onTap: (_) {
                    // final email = FormBuilder.of(context)
                    //     ?.instantValue['email'] as String?;
                    widget.content.signupAction?.execute(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _submit(BuildContext context, AuthFlowScope scope) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState?.value;
      final phone = values!['phone'] as String;
      final otp = values['otp'] as String;

      scope.runAuthAction(
        () async {
          await vyuh.auth.loginWithPhoneOtp(phoneNumber: phone, otp: otp);

          if (context.mounted) {
            widget.content.action?.execute(context);
          }
        },
      );
    }
  }
}
