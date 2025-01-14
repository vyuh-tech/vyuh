import 'dart:convert';

import 'package:http/http.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Base class for implementing network communication in Vyuh applications.
///
/// The network plugin provides HTTP client functionality with additional
/// features like:
/// - Automatic retry on failure
/// - Request/response interceptors
/// - Default headers and configurations
/// - Error handling and logging
///
/// This plugin implements the standard Dart [Client] interface, making it
/// compatible with existing HTTP client code.
abstract class NetworkPlugin extends Plugin
    with PreloadedPlugin
    implements Client {
  NetworkPlugin({required super.name, required super.title}) : super();

  /// Sends an HTTP GET request to the given URL.
  ///
  /// The [headers] parameter can be used to include additional HTTP headers
  /// with the request.
  @override
  Future<Response> get(Uri url, {Map<String, String>? headers});

  /// Sends an HTTP HEAD request to the given URL.
  ///
  /// The [headers] parameter can be used to include additional HTTP headers
  /// with the request.
  @override
  Future<Response> head(Uri url, {Map<String, String>? headers});

  /// Sends an HTTP POST request to the given URL.
  ///
  /// - [headers]: Additional HTTP headers for the request
  /// - [body]: The request body (can be String, `List<int>`, or Map)
  /// - [encoding]: The encoding to use for the request body
  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  /// Sends an HTTP PUT request to the given URL.
  ///
  /// - [headers]: Additional HTTP headers for the request
  /// - [body]: The request body (can be String, `List<int>`, or Map)
  /// - [encoding]: The encoding to use for the request body
  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  /// Sends an HTTP DELETE request to the given URL.
  ///
  /// - [headers]: Additional HTTP headers for the request
  /// - [body]: Optional request body
  /// - [encoding]: The encoding to use for the request body
  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  /// Sends an HTTP PATCH request to the given URL.
  ///
  /// - [headers]: Additional HTTP headers for the request
  /// - [body]: The request body with changes to apply
  /// - [encoding]: The encoding to use for the request body
  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
}
