import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart';

void main() {
  test('exposes the developer feature', () {
    expect(feature.name, 'developer');
    expect(feature.title, isNotEmpty);
    expect(feature.routes, isNotNull);
  });
}
