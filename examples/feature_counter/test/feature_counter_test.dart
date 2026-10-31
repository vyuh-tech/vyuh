import 'package:feature_counter/feature_counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the feature_counter feature', () {
    expect(feature.name, 'feature_counter');
    expect(feature.title, isNotEmpty);
    expect(feature.routes, isNotNull);
  });
}
