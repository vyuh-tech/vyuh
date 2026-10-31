import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_client/tmdb_client.dart';

void main() {
  test('a genre reads from JSON', () {
    final genre = Genre.fromJson({'id': 28, 'name': 'Action'});
    expect(genre.id, 28);
    expect(genre.name, 'Action');
  });
}
