import 'package:feature_puzzles/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('puzzlesPathResolver', () {
    test('resolves path containing /puzzles/level/:id', () {
      final result = puzzlesPathResolver(
        '/puzzles/level/1ee5c6a3-d81e-49fa-951b-45edca88cf5c',
      );
      expect(result, '/puzzles/level');
    });

    test('returns original path if no match', () {
      final result = puzzlesPathResolver('/other/path');
      expect(result, '/other/path');
    });
  });
}
