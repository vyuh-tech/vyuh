import 'package:flutter_test/flutter_test.dart';
import 'package:sanity_client/sanity_client.dart';

import 'util.dart';

void main() {
  group('SanityConfig Assertions', () {
    test('Accepts valid configuration with defaults', () {
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
        ),
        returnsNormally,
      );
    });

    test('When useCdn is true, perspective must be set to published', () {
      // Valid case: useCdn=true with perspective=published
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          useCdn: true,
          perspective: Perspective.published,
        ),
        returnsNormally,
      );

      // Invalid case: useCdn=true with perspective=raw
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          useCdn: true,
          perspective: Perspective.raw,
        ),
        throwsA(isA<AssertionError>()),
      );

      // Invalid case: useCdn=true with perspective=drafts
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          useCdn: true,
          perspective: Perspective.drafts,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('When useCdn is false, perspective must be set to raw or drafts', () {
      // Valid case: useCdn=false with perspective=raw
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          useCdn: false,
          perspective: Perspective.raw,
        ),
        returnsNormally,
      );

      // Valid case: useCdn=false with perspective=drafts
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          useCdn: false,
          perspective: Perspective.drafts,
        ),
        returnsNormally,
      );

      // Invalid case: useCdn=false with perspective=published
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          useCdn: false,
          perspective: Perspective.published,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Token is required when perspective is not set to published', () {
      // Valid case: perspective=published with no token
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: null,
          perspective: Perspective.published,
        ),
        returnsNormally,
      );

      // Invalid case: perspective=raw with no token
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: null,
          perspective: Perspective.raw,
        ),
        throwsA(isA<AssertionError>()),
      );

      // Invalid case: perspective=drafts with no token
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: null,
          perspective: Perspective.drafts,
        ),
        throwsA(isA<AssertionError>()),
      );

      // Invalid case: perspective=raw with empty token
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: '',
          perspective: Perspective.raw,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('API version must match the format vYYYY-MM-DD', () {
      // Valid case: correct format
      expect(
        () => SanityConfig(
          projectId: project,
          dataset: dataset,
          token: token,
          apiVersion: 'v2023-01-01',
        ),
        returnsNormally,
      );

      // Invalid cases: incorrect formats
      final invalidFormats = [
        'invalid',
        '2023-01-01',
        'v23-01-01',
        'v2023-1-1',
        'vYYYY-MM-DD',
      ];

      for (final format in invalidFormats) {
        expect(
          () => SanityConfig(
            projectId: project,
            dataset: dataset,
            token: token,
            apiVersion: format,
          ),
          throwsA(isA<AssertionError>()),
          reason: 'Format "$format" should be invalid',
        );
      }
    });

    test('Default API version follows the correct format', () {
      final defaultVersion = SanityConfig.defaultApiVersion;
      final regex = RegExp(r'^v\d{4}-\d{2}-\d{2}$');

      expect(regex.hasMatch(defaultVersion), isTrue);
    });
  });
}
