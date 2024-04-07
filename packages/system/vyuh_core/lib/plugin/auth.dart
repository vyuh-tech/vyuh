import 'package:vyuh_core/vyuh_core.dart';

abstract base class AuthPlugin extends Plugin {
  AuthPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.auth);

  Future<User> loginAnonymously();

  Future<User> loginWithPhoneOtp({required String phoneNumber});
  Future<User> loginWithEmailPassword(
      {required String username, required String password});
  Future<void> sendEmailLink({required String email, required String clientId});
  Future<User> loginWithEmailLink(
      {required String email, required String link});

  Future<User> loginWithGoogle();
  Future<User> loginWithMeta();
  Future<User> loginWithApple();
  Future<User> loginWithTwitter();
  Future<User> loginWithGithub();
  Future<User> loginWithLinkedin();
  Future<User> loginWithMicrosoft();

  Future<void> logout();

  Future<void> deleteAccount();
}

class User {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final LoginMethod loginMethod;

  const User({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.loginMethod = LoginMethod.anonymous,
  });

  bool get isAnonymous => this == anonymous;

  static const anonymous = User(
    id: 'anonymous',
  );
}

enum LoginMethod {
  anonymous,
  emailPassword,
  phoneOtp,
  emailLink,
  google,
  meta,
  apple,
  twitter,
  github,
  linkedin,
  microsoft,
}
