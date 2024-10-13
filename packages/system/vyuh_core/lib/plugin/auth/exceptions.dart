import 'package:vyuh_core/vyuh_core.dart';

/// Base type for all Authentication related exceptions.
abstract class AuthException implements Exception {
  /// Create an exception with the given error.
  const AuthException(this.error);

  /// The error that caused this exception.
  final Object error;

  @override
  String toString() {
    return '[$runtimeType] $error';
  }
}

/// Exception thrown when a login method fails.
final class LoginMethodFailure extends AuthException {
  /// The login method that failed.
  final LoginMethod method;

  /// Create a new LoginMethodFailure with the given method and error.
  const LoginMethodFailure(this.method, super.error);
}

/// Exception thrown when a login method is canceled.
final class LoginMethodCanceled extends AuthException {
  /// The login method that was canceled.
  final LoginMethod method;

  /// Create a new LoginMethodCanceled with the given method and error.
  const LoginMethodCanceled(this.method, super.error);
}

/// Exception thrown when the account deletion fails.
final class DeleteAccountFailure extends AuthException {
  /// Create a new DeleteAccountFailure with the given error.
  const DeleteAccountFailure(super.error);
}

/// Exception thrown when the logout fails.
final class LogoutFailure extends AuthException {
  /// Create a new LogoutFailure with the given error.
  const LogoutFailure(super.error);
}

/// Exception thrown when sending an email-link for logging in.
final class SendEmailLinkFailure extends AuthException {
  /// Create a new SendEmailLinkFailure with the given error.
  const SendEmailLinkFailure(super.error);
}

/// Exception thrown when sending a password reset email.
final class SendPasswordResetEmailFailure extends AuthException {
  /// Create a new SendPasswordResetEmailFailure with the given error.
  const SendPasswordResetEmailFailure(super.error);
}
