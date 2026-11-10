import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:vyuh_core/vyuh_core.dart';

final class _TestAuthPlugin extends AuthPlugin {
  _TestAuthPlugin() : super(name: 'test.auth', title: 'Test Auth');

  @override
  String get token => 'token';

  @override
  String get refreshToken => 'refresh';

  void signIn(User user) => setCurrentUser(user);
}

const _alice = User(
  id: 'alice',
  name: 'Alice',
  email: 'alice@example.com',
  loginMethod: LoginMethod.emailPassword,
);

Matcher _unimplemented(String method) => throwsA(
  isA<UnimplementedError>().having(
    (e) => e.message,
    'message',
    '$method is not implemented. Configure the Auth Plugin to support this method.',
  ),
);

void main() {
  group('AuthPlugin', () {
    late _TestAuthPlugin auth;

    setUp(() => auth = _TestAuthPlugin());

    test('starts with the unknown user', () {
      expect(auth.currentUser, User.unknown);
      expect(auth.currentUser.isUnknown, isTrue);
    });

    test('userChanges is unavailable before init', () {
      expect(() => auth.userChanges, throwsStateError);
    });

    test('setCurrentUser updates the user and emits on userChanges', () async {
      await auth.init();
      final emitted = expectLater(auth.userChanges, emits(_alice));

      auth.signIn(_alice);

      await emitted;
      expect(auth.currentUser, _alice);
      expect(auth.currentUser.isUnknown, isFalse);
    });

    test('init is idempotent and dispose closes the stream', () async {
      await auth.init();
      final stream = auth.userChanges;
      final emitted = expectLater(stream, emits(_alice));

      // A second init keeps the same controller, so listeners still hear.
      await auth.init();
      auth.signIn(_alice);
      await emitted;

      final done = expectLater(stream, emitsDone);
      await auth.dispose();
      await done;
      expect(() => auth.userChanges, throwsStateError);
    });

    test('a re-init after dispose opens a fresh stream', () async {
      await auth.init();
      await auth.dispose();
      await auth.init();

      final emitted = expectLater(auth.userChanges, emits(_alice));
      auth.signIn(_alice);
      await emitted;
    });

    test('unconfigured login methods fail with UnimplementedError', () async {
      await expectLater(
        auth.loginAnonymously(),
        _unimplemented('loginAnonymously()'),
      );
      await expectLater(
        auth.sendOtp(phoneNumber: '1'),
        _unimplemented('sendOtp()'),
      );
      await expectLater(
        auth.loginWithPhoneOtp(phoneNumber: '1', otp: '2'),
        _unimplemented('loginWithPhoneOtp()'),
      );
      await expectLater(
        auth.loginWithEmailPassword(email: 'a', password: 'b'),
        _unimplemented('loginWithEmailPassword()'),
      );
      await expectLater(
        auth.registerWithEmailPassword(email: 'a', password: 'b'),
        _unimplemented('registerWithEmailPassword()'),
      );
      await expectLater(
        auth.sendEmailLink(email: 'a', clientId: 'c'),
        _unimplemented('sendEmailLink()'),
      );
      await expectLater(
        auth.sendPasswordResetEmail(email: 'a'),
        _unimplemented('sendPasswordResetEmail()'),
      );
      await expectLater(
        auth.loginWithEmailLink(email: 'a', link: 'l'),
        _unimplemented('loginWithEmailLink()'),
      );
      await expectLater(
        auth.loginWithOAuth(OAuthType.google),
        _unimplemented('loginWithOAuth()'),
      );
      await expectLater(auth.logout(), _unimplemented('logout()'));
      await expectLater(
        auth.deleteAccount(),
        _unimplemented('deleteAccount()'),
      );
    });

    test('refreshSession reports no refresh support by default', () async {
      expect(await auth.refreshSession(), isFalse);
    });
  });

  group('UnknownAuthPlugin', () {
    test('always reports the unknown user and empty tokens', () {
      final auth = UnknownAuthPlugin();
      expect(auth.currentUser, User.unknown);
      expect(auth.token, isEmpty);
      expect(auth.refreshToken, isEmpty);
      expect(auth.name, 'vyuh.plugin.auth.unknown');
    });
  });

  group('OAuthType.loginMethod', () {
    test('maps every provider to its login method', () {
      expect(
        {for (final t in OAuthType.values) t: t.loginMethod},
        {
          OAuthType.google: LoginMethod.google,
          OAuthType.apple: LoginMethod.apple,
          OAuthType.meta: LoginMethod.facebook,
          OAuthType.github: LoginMethod.github,
          OAuthType.twitter: LoginMethod.twitter,
          OAuthType.linkedin: LoginMethod.linkedin,
          OAuthType.microsoft: LoginMethod.microsoft,
          OAuthType.custom: LoginMethod.custom,
        },
      );
    });
  });

  group('LoginMethod', () {
    test('labels every method', () {
      expect(
        {for (final m in LoginMethod.values) m: m.label()},
        {
          LoginMethod.unknown: 'Unknown',
          LoginMethod.anonymous: 'Anonymous',
          LoginMethod.emailPassword: 'Email/Password',
          LoginMethod.phoneOtp: 'Phone OTP',
          LoginMethod.emailLink: 'Email Link',
          LoginMethod.google: 'Google',
          LoginMethod.facebook: 'Facebook',
          LoginMethod.apple: 'Apple',
          LoginMethod.twitter: 'Twitter',
          LoginMethod.github: 'GitHub',
          LoginMethod.linkedin: 'LinkedIn',
          LoginMethod.microsoft: 'Microsoft',
          LoginMethod.custom: 'Custom',
        },
      );
    });

    test('gives every method an icon', () {
      expect(
        {for (final m in LoginMethod.values) m: m.icon()},
        {
          LoginMethod.unknown: Icons.help,
          LoginMethod.anonymous: Icons.person,
          LoginMethod.emailPassword: Icons.email,
          LoginMethod.phoneOtp: Icons.phone,
          LoginMethod.emailLink: Icons.link,
          LoginMethod.google: Icons.verified_user,
          LoginMethod.facebook: Icons.verified_user,
          LoginMethod.apple: Icons.verified_user,
          LoginMethod.twitter: Icons.verified_user,
          LoginMethod.github: Icons.verified_user,
          LoginMethod.linkedin: Icons.verified_user,
          LoginMethod.microsoft: Icons.verified_user,
          LoginMethod.custom: Icons.help,
        },
      );
    });
  });

  group('AuthException', () {
    test('each failure carries its error and describes itself', () {
      final cause = StateError('boom');
      final failures = <AuthException>[
        LoginMethodFailure(LoginMethod.google, cause),
        CreateUserFailure(cause),
        LoginMethodCanceled(LoginMethod.apple, cause),
        DeleteAccountFailure(cause),
        LogoutFailure(cause),
        SendEmailLinkFailure(cause),
        SendPasswordResetEmailFailure(cause),
      ];

      for (final failure in failures) {
        expect(failure.error, same(cause));
        expect(failure.toString(), '[${failure.runtimeType}] $cause');
      }

      expect((failures[0] as LoginMethodFailure).method, LoginMethod.google);
      expect((failures[2] as LoginMethodCanceled).method, LoginMethod.apple);
    });
  });
}
