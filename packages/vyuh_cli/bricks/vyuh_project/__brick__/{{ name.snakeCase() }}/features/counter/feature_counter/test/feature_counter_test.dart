import 'package:feature_counter/feature_counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the counter feature', () {
    expect(feature.name, 'counter');
    expect(feature.title, isNotEmpty);
    expect(feature.routes, isNotNull);
  });
}
