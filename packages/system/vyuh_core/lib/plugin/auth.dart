import 'package:vyuh_core/vyuh_core.dart';

abstract base class AuthPlugin extends Plugin {
  AuthPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.auth);

  // login
  Future<User> loginWithEmailPassword(
      {required String username, required String password});

  // logout
  Future<void> logout();
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final LoginMethod loginMethod;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.loginMethod = LoginMethod.anonymous,
  });
}

enum LoginMethod {
  anonymous,
  emailPassword,
  phoneOtp,
  google,
  meta,
  apple,
  twitter,
  github,
  linkedin,
  microsoft,
}
