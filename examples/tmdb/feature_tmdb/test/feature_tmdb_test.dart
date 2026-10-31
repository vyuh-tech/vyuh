import 'package:feature_tmdb/feature_tmdb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes the tmdb feature', () {
    expect(feature.name, 'tmdb');
    expect(feature.title, isNotEmpty);
  });
}
