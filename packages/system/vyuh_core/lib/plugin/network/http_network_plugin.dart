import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:vyuh_core/vyuh_core.dart';

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
  var _initialized = false;

  late final RetryOptions _retryOptions;
  late final HttpNetworkConfig config;

  HttpNetworkPlugin({HttpNetworkConfig? config})
      : super(name: 'vyuh.plugin.network.http', title: 'HTTP Network Plugin') {
    this.config = config ?? HttpNetworkConfig.standard;
    _retryOptions = RetryOptions(
      maxAttempts: this.config.maxRetryAttempts,
      maxDelay: this.config.maxRetryDelay,
    );
  }

  @override
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _client = Client();
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
        () => fn().timeout(config.timeout),
        retryIf: (e) {
          return e is SocketException || e is TimeoutException;
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
