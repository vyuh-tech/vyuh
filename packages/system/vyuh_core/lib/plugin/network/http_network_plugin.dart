import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'http_network_plugin_stub.dart'
    if (dart.library.html) 'http_network_plugin_web.dart';

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
  /// [webIncludeCredentials] - When true and running on web, uses browser's fetch API
  /// with credentials: 'include' to send HTTP-only cookies with cross-origin requests.
  /// This is essential for session-based authentication with HTTP-only cookies.
  HttpNetworkPlugin({
    Client? client,
    RetryOptions? retryOptions,
    Duration? timeout,
    bool webIncludeCredentials = true,
  })  : _retryOptions = retryOptions ??
            const RetryOptions(
              maxAttempts: 3,
              delayFactor: Duration(milliseconds: 200),
            ),
        _timeout = timeout ?? const Duration(seconds: 30),
        _webIncludeCredentials = webIncludeCredentials,
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

    // Use BrowserClient for web when credentials are needed
    if (kIsWeb && _webIncludeCredentials) {
      _client = createWebClient();
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

  _withRetryAndTimeout(Future<Response> Function() fn) => _retryOptions.retry(
        () => fn().timeout(_timeout),
        retryIf: (e) {
          // Use the string based to check to avoid importing dart:io.
          // This makes it easier to use this plugin in web.
          return (e.toString().contains('SocketException')) ||
              e is TimeoutException;
        },
      );

  @override
  void close() {
    _client.close();
    _initialized = false;
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      _client.read(url, headers: headers);

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      _client.readBytes(url, headers: headers);

  @override
  Future<StreamedResponse> send(BaseRequest request) => _client.send(request);
}
