// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileCard _$ProfileCardFromJson(Map<String, dynamic> json) => ProfileCard(
      loginAction: json['loginAction'] == null
          ? null
          : Action.fromJson(json['loginAction'] as Map<String, dynamic>),
      logoutAction: json['logoutAction'] == null
          ? null
          : Action.fromJson(json['logoutAction'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
