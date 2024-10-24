import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/forgot_password_form.dart';
import 'package:vyuh_feature_auth/ui/forgot_password_view.dart';

part 'forgot_password_form_layout.g.dart';

@JsonSerializable()
final class ForgotPasswordFormLayout
    extends LayoutConfiguration<ForgotPasswordForm> {
  static const schemaName = '${ForgotPasswordForm.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Forgot Password Form Layout',
    fromJson: ForgotPasswordFormLayout.fromJson,
  );

  ForgotPasswordFormLayout() : super(schemaType: typeDescriptor.schemaType);

  factory ForgotPasswordFormLayout.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordFormLayoutFromJson(json);

  @override
  Widget build(BuildContext context, ForgotPasswordForm content) {
    return ForgotPasswordView(content: content);
  }
}
