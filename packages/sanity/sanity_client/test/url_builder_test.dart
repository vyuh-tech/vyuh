import 'package:flutter_test/flutter_test.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

void main() {
  for (var ref in [
    'invalid-ref',
    'imgInvalid-invalid-400x300-jpg',
  ]) {
    test('Invalid image-reference ($ref) throws exception', () {
      expect(
        () {
          getClient().imageUrl(ref);
        },
        throwsA(const TypeMatcher<InvalidReferenceException>()),
      );
    });
  }

  test('Valid image-reference generates proper image-url', () {
    final url = getClient()
        .imageUrl('image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg')
        .toString();
    expect(url, contains('Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000.jpg'));
    expect(url, contains('cdn.sanity.io/images/$project/$dataset/'));
  });

  for (var ref in [
    'invalid-ref',
    'fileInvalid-invalid-jpg',
  ]) {
    test('Invalid file-reference ($ref) throws exception', () {
      expect(
        () {
          getClient().fileUrl(ref);
        },
        throwsA(const TypeMatcher<AssertionError>()),
      );
    });
  }

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

  test('builds URL with all transformation parameters', () {
    final client = getClient();
    final url = client
        .imageUrl(
          'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
          width: 800,
          height: 600,
          devicePixelRatio: 2,
          quality: 80,
          format: 'webp',
        )
        .toString();

    expect(url, contains('w=800'));
    expect(url, contains('h=600'));
    expect(url, contains('dpr=2'));
    expect(url, contains('q=80'));
    expect(url, contains('fm=webp'));
  });

  test('validates image dimensions, dpr and quality', () {
    final client = getClient();

    // Dimension tests
    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        width: -1,
      ),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        height: -1,
      ),
      throwsA(isA<ArgumentError>()),
    );

    // DPR tests
    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        devicePixelRatio: -1,
      ),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        devicePixelRatio: 6,
      ),
      throwsA(isA<ArgumentError>()),
    );

    // Quality tests
    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        quality: -1,
      ),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => client.imageUrl(
        'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg',
        quality: 120,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
