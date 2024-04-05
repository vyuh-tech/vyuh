import 'package:http/http.dart';
import 'package:sanity_client/sanity_client.dart';

const project = 'test-project';
const dataset = 'test-dataset';
const token = 'test-token';

SanityClient getClient({
  final Client? httpClient,
  String? apiVersion,
  bool? explainQuery,
  Perspective? perspective,
  bool? useCdn,
}) =>
    SanityClient(
      SanityConfig(
        projectId: project,
        dataset: dataset,
        token: token,
        apiVersion: apiVersion,
        explainQuery: explainQuery,
        perspective: perspective,
        useCdn: useCdn,
      ),
      httpClient: httpClient,
    );
