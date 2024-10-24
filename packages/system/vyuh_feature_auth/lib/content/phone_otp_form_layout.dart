import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/phone_otp_form.dart';
import 'package:vyuh_feature_auth/ui/phone_otp_view.dart';

part 'phone_otp_form_layout.g.dart';

@JsonSerializable()
final class DefaultPhoneOtpFormLayout
    extends LayoutConfiguration<PhoneOtpForm> {
  static const schemaName = '${PhoneOtpForm.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Email Password Form Layout',
    fromJson: DefaultPhoneOtpFormLayout.fromJson,
  );

  DefaultPhoneOtpFormLayout() : super(schemaType: typeDescriptor.schemaType);

  factory DefaultPhoneOtpFormLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultPhoneOtpFormLayoutFromJson(json);

  @override
  Widget build(BuildContext context, PhoneOtpForm content) {
    return PhoneOTPView(content: content);
  }
}
