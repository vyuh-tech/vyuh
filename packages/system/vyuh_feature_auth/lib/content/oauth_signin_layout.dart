import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_auth/content/oauth_signin.dart';
import 'package:vyuh_feature_auth/ui/oauth_sign_in_view.dart';

part 'oauth_signin_layout.g.dart';

enum OAuthLayoutType {
  icon,
  text,
  iconText;
}

@JsonSerializable()
final class OAuthSignInLayout extends LayoutConfiguration<OAuthSignIn> {
  static const schemaName = '${OAuthSignIn.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default OAuth Sign In Layout',
    fromJson: OAuthSignInLayout.fromJson,
  );

  final OAuthLayoutType type;
  final Axis direction;

  OAuthSignInLayout(
      {this.type = OAuthLayoutType.iconText, this.direction = Axis.vertical})
      : super(schemaType: schemaName);

  factory OAuthSignInLayout.fromJson(Map<String, dynamic> json) =>
      _$OAuthSignInLayoutFromJson(json);

  @override
  Widget build(BuildContext context, OAuthSignIn content) {
    return OAuthSignInView(content: content, layout: this);
  }
}
