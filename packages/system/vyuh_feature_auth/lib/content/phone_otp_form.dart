import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/content/phone_otp_form_layout.dart';

part 'phone_otp_form.g.dart';

@JsonSerializable()
final class PhoneOtpForm extends ContentItem {
  static const schemaName = 'auth.phoneOtpForm';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Phone OTP Form',
    fromJson: PhoneOtpForm.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: DefaultPhoneOtpFormLayout.typeDescriptor,
    defaultLayout: DefaultPhoneOtpFormLayout(),
  );

  final bool showLoginError;
  final Action? action;
  final Action? getOtpAction;
  final Action? signupAction;

  PhoneOtpForm({
    this.action,
    this.getOtpAction,
    this.signupAction,
    this.showLoginError = true,
    super.layout,
  }) : super(schemaType: schemaName);

  factory PhoneOtpForm.fromJson(Map<String, dynamic> json) =>
      _$PhoneOtpFormFromJson(json);
}

final class PhoneOtpFormDescriptor extends ContentDescriptor {
  PhoneOtpFormDescriptor({super.layouts})
      : super(
          schemaType: PhoneOtpForm.schemaName,
          title: 'Phone OTP Form',
        );
}
