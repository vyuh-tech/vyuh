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

  User? get currentUser;

  Stream<User> get userChanges {
    if (!_initialized) {
      throw StateError(
          'AuthPlugin is not yet initialized. Call init() before accessing userChanges.');
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
