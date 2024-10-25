// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordForm _$ForgotPasswordFormFromJson(Map<String, dynamic> json) =>
    ForgotPasswordForm(
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      returnAction: json['returnAction'] == null
          ? null
          : Action.fromJson(json['returnAction'] as Map<String, dynamic>),
      showLoginError: json['showLoginError'] as bool? ?? true,
      layout: typeFromFirstOfListJson(json['layout']),
    );
