import 'package:feature_food/feature_food.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the food feature', () {
    expect(feature.name, 'food');
    expect(feature.title, isNotEmpty);
  });
}
