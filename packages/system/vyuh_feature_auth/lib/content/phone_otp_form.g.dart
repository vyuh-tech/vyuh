// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_otp_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneOtpForm _$PhoneOtpFormFromJson(Map<String, dynamic> json) => PhoneOtpForm(
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      getOtpAction: json['getOtpAction'] == null
          ? null
          : Action.fromJson(json['getOtpAction'] as Map<String, dynamic>),
      signupAction: json['signupAction'] == null
          ? null
          : Action.fromJson(json['signupAction'] as Map<String, dynamic>),
      showLoginError: json['showLoginError'] as bool? ?? true,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
