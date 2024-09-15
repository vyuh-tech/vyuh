import 'dart:convert';

import 'package:http/http.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class NetworkPlugin extends Plugin
    with PreLoadedPlugin
    implements Client {
  NetworkPlugin({required super.name, required super.title})
      : super();

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers});

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers});

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
}
