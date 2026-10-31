import 'package:flutter_test/flutter_test.dart';
import 'package:{{ name.snakeCase() }}/{{ name.snakeCase() }}.dart';

void main() {
  test('exposes the {{ name.snakeCase() }} feature', () {
    expect(feature.name, '{{ name.snakeCase() }}');
    expect(feature.routes, isNotNull);
  });
}
