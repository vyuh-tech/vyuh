import 'package:eventflux/client.dart';

/// The various perspectives that can be used to fetch data from Sanity
enum Perspective {
  /// Fetch all documents including drafts
  raw,

  /// Fetch drafts as if they were published.
  ///
  /// Note: Queries using the drafts perspective are not cached on the CDN,
  /// and will return an error if [useCdn] is not set to true.
  /// You should always explicitly set [useCdn] to false when using `drafts`.
  drafts,

  /// Fetch only the published documents
  published,
}

/// Configuration for the Sanity client
final class SanityConfig {
  /// The dataset to fetch data from
  final String dataset;

  /// The project id
  final String projectId;

  /// The token to use for authentication
  final String? token;

  /// Whether to use the CDN or not
  final bool useCdn;

  /// The API version to use. It follows the format `vYYYY-MM-DD`
  final String apiVersion;

  /// The perspective to use
  final Perspective perspective;

  /// Whether to explain the query or not
  final bool explainQuery;

  /// The default API version to use
  static final String defaultApiVersion = (() {
    final today = DateTime.now();
    final parts = [
      today.year.toString(),
      today.month.toString().padLeft(2, '0'),
      today.day.toString().padLeft(2, '0')
    ].join('-');

    return 'v$parts';
  })();

  static EventFlux Function() createEventFlux = () => EventFlux.spawn();

  /// Creates a new Sanity configuration for fetching documents from a project and dataset
  SanityConfig({
    required this.projectId,
    required this.dataset,
    this.token,
    String? apiVersion,
    bool? useCdn,
    Perspective? perspective,
    bool? explainQuery,
  })  : useCdn = useCdn ?? true,
        apiVersion = apiVersion ?? defaultApiVersion,
        perspective = perspective ?? Perspective.published,
        explainQuery = explainQuery ?? false {
    if (this.useCdn) {
      assert(this.perspective == Perspective.published,
          'When useCdn is true, perspective can only be set to published');
    } else {
      assert(
          this.perspective == Perspective.raw ||
              this.perspective == Perspective.drafts,
          'When useCdn is false, perspective must be either raw or drafts');
    }

    if (this.perspective != Perspective.published) {
      // Token is required for accessing draft content
      assert(token != null && token!.trim().isNotEmpty, '''
Invalid Token provided. 
Setup an API token, with Viewer access, in the Sanity Management Console.
Without a valid token you will not be able to fetch data from Sanity.''');
    }

    assert(RegExp(r'^v\d{4}-\d{2}-\d{2}$').hasMatch(this.apiVersion),
        'Invalid API version provided. It should follow the format `vYYYY-MM-DD`');
  }
}
