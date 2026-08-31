import 'package:flutter/material.dart'
    as legacy_material
    show Material, MaterialType;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:vyuh_cdx_ui/vyuh_cdx_ui.dart';
import 'package:vyuh_feature_auth/ui/auth_state_widget.dart';

const emailControlName = 'email';
const usernameControlName = 'username';
const phoneControlName = 'phone';
const otpControlName = 'otp';
const passwordControlName = 'password';

FormGroup emailPasswordAuthForm({String? email}) => FormGroup({
  emailControlName: FormControl<String>(
    value: email,
    validators: [Validators.required, Validators.email],
  ),
  passwordControlName: FormControl<String>(validators: [Validators.required]),
});

FormGroup emailAuthForm({String? email}) => FormGroup({
  emailControlName: FormControl<String>(
    value: email,
    validators: [Validators.required, Validators.email],
  ),
});

FormGroup usernamePasswordAuthForm({String? username}) => FormGroup({
  usernameControlName: FormControl<String>(
    value: username,
    validators: [Validators.required, Validators.minLength(3)],
  ),
  passwordControlName: FormControl<String>(validators: [Validators.required]),
});

FormGroup phoneOtpAuthForm() => FormGroup({
  phoneControlName: FormControl<String>(
    validators: [
      Validators.required,
      Validators.delegate(_phoneNumberValidator),
    ],
  ),
  otpControlName: FormControl<String>(
    validators: [
      Validators.required,
      Validators.minLength(6),
      Validators.number(allowNegatives: false),
    ],
  ),
});

Map<String, dynamic>? _phoneNumberValidator(AbstractControl<dynamic> control) {
  final value = control.value as String?;
  if (value == null || value.isEmpty) {
    return null;
  }

  return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)
      ? null
      : const {'phoneNumber': true};
}

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
              ),
            )
          : icon,
      label: title == null ? const SizedBox.shrink() : Text(title!),
    );
  }
}

final _whitespaceRegExp = RegExp(r'\s\b|\b\s');

class EmailField extends StatelessWidget {
  final void Function() submit;
  const EmailField({super.key, required this.submit});

  @override
  Widget build(BuildContext context) {
    return _ReactiveFormFieldBoundary(
      child: ReactiveTextField<String>(
        formControlName: emailControlName,
        decoration: legacyCdxInputDecoration(context, labelText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [FilteringTextInputFormatter.deny(_whitespaceRegExp)],
        autofillHints: const [AutofillHints.email, AutofillHints.username],
        validationMessages: {
          ValidationMessage.required: (_) => 'Email is required',
          ValidationMessage.email: (_) => 'Enter a valid email address',
        },
        onSubmitted: (_) => submit(),
      ),
    );
  }
}

class UsernameField extends StatelessWidget {
  final void Function() submit;
  const UsernameField({super.key, required this.submit});

  @override
  Widget build(BuildContext context) {
    return _ReactiveFormFieldBoundary(
      child: ReactiveTextField<String>(
        formControlName: usernameControlName,
        decoration: legacyCdxInputDecoration(context, labelText: 'Username'),
        keyboardType: TextInputType.text,
        inputFormatters: [FilteringTextInputFormatter.deny(_whitespaceRegExp)],
        autofillHints: const [AutofillHints.username],
        validationMessages: {
          ValidationMessage.required: (_) => 'Username is required',
          ValidationMessage.minLength: (_) =>
              'Username must be at least 3 characters',
        },
        onSubmitted: (_) => submit(),
      ),
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final String labelText;
  final void Function(BuildContext) submit;

  const PhoneInputField({
    super.key,
    required this.submit,
    this.labelText = 'Phone Number',
  });

  @override
  Widget build(BuildContext context) {
    return _ReactiveFormFieldBoundary(
      child: ReactiveTextField<String>(
        formControlName: phoneControlName,
        decoration: legacyCdxInputDecoration(context, labelText: labelText),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
        autofillHints: const [
          AutofillHints.telephoneNumber,
          AutofillHints.telephoneNumberLocal,
          AutofillHints.telephoneNumberNational,
        ],
        validationMessages: {
          ValidationMessage.required: (_) => 'Phone number is required',
          'phoneNumber': (_) => 'Enter a valid phone number',
        },
        onSubmitted: (_) => submit(context),
      ),
    );
  }
}

class OtpInputField extends StatelessWidget {
  final String labelText;
  final void Function(BuildContext) submit;

  const OtpInputField({
    super.key,
    required this.submit,
    this.labelText = 'OTP',
  });

  @override
  Widget build(BuildContext context) {
    return _ReactiveFormFieldBoundary(
      child: ReactiveTextField<String>(
        formControlName: otpControlName,
        autofillHints: const [AutofillHints.oneTimeCode],
        decoration: legacyCdxInputDecoration(context, labelText: labelText),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validationMessages: {
          ValidationMessage.required: (_) => 'OTP is required',
          ValidationMessage.minLength: (_) => 'OTP must be at least 6 digits',
          ValidationMessage.number: (_) => 'OTP must contain only digits',
        },
        onSubmitted: (_) => submit(context),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final bool showPasswordVisibilityToggle;
  final bool autofocus;
  final void Function() submit;
  const PasswordField({
    super.key,
    this.showPasswordVisibilityToggle = false,
    this.autofocus = false,
    required this.submit,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return _ReactiveFormFieldBoundary(
      child: ReactiveTextField<String>(
        formControlName: passwordControlName,
        autofocus: widget.autofocus,
        decoration: legacyCdxInputDecoration(
          context,
          labelText: 'Password',
          suffixIcon: widget.showPasswordVisibilityToggle
              ? IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                )
              : null,
        ),
        obscureText: !_showPassword,
        autofillHints: const [AutofillHints.password],
        validationMessages: {
          ValidationMessage.required: (_) => 'Password is required',
        },
        onSubmitted: (_) => widget.submit(),
      ),
    );
  }
}

final class _ReactiveFormFieldBoundary extends StatelessWidget {
  final Widget child;

  const _ReactiveFormFieldBoundary({required this.child});

  @override
  Widget build(BuildContext context) {
    // reactive_forms still renders Flutter Material text fields internally.
    return CdxMaterialUiCompatibilityBridge(
      child: legacy_material.Material(
        type: legacy_material.MaterialType.transparency,
        child: child,
      ),
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
      fontWeight: FontWeight.bold,
    ),
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
        Icon(Icons.error, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            error.toString(),
            style: theme.textTheme.bodyMedium?.apply(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
