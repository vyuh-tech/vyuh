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
                color: Theme.of(context).tabBarTheme.indicatorColor,
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
      autofillHints: [AutofillHints.email, AutofillHints.username],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.email(),
      ]),
      onSubmitted: (_) => submit(),
    );
  }
}

class UsernameField extends StatelessWidget {
  final void Function() submit;
  final String? username;
  const UsernameField({super.key, this.username, required this.submit});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'username',
      initialValue: username,
      decoration: const InputDecoration(labelText: 'Username'),
      keyboardType: TextInputType.text,
      inputFormatters: [FilteringTextInputFormatter.deny(_whitespaceRegExp)],
      autofillHints: [AutofillHints.username],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.minLength(3,
            errorText: 'Username must be at least 3 characters'),
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
      autofillHints: [
        AutofillHints.telephoneNumber,
        AutofillHints.telephoneNumberLocal,
        AutofillHints.telephoneNumberNational
      ],
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
  final bool autofocus;
  final void Function() submit;
  const PasswordField(
      {super.key,
      this.showPasswordVisibilityToggle = false,
      this.autofocus = false,
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
      autofocus: widget.autofocus,
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
      autofillHints: const [AutofillHints.password],
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onTap(context),
              child: actionLabel,
            ),
          ),
        ],
      ),
    );
  }
}

typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);

final class AuthActionButton extends StatelessWidget {
  final void Function(BuildContext context) onPressed;
  final String? title;
  final Icon? icon;
  final ButtonStyle? buttonStyle;
  final AuthFlowScope scope;
  final bool showError;
  final Axis direction;
  final ErrorBuilder? errorBuilder;

  const AuthActionButton({
    super.key,
    this.title,
    required this.onPressed,
    this.buttonStyle,
    this.icon,
    this.direction = Axis.vertical,
    required this.scope,
    this.showError = true,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: direction == Axis.horizontal
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.stretch,
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
            child: errorBuilder != null
                ? errorBuilder!(context, scope.error)
                : ErrorText(error: scope.error),
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
          child: SelectableText(
            error.toString(),
            style: theme.textTheme.bodyMedium
                ?.apply(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
