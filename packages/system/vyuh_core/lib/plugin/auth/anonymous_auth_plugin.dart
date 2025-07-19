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
  String get refreshToken => '';

  @override
  String get token => '';
}
