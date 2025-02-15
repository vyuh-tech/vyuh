import 'package:sanity_client/sanity_client.dart';

Future<void> main() async {
  // using the SanityClient
  var client = SanityClient(
    SanityConfig(
      projectId: '8b76lu9s',
      dataset: 'production',
      perspective: Perspective.previewDrafts,
      useCdn: false,
      token:
          'skt2tSTitRob9TonNNubWg09bg0dACmwE0zHxSePlJisRuF1mWJOvgg3ZF68CAWrqtSIOzewbc56dGavACyznDTsjm30ws874WoSH3E5wPMFrqVW8C0Hc0pJGzpYQiehfL9GTRrIyoO3y2aBQIxHpegGspzxAevZcchleelaH5uM6LAnOJT1',
      explainQuery: true,
    ),
  );

  // make a query
  var query = '''
    *[_type == "vyuh.document" && identifier.current == "hello-world"][0]
  ''';

  final stream = client.fetchLive(query);

  await for (var response in stream) {
    // ignore: avoid_print
    print(response.result);
    print('--------------------');
  }
}
