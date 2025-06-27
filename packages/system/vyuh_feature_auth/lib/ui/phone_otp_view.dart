import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/vyuh_feature_auth.dart';

class PhoneOTPView extends StatelessWidget {
  final PhoneOtpForm content;

  const PhoneOTPView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AuthFormBuilder(
        actionTitle: 'Login',
        showError: content.showLoginError,
        authAction: (formState) async {
          final values = formState.value;
          final phone = values['phone'] as String;
          final otp = values['otp'] as String;

          await vyuh.auth.loginWithPhoneOtp(phoneNumber: phone, otp: otp);

          if (context.mounted) {
            content.action?.execute(context);
          }
        },
        endAuthState: AuthState.signedIn,
        child: (context, scope, submit) => Column(
          children: [
            PhoneInputField(submit: (_) => submit()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: HintAction(
                  hintLabel: const SizedBox.shrink(),
                  actionLabel:
                      HintAction.defaultActionLabel(context, "Get OTP"),
                  onTap: (_) {
                    content.getOtpAction?.execute(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            OtpInputField(
              submit: (_) => submit(),
            ),
          ],
        ),
        footer: (context, scope) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: HintAction(
            hintLabel:
                HintAction.defaultHintLabel(context, "Don't have an account? "),
            actionLabel: HintAction.defaultActionLabel(context, "Sign Up"),
            onTap: (_) {
              content.signupAction?.execute(context);
            },
          ),
        ),
      ),
    );
  }
}
