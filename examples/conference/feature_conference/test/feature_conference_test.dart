import 'package:feature_conference/feature_conference.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the feature_conference feature', () {
    expect(feature.name, 'feature_conference');
    expect(feature.title, isNotEmpty);
  });
}
