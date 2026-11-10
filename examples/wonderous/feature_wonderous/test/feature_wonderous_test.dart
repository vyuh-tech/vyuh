import 'package:feature_wonderous/feature_wonderous.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the wonderous feature', () {
    expect(feature.name, 'wonderous');
    expect(feature.title, isNotEmpty);
  });
}
