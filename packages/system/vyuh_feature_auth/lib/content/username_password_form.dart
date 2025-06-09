import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/content/username_password_form_layout.dart';
import 'package:vyuh_feature_auth/ui/email_password_view.dart';

part 'username_password_form.g.dart';

@JsonSerializable()
final class UsernamePasswordForm extends ContentItem {
  final bool showPasswordVisibilityToggle;
  final AuthActionType actionType;
  final bool showLoginError;
  final Action? action;
  final Action? forgotPasswordAction;
  final Action? signupAction;
  final Action? loginAction;

  static const schemaName = 'auth.usernamePasswordForm';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Username Password Form',
    fromJson: UsernamePasswordForm.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: DefaultUsernamePasswordFormLayout.typeDescriptor,
    defaultLayout: DefaultUsernamePasswordFormLayout(),
  );

  UsernamePasswordForm({
    this.showPasswordVisibilityToggle = false,
    this.actionType = AuthActionType.signIn,
    this.showLoginError = true,
    this.action,
    this.forgotPasswordAction,
    this.signupAction,
    this.loginAction,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory UsernamePasswordForm.fromJson(Map<String, dynamic> json) =>
      _$UsernamePasswordFormFromJson(json);
}

final class UsernamePasswordFormDescriptor extends ContentDescriptor {
  UsernamePasswordFormDescriptor({super.layouts})
      : super(
          schemaType: UsernamePasswordForm.schemaName,
          title: 'Username Password Form',
        );
}
