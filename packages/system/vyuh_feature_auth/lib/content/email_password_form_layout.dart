import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/email_password_form.dart';
import 'package:vyuh_feature_auth/ui/email_password_view.dart';

part 'email_password_form_layout.g.dart';

@JsonSerializable()
final class DefaultEmailPasswordFormLayout
    extends LayoutConfiguration<EmailPasswordForm> {
  static const schemaName = '${EmailPasswordForm.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Email Password Form Layout',
    fromJson: DefaultEmailPasswordFormLayout.fromJson,
  );

  DefaultEmailPasswordFormLayout()
      : super(schemaType: typeDescriptor.schemaType);

  factory DefaultEmailPasswordFormLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultEmailPasswordFormLayoutFromJson(json);

  @override
  Widget build(BuildContext context, EmailPasswordForm content) {
    return EmailPasswordView(content: content);
  }
}
