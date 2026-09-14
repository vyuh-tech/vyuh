import 'dart:convert';
import 'dart:io';

/// Configure existing pub.dev OAuth credentials on the disposable CI runner.
void main() {
  final accessToken = Platform.environment['OAUTH_ACCESS_TOKEN'];
  final refreshToken = Platform.environment['OAUTH_REFRESH_TOKEN'];
  final homeDirectory = Platform.environment['HOME'];
  if (accessToken == null ||
      accessToken.isEmpty ||
      refreshToken == null ||
      refreshToken.isEmpty ||
      homeDirectory == null ||
      !Platform.isLinux) {
    throw StateError(
      'Publishing requires existing OAuth secrets on a Linux runner.',
    );
  }
  final directory = Directory('$homeDirectory/.config/dart')
    ..createSync(recursive: true);
  File('${directory.path}/pub-credentials.json').writeAsStringSync(
    jsonEncode({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenEndpoint': 'https://accounts.google.com/o/oauth2/token',
      'scopes': ['openid', 'https://www.googleapis.com/auth/userinfo.email'],
      'expiration': 0,
    }),
  );
}
