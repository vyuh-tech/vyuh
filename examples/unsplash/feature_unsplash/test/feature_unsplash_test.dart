import 'package:feature_unsplash/feature_unsplash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the unsplash feature', () {
    expect(feature.name, 'unsplash');
    expect(feature.title, isNotEmpty);
  });
}
