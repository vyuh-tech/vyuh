import 'package:feature_settings/feature_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings read from JSON, with no tabs by default', () {
    final settings = Settings.fromJson({'title': 'Home'});
    expect(settings.title, 'Home');
    expect(settings.tabs, isEmpty);
  });
}
