import 'dart:async';

import 'package:vyuh_core/vyuh_core.dart';

/// An authentication plugin that does not support any authentication methods.
final class UnknownAuthPlugin extends AuthPlugin {
  /// Creates an instance of [UnknownAuthPlugin].
  UnknownAuthPlugin()
      : super(
          title: 'Unknown Auth Plugin',
          name: 'vyuh.plugin.auth.unknown',
        );

  @override
  User get currentUser => User.unknown;

  @override
  Future<void> deleteAccount() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginAnonymously() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithApple() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithEmailLink(
      {required String email, required String link}) async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithEmailPassword(
      {required String email, required String password}) async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithGithub() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithGoogle() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithLinkedin() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithMeta() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithMicrosoft() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp}) async {
    controller.add(User.unknown);
  }

  @override
  Future<void> loginWithTwitter() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> logout() async {
    controller.add(User.unknown);
  }

  @override
  Future<void> sendEmailLink(
      {required String email, required String clientId}) async {}
}
