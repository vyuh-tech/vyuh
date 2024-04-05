import 'package:flutter_test/flutter_test.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

void main() {
  [
    'invalid-ref',
    'imgInvalid-invalid-400x300-jpg',
  ].forEach((ref) {
    test('Invalid image-reference ($ref) throws exception', () {
      expect(
        () {
          getClient().imageUrl(ref);
        },
        throwsA(const TypeMatcher<InvalidReferenceException>()),
      );
    });
  });

  test('Valid image-reference generates proper image-url', () {
    final url = getClient()
        .imageUrl('image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg')
        .toString();
    expect(url, contains('Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000.jpg'));
    expect(url, contains('cdn.sanity.io/images/$project/$dataset/'));
  });

  [
    'invalid-ref',
    'fileInvalid-invalid-jpg',
  ].forEach((ref) {
    test('Invalid file-reference ($ref) throws exception', () {
      expect(
        () {
          getClient().fileUrl(ref);
        },
        throwsA(const TypeMatcher<AssertionError>()),
      );
    });
  });

  test('Valid file-reference generates proper file-url', () {
    final url = getClient()
        .fileUrl(
          'file-a3dabbe0f73305c46baeedadcea3e4f7b944a968-json',
        )
        .toString();
    expect(url, contains('a3dabbe0f73305c46baeedadcea3e4f7b944a968.json'));
    expect(url, contains('cdn.sanity.io/files/$project/$dataset/'));
  });

  test('Parameters are included in query', () {
    final url = getClient()
        .imageUrl(
          'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
          devicePixelRatio: 1,
          format: 'auto',
          width: 100,
          height: 100,
          quality: 45,
        )
        .toString();
    expect(url, contains('w=100'));
    expect(url, contains('h=100'));
    expect(url, contains('dpr=1'));
    expect(url, contains('q=45'));
    expect(url, contains('fm=auto'));
  });
}
