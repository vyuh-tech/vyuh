import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/content/email_password_form_layout.dart';
import 'package:vyuh_feature_auth/ui/email_password_view.dart';

part 'email_password_form.g.dart';

@JsonSerializable()
final class EmailPasswordForm extends ContentItem {
  final bool showPasswordVisibilityToggle;
  final AuthActionType actionType;
  final bool showLoginError;
  final Action? action;
  final Action? forgotPasswordAction;
  final Action? signupAction;
  final Action? loginAction;

  static const schemaName = 'auth.emailPasswordForm';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Email Password Form',
    fromJson: EmailPasswordForm.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: DefaultEmailPasswordFormLayout.typeDescriptor,
    defaultLayout: DefaultEmailPasswordFormLayout(),
  );

  EmailPasswordForm({
    this.showPasswordVisibilityToggle = false,
    this.actionType = AuthActionType.signIn,
    this.showLoginError = true,
    this.action,
    this.forgotPasswordAction,
    this.signupAction,
    this.loginAction,
    super.layout,
  }) : super(schemaType: schemaName);

  factory EmailPasswordForm.fromJson(Map<String, dynamic> json) =>
      _$EmailPasswordFormFromJson(json);
}

final class EmailPasswordFormDescriptor extends ContentDescriptor {
  EmailPasswordFormDescriptor({super.layouts})
      : super(
          schemaType: EmailPasswordForm.schemaName,
          title: 'Email Password Form',
        );
}
