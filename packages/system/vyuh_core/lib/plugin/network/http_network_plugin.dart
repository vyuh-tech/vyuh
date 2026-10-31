import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'http_network_plugin_stub.dart'
    if (dart.library.html) 'http_network_plugin_web.dart';

@Deprecated(
  'Not used by HttpNetworkPlugin. Pass timeout and retryOptions to it instead.',
)
final class HttpNetworkConfig {
  final Duration timeout;
  final int maxRetryAttempts;
  final Duration maxRetryDelay;

  const HttpNetworkConfig(
      {required this.timeout,
      required this.maxRetryAttempts,
      required this.maxRetryDelay});

  static const standard = HttpNetworkConfig(
    timeout: Duration(seconds: 5),
    maxRetryAttempts: 3,
    maxRetryDelay: Duration(seconds: 10),
  );
}

final class HttpNetworkPlugin extends NetworkPlugin {
  late Client _client;
  bool _initialized = false;

  final RetryOptions _retryOptions;
  final Duration _timeout;
  final bool _webIncludeCredentials;

  /// Creates an HTTP network plugin.
  ///
  /// Every request, including [read], [readBytes] and [send], fails with a
  /// [TimeoutException] after [timeout] (30 seconds by default). Requests
  /// other than [send] are retried on socket errors and timeouts, as
  /// [retryOptions] says (3 attempts by default). [send] is not retried,
  /// because a streamed request can only be sent once.
  ///
  /// [webIncludeCredentials] - When true and running on web, uses browser's fetch API
  /// with credentials: 'include' to send HTTP-only cookies with cross-origin requests.
  /// This is essential for session-based authentication with HTTP-only cookies.
  HttpNetworkPlugin({
    Client? client,
    RetryOptions? retryOptions,
    Duration? timeout,
    this._webIncludeCredentials = true,
  })  : _retryOptions = retryOptions ??
            const RetryOptions(
              maxAttempts: 3,
              delayFactor: Duration(milliseconds: 200),
            ),
        _timeout = timeout ?? const Duration(seconds: 30),
        super(name: 'vyuh.plugin.network.http', title: 'HTTP Network Plugin') {
    if (client != null) {
      _client = client;
      _initialized = true;
    }
  }

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    // Use BrowserClient for web when credentials are needed.
    // kIsWeb is a compile-time constant, so the VM drops this branch.
    // coverage:ignore-start
    if (kIsWeb && _webIncludeCredentials) {
      _client = createWebClient();
      // coverage:ignore-end
    } else {
      _client = Client();
    }
    _initialized = true;
  }

  @override
  Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    _client.close();
    _initialized = false;
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      _withRetryAndTimeout(() => _client.get(url, headers: headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _withRetryAndTimeout(() => _client.head(url, headers: headers));

  @override
  Future<Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _withRetryAndTimeout(() =>
          _client.post(url, headers: headers, body: body, encoding: encoding));

  @override
  Future<Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _withRetryAndTimeout(() =>
          _client.put(url, headers: headers, body: body, encoding: encoding));

  @override
  Future<Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _withRetryAndTimeout(() => _client.delete(url,
          headers: headers, body: body, encoding: encoding));

  @override
  Future<Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _withRetryAndTimeout(() =>
          _client.patch(url, headers: headers, body: body, encoding: encoding));

  Future<T> _withRetryAndTimeout<T>(Future<T> Function() fn) =>
      _retryOptions.retry(
        () => fn().timeout(_timeout),
        retryIf: (e) {
          // Use the string based to check to avoid importing dart:io.
          // This makes it easier to use this plugin in web.
          return (e.toString().contains('SocketException')) ||
              e is TimeoutException;
        },
      );

  /// Does nothing. The client is shared by every feature, so only the
  /// platform closes it, when it disposes the plugin.
  @override
  void close() {}

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      _withRetryAndTimeout(() => _client.read(url, headers: headers));

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      _withRetryAndTimeout(() => _client.readBytes(url, headers: headers));

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      _client.send(request).timeout(_timeout);
}
