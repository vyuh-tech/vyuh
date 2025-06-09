// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username_password_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsernamePasswordForm _$UsernamePasswordFormFromJson(
        Map<String, dynamic> json) =>
    UsernamePasswordForm(
      showPasswordVisibilityToggle:
          json['showPasswordVisibilityToggle'] as bool? ?? false,
      actionType:
          $enumDecodeNullable(_$AuthActionTypeEnumMap, json['actionType']) ??
              AuthActionType.signIn,
      showLoginError: json['showLoginError'] as bool? ?? true,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      forgotPasswordAction: json['forgotPasswordAction'] == null
          ? null
          : Action.fromJson(
              json['forgotPasswordAction'] as Map<String, dynamic>),
      signupAction: json['signupAction'] == null
          ? null
          : Action.fromJson(json['signupAction'] as Map<String, dynamic>),
      loginAction: json['loginAction'] == null
          ? null
          : Action.fromJson(json['loginAction'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$AuthActionTypeEnumMap = {
  AuthActionType.signIn: 'signIn',
  AuthActionType.signUp: 'signUp',
};
