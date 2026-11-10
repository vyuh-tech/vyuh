import 'package:feature_misc/feature_misc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the misc feature', () {
    expect(feature.name, 'misc');
    expect(feature.title, isNotEmpty);
    expect(feature.routes, isNotNull);
  });
}
