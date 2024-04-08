import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract base class AuthPlugin extends Plugin {
  @protected
  var controller = StreamController<User>.broadcast();

  @protected
  var _initialized = false;

  AuthPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.auth);

  Stream<User> get user {
    if (!_initialized) {
      throw StateError('Plugin not initialized');
    }

    return controller.stream;
  }

  @override
  @mustCallSuper
  Future<void> dispose() async {
    _initialized = false;
    unawaited(controller.close());
  }

  @override
  @mustCallSuper
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    controller = StreamController<User>.broadcast();

    _initialized = true;
  }

  Future<void> loginAnonymously();

  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp});
  Future<void> loginWithEmailPassword(
      {required String username, required String password});
  Future<void> sendEmailLink({required String email, required String clientId});
  Future<void> loginWithEmailLink(
      {required String email, required String link});

  Future<void> loginWithGoogle();
  Future<void> loginWithMeta();
  Future<void> loginWithApple();
  Future<void> loginWithTwitter();
  Future<void> loginWithGithub();
  Future<void> loginWithLinkedin();
  Future<void> loginWithMicrosoft();

  Future<void> logout();

  Future<void> deleteAccount();
}

class User {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final LoginMethod loginMethod;

  const User({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoUrl,
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
