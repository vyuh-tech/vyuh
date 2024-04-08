import 'package:vyuh_core/vyuh_core.dart';

abstract class AuthException implements Exception {
  const AuthException(this.error);

  final Object error;
}

final class LoginMethodFailure extends AuthException {
  final LoginMethod method;
  const LoginMethodFailure(this.method, super.error);
}

final class LoginMethodCanceled extends AuthException {
  final LoginMethod method;
  const LoginMethodCanceled(this.method, super.error);
}

final class DeleteAccountFailure extends AuthException {
  const DeleteAccountFailure(super.error);
}

final class LogoutFailure extends AuthException {
  const LogoutFailure(super.error);
}

final class SendEmailLinkFailure extends AuthException {
  const SendEmailLinkFailure(super.error);
}
