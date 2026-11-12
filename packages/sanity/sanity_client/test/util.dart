import 'dart:async';

import 'package:http/http.dart';
import 'package:sanity_client/sanity_client.dart';

const project = 'test-project';
const dataset = 'test-dataset';
const token = 'test-token';

SanityClient getClient({
  Client? httpClient,
  String? apiVersion,
  bool? explainQuery,
  Perspective? perspective = Perspective.published,
  bool? useCdn = true,
}) => SanityClient(
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

/// Lets pending microtasks and zero-length timers run.
Future<void> flush() => Future<void>.delayed(Duration.zero);

/// One request for the live event stream, answered by the test.
final class LiveCall {
  LiveCall(this.request) {
    if (request case Abortable(:final abortTrigger?)) {
      abortTrigger.whenComplete(() => aborted = true);
    }
  }

  final BaseRequest request;
  final _response = Completer<StreamedResponse>();

  /// Whether the caller aborted the request.
  bool aborted = false;

  /// Whether the caller cancelled its subscription to the response body.
  bool bodyCancelled = false;

  Future<StreamedResponse> get response => _response.future;

  /// Answers with a streamed response and returns the controller of its body.
  /// With a [body] the response is complete; otherwise it stays open.
  StreamController<List<int>> open({
    int status = 200,
    String contentType = 'text/event-stream',
    String? body,
  }) {
    final controller = StreamController<List<int>>(
      onCancel: () => bodyCancelled = true,
    );
    _response.complete(
      StreamedResponse(
        controller.stream,
        status,
        headers: {'content-type': contentType},
        request: request,
      ),
    );
    if (body != null) {
      controller.add(body.codeUnits);
      controller.close();
    }
    return controller;
  }

  /// Fails the request before any response.
  void fail(Object error) => _response.completeError(error);
}

/// A fake [Client]: live event requests wait in [live] for the test to answer;
/// every other request is answered by [onQuery].
final class LiveHttp extends BaseClient {
  LiveHttp({this.onQuery});

  final Future<Response> Function(BaseRequest request)? onQuery;
  final live = <LiveCall>[];

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (request.headers['Accept'] == 'text/event-stream') {
      final call = LiveCall(request);
      live.add(call);
      return call.response;
    }
    final response = await onQuery!(request);
    return StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}
