import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/username_password_form.dart';
import 'package:vyuh_feature_auth/ui/username_password_view.dart';

part 'username_password_form_layout.g.dart';

@JsonSerializable()
final class DefaultUsernamePasswordFormLayout
    extends LayoutConfiguration<UsernamePasswordForm> {
  static const schemaName = '${UsernamePasswordForm.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Username Password Form Layout',
    fromJson: DefaultUsernamePasswordFormLayout.fromJson,
  );

  DefaultUsernamePasswordFormLayout()
      : super(schemaType: typeDescriptor.schemaType);

  factory DefaultUsernamePasswordFormLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultUsernamePasswordFormLayoutFromJson(json);

  @override
  Widget build(BuildContext context, UsernamePasswordForm content) {
    return UsernamePasswordView(content: content);
  }
}
