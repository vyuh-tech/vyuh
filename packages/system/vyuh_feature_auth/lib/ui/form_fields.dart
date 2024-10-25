import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';

final class LoaderButton extends StatelessWidget {
  final String? title;
  final void Function() onPressed;
  final bool loading;
  final Icon? icon;
  final ButtonStyle? buttonStyle;

  const LoaderButton({
    super.key,
    this.title,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: buttonStyle,
      onPressed: loading ? null : onPressed,
      iconAlignment: title == null ? IconAlignment.end : IconAlignment.start,
      icon: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).indicatorColor,
              ))
          : icon,
      label: title == null ? const SizedBox.shrink() : Text(title!),
    );
  }
}

final _whitespaceRegExp = RegExp(r'\s\b|\b\s');

class EmailField extends StatelessWidget {
  final void Function() submit;
  final String? email;
  const EmailField({super.key, this.email, required this.submit});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'email',
      initialValue: email,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(_whitespaceRegExp)],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.email(),
      ]),
      onSubmitted: (_) => submit(),
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final void Function() submit;
  const PhoneInputField({super.key, required this.submit});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'phone',
      decoration: const InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.phoneNumber(),
      ]),
      onSubmitted: (_) => submit(),
    );
  }
}

class OtpInputField extends StatelessWidget {
  final void Function() submit;
  const OtpInputField({super.key, required this.submit});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'otp',
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: const InputDecoration(labelText: 'OTP'),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(6),
        FormBuilderValidators.numeric(),
      ]),
      onSubmitted: (_) => submit(),
    );
  }
}

class PasswordField extends StatefulWidget {
  final bool showPasswordVisibilityToggle;
  final void Function() submit;
  const PasswordField(
      {super.key,
      this.showPasswordVisibilityToggle = false,
      required this.submit});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'password',
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: widget.showPasswordVisibilityToggle
              ? IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                )
              : null),
      obscureText: !_showPassword,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      onSubmitted: (_) => widget.submit(),
    );
  }
}

class HintAction extends StatelessWidget {
  final String hintText;
  final String actionText;
  final void Function(BuildContext) onTap;

  const HintAction({
    super.key,
    required this.hintText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: hintText),
        TextSpan(
          text: actionText,
          style: TextStyle(
              color: theme.colorScheme.secondary, fontWeight: FontWeight.bold),
          mouseCursor: SystemMouseCursors.click,
          recognizer: TapGestureRecognizer()..onTap = () => onTap(context),
        ),
      ],
      style: theme.textTheme.labelMedium,
    ));
  }
}

final class AuthActionButton extends StatelessWidget {
  final void Function(BuildContext context) onPressed;
  final String? title;
  final Icon? icon;
  final ButtonStyle? buttonStyle;
  final AuthFlowScope scope;
  final bool showError;

  const AuthActionButton({
    super.key,
    this.title,
    required this.onPressed,
    this.buttonStyle,
    this.icon,
    required this.scope,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoaderButton(
          title: title,
          onPressed: () => onPressed(context),
          loading: scope.authState == AuthState.inProgress,
          icon: icon,
          buttonStyle: buttonStyle,
        ),
        if (showError && scope.authState == AuthState.error)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ErrorText(error: scope.error),
          ),
      ],
    );
  }
}

class ErrorText extends StatelessWidget {
  final dynamic error;
  const ErrorText({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      error.toString(),
      style: theme.textTheme.bodyMedium?.apply(color: theme.colorScheme.error),
    );
  }
}
