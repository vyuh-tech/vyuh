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
  AuthPlugin({required super.name, required super.title})
      : super();

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

  Future<void> loginAnonymously() {
    throw UnimplementedError();
  }

  Future<void> loginWithPhoneOtp(
      {required String phoneNumber, required String otp}) {
    throw UnimplementedError();
  }

  Future<void> loginWithEmailPassword(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  Future<void> sendEmailLink(
      {required String email, required String clientId}) {
    throw UnimplementedError();
  }

  Future<void> loginWithEmailLink(
      {required String email, required String link}) {
    throw UnimplementedError();
  }

  Future<void> loginWithGoogle() {
    throw UnimplementedError();
  }

  Future<void> loginWithMeta() {
    throw UnimplementedError();
  }

  Future<void> loginWithApple() {
    throw UnimplementedError();
  }

  Future<void> loginWithTwitter() {
    throw UnimplementedError();
  }

  Future<void> loginWithGithub() {
    throw UnimplementedError();
  }

  Future<void> loginWithLinkedin() {
    throw UnimplementedError();
  }

  Future<void> loginWithMicrosoft() {
    throw UnimplementedError();
  }

  /// Logs out the current user.
  Future<void> logout() {
    throw UnimplementedError();
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() {
    throw UnimplementedError();
  }
}
