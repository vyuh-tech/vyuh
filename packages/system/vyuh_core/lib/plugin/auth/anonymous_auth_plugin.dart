import 'dart:async';

import 'package:vyuh_core/vyuh_core.dart';

final class AnonymousAuthPlugin extends AuthPlugin {
  AnonymousAuthPlugin()
      : super(
          title: 'Anonymous Auth Plugin',
          name: 'vyuh.plugin.auth.anonymous',
        );

  @override
  User? get currentUser => User.anonymous;

  @override
  Future<void> deleteAccount() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginAnonymously() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithApple() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithEmailLink(
      {required String email, required String link}) async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithEmailPassword(
      {required String email, required String password}) async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithGithub() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithGoogle() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithLinkedin() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithMeta() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithMicrosoft() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp}) async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> loginWithTwitter() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> logout() async {
    controller.add(User.anonymous);
  }

  @override
  Future<void> sendEmailLink(
      {required String email, required String clientId}) async {}
}
