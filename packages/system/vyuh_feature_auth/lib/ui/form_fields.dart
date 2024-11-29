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
  final FormFieldValidator<String>? validator;
  final InputDecoration? inputDecoration;
  final void Function(BuildContext) submit;

  const PhoneInputField({
    super.key,
    required this.submit,
    this.validator,
    this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'phone',
      decoration:
          inputDecoration ?? const InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.phoneNumber(),
        if (validator != null) validator!,
      ]),
      onSubmitted: (_) => submit(context),
    );
  }
}

class OtpInputField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final InputDecoration? inputDecoration;
  final void Function(BuildContext) submit;

  const OtpInputField({
    super.key,
    required this.submit,
    this.inputDecoration,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'otp',
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: inputDecoration ?? const InputDecoration(labelText: 'OTP'),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(6),
        FormBuilderValidators.numeric(),
        if (validator != null) validator!,
      ]),
      onSubmitted: (_) => submit(context),
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
  final Widget hintLabel;
  final Widget actionLabel;
  final void Function(BuildContext) onTap;
  final WrapAlignment alignment;

  const HintAction({
    super.key,
    required this.hintLabel,
    required this.actionLabel,
    required this.onTap,
    this.alignment = WrapAlignment.center,
  });

  static Widget defaultHintLabel(BuildContext context, String label) =>
      Text(label);

  static Widget defaultActionLabel(BuildContext context, String label) => Text(
        label,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        alignment: alignment,
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          hintLabel,
          GestureDetector(
            onTap: () => onTap(context),
            child: actionLabel,
          ),
        ],
      ),
    );
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

    return Row(
      children: [
        Icon(
          Icons.error,
          color: theme.colorScheme.error,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            error.toString(),
            style: theme.textTheme.bodyMedium
                ?.apply(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
