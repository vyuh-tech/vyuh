import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/content/forgot_password_form_layout.dart';

part 'forgot_password_form.g.dart';

@JsonSerializable()
final class ForgotPasswordForm extends ContentItem {
  static const schemaName = 'auth.forgotPasswordForm';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Forgot Password Form',
    fromJson: ForgotPasswordForm.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: ForgotPasswordFormLayout.typeDescriptor,
    defaultLayout: ForgotPasswordFormLayout(),
  );

  final bool showLoginError;
  final Action? action;
  final Action? returnAction;

  ForgotPasswordForm({
    this.action,
    this.returnAction,
    this.showLoginError = true,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory ForgotPasswordForm.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordFormFromJson(json);
}
