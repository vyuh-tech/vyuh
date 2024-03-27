import 'dart:convert';

import 'package:http/http.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract base class NetworkPlugin extends Plugin {
  NetworkPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.network);

  Future<Response> get(Uri url, {Map<String, String>? headers});

  Future<Response> head(Uri url, {Map<String, String>? headers});

  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
}
