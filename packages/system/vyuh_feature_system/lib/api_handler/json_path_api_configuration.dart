import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'json_path_api_configuration.g.dart';

/// Maps JSON fields to card display fields using JSON Path expressions.
///
/// Features:
/// * Title field mapping
/// * Description field mapping
/// * Image URL field mapping
///
/// Example:
/// ```dart
/// final fieldMap = DisplayFieldMap(
///   title: JSONPath('$.name'),
///   description: JSONPath('$.details'),
///   imageUrl: JSONPath('$.image.url'),
/// );
/// ```
@JsonSerializable()
final class DisplayFieldMap {
  final JSONPath? title;
  final JSONPath? description;
  final JSONPath? imageUrl;

  DisplayFieldMap({this.title, this.description, this.imageUrl});

  factory DisplayFieldMap.fromJson(Map<String, dynamic> json) =>
      _$DisplayFieldMapFromJson(json);
}

/// A strongly-typed wrapper around JSON Path expressions.
///
/// JSON Path allows querying JSON data using path expressions similar to XPath.
/// For example:
/// * `$.store.book[0].title` - First book's title
/// * `$.store.book[*].author` - All authors of all books
/// * `$.store.book[?(@.price < 10)]` - All books less than 10
extension type const JSONPath(String path) {
  factory JSONPath.fromJson(dynamic value) => JSONPath(value);
}

/// Configuration for fetching and transforming API data using JSON Path.
///
/// Features:
/// * HTTP request configuration (URL, headers, body)
/// * JSON data extraction using JSON Path
/// * Field mapping to card properties
/// * List and single item handling
/// * Error handling and fallbacks
///
/// Example:
/// ```dart
/// final config = JsonPathApiConfiguration(
///   url: 'https://api.example.com/items',
///   headers: {'Authorization': 'Bearer token'},
///   rootField: JSONPath('$.data.items'),
///   fieldMap: DisplayFieldMap(
///     title: JSONPath('$.name'),
///     description: JSONPath('$.details'),
///     imageUrl: JSONPath('$.image.url'),
///   ),
/// );
/// ```
///
/// The configuration will:
/// * Fetch data from the specified URL
/// * Extract items using the root field path
/// * Map JSON fields to card properties
/// * Handle both array and single object responses
/// * Create a list of cards with consistent layout
@JsonSerializable()
final class JsonPathApiConfiguration extends ApiConfiguration<List<vf.Card>> {
  static const schemaName = 'vyuh.apiContent.configuration.jsonPath';

  final String url;
  final Map<String, String>? headers;
  final List<(String name, String value)>? requestBody;

  final JSONPath rootField;
  final DisplayFieldMap? fieldMap;

  static final typeDescriptor = TypeDescriptor(
    schemaType: JsonPathApiConfiguration.schemaName,
    fromJson: JsonPathApiConfiguration.fromJson,
    title: 'JSONPath API Configuration',
  );

  JsonPathApiConfiguration({
    super.title,
    this.url = '',
    this.headers,
    this.requestBody,
    this.rootField = const JSONPath(r'$'),
    this.fieldMap,
  }) : super(schemaType: schemaName);

  factory JsonPathApiConfiguration.fromJson(Map<String, dynamic> json) =>
      _$JsonPathApiConfigurationFromJson(json);

  @override
  Future<List<vf.Card>?> invoke(BuildContext context) async {
    final response = await VyuhBinding.instance.network.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    final rootItem = JsonPath(rootField.path).read(json);
    if (rootItem.singleOrNull == null) return null;

    final root = rootItem.single.value;

    return switch (root) {
      List() => root.map((e) => _createCard(e)).toList(),
      Map() => [_createCard(root as Map<String, dynamic>)],
      _ => null
    };
  }

  @override
  Widget build(BuildContext context, List<vf.Card>? data) {
    return data == null ? empty : _buildCardList(context, data);
  }

  vf.Card _createCard(Map<String, dynamic> json) {
    final fields = {
      'title': fieldMap?.title,
      'description': fieldMap?.description,
      'imageUrl': fieldMap?.imageUrl,
    }.entries.where((x) => x.value != null).map((e) {
      final value =
          JsonPath(e.value!.path).read(json).singleOrNull?.value as String?;
      return MapEntry(e.key, value);
    }).fold(<String, String?>{}, (previousValue, element) {
      previousValue[element.key] = element.value;
      return previousValue;
    });

    return vf.Card(
      title: fields['title'],
      description: fields['description'],
      imageUrl:
          fields['imageUrl'] != null ? Uri.parse(fields['imageUrl']!) : null,
      layout: ListItemCardLayout(title: 'List Item'),
    );
  }

  Widget _buildCardList(BuildContext context, List<vf.Card> data) {
    if (data.isEmpty) {
      return VyuhBinding.instance.content.buildContent(
          context,
          vf.Card(
              title: 'No Data',
              description: 'We could not find any data for the url: $url'));
    }

    final list = VyuhBinding.instance.content.buildContent(
        context,
        vf.Group(
            title: title,
            items: data,
            layout: vf.ListGroupLayout(percentHeight: 0.5)));

    return list;
  }
}
