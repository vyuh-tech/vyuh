import 'dart:io' show Platform;

/// Whether the code runs under `flutter test`, which sets `FLUTTER_TEST`.
bool get isFlutterTest => Platform.environment['FLUTTER_TEST'] == 'true';
