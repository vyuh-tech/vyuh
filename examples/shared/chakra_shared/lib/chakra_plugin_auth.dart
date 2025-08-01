import 'package:vyuh_core/vyuh_core.dart';

final class ChakraUser extends User {
  ChakraUser({
    required super.id,
    super.email,
    super.name,
    super.phoneNumber,
    super.photoUrl,
    required super.loginMethod,
  }) : super();
}

final class ChakraAuthPlugin extends AuthPlugin {
  ChakraAuthPlugin()
      : super(name: 'chakra.plugin.auth', title: 'Chakra Auth Plugin');

  @override
  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp}) async {
    await Future.delayed(const Duration(seconds: 1));

    setCurrentUser(ChakraUser(
      id: 'chakra-user',
      name: 'Chakra User',
      phoneNumber: phoneNumber,
      loginMethod: LoginMethod.phoneOtp,
    ));
  }

  @override
  Future<void> loginWithEmailPassword(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));

    setCurrentUser(ChakraUser(
      id: 'chakra-user',
      name: 'Chakra User',
      email: email,
      loginMethod: LoginMethod.emailPassword,
    ));
  }

  @override
  Future<void> loginWithOAuth(OAuthType type) async {
    await Future.delayed(const Duration(seconds: 1));

    setCurrentUser(ChakraUser(
      id: 'chakra-user',
      name: 'Chakra User',
      loginMethod: type.loginMethod,
    ));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));

    setCurrentUser(User.unknown);
  }

  @override
  // TODO: implement refreshToken
  String get refreshToken => throw UnimplementedError();

  @override
  // TODO: implement token
  String get token => throw UnimplementedError();
}
