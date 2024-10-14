import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// An authentication plugin that supports various authentication methods.
abstract class AuthPlugin<TUser extends User> extends Plugin {
  /// The controller for the user changes stream.
  @protected
  var controller = StreamController<TUser>.broadcast();

  @protected
  var _initialized = false;

  /// Creates an instance of [AuthPlugin].
  AuthPlugin({required super.name, required super.title}) : super();

  /// The current user that is signed in.
  TUser get currentUser => throw UnimplementedError();

  /// A stream of user changes.
  Stream<TUser> get userChanges {
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

    controller = StreamController<TUser>.broadcast();

    _initialized = true;
  }

  static String _errorMessage(String methodName) {
    return '$methodName is not implemented. Configure the Auth Plugin to support this method.';
  }

  Future<void> loginAnonymously() {
    throw UnimplementedError(_errorMessage('loginAnonymously()'));
  }

  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp}) {
    throw UnimplementedError(_errorMessage('loginWithPhoneOtp()'));
  }

  Future<void> loginWithEmailPassword(
      {required String email, required String password}) {
    throw UnimplementedError(_errorMessage('loginWithEmailPassword()'));
  }

  Future<void> registerWithEmailPassword(
      {required String email, required String password}) {
    throw UnimplementedError(_errorMessage('registerWithEmailPassword()'));
  }

  Future<void> sendEmailLink(
      {required String email, required String clientId}) {
    throw UnimplementedError(_errorMessage('sendEmailLink()'));
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError(_errorMessage('sendPasswordResetEmail()'));
  }

  Future<void> loginWithEmailLink(
      {required String email, required String link}) {
    throw UnimplementedError(_errorMessage('loginWithEmailLink()'));
  }

  Future<void> loginWithOAuth(OAuthType type) {
    throw UnimplementedError(_errorMessage('loginWithOAuth()'));
  }

  /// Logs out the current user.
  Future<void> logout() {
    throw UnimplementedError(_errorMessage('logout()'));
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() {
    throw UnimplementedError(_errorMessage('deleteAccount()'));
  }
}

enum OAuthType {
  google,
  apple,
  meta,
  github,
  twitter,
  linkedin,
  microsoft,
  custom;

  LoginMethod get loginMethod => switch (this) {
        OAuthType.google => LoginMethod.google,
        OAuthType.apple => LoginMethod.apple,
        OAuthType.meta => LoginMethod.facebook,
        OAuthType.github => LoginMethod.github,
        OAuthType.twitter => LoginMethod.twitter,
        OAuthType.linkedin => LoginMethod.linkedin,
        OAuthType.microsoft => LoginMethod.microsoft,
        OAuthType.custom => LoginMethod.custom,
      };
}
