import 'dart:convert';

import 'package:http/http.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class HttpNetworkPlugin extends NetworkPlugin {
  late Client _client;
  var _initialized = false;

  HttpNetworkPlugin()
      : super(name: 'vyuh.plugin.network.http', title: 'HTTP Network Plugin');

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
      _client.get(url, headers: headers);

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _client.head(url, headers: headers);

  @override
  Future<Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.post(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.put(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.delete(url, headers: headers, body: body, encoding: encoding);

  @override
  Future<Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _client.patch(url, headers: headers, body: body, encoding: encoding);
}
