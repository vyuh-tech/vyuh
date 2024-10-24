import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_auth/content/oauth_signin_layout.dart';

part 'oauth_signin.g.dart';

@JsonSerializable()
final class OAuthSignIn extends ContentItem {
  static const schemaName = 'auth.oauthSignIn';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'OAuth Sign In',
    fromJson: OAuthSignIn.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: OAuthSignInLayout.typeDescriptor,
    defaultLayout: OAuthSignInLayout(),
  );

  final List<OAuthType> authTypes;
  final bool showLoginError;
  final Action? action;

  OAuthSignIn({
    this.authTypes = const [],
    this.showLoginError = true,
    this.action,
    super.layout,
  }) : super(schemaType: schemaName);

  factory OAuthSignIn.fromJson(Map<String, dynamic> json) =>
      _$OAuthSignInFromJson(json);
}

final class OAuthSignInDescriptor extends ContentDescriptor {
  OAuthSignInDescriptor({super.layouts})
      : super(
          schemaType: OAuthSignIn.schemaName,
          title: 'OAuth Sign In',
        );
}
