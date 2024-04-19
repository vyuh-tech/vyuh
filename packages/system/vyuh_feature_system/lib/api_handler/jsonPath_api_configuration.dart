import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'jsonPath_api_configuration.g.dart';

@JsonSerializable()
final class DisplayFieldMap {
  final JSONPath? title;
  final JSONPath? description;
  final JSONPath? imageUrl;

  DisplayFieldMap({this.title, this.description, this.imageUrl});

  factory DisplayFieldMap.fromJson(Map<String, dynamic> json) =>
      _$DisplayFieldMapFromJson(json);
}

extension type const JSONPath(String path) {
  factory JSONPath.fromJson(dynamic value) => JSONPath(value);
}

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
    final response = await vyuh.network.get(Uri.parse(url));
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

  _buildCardList(BuildContext context, List<vf.Card> data) {
    if (data.isEmpty) {
      return vyuh.content.buildContent(
          context,
          vf.Card(
              title: 'No Data',
              description: 'We could not find any data for the url: $url'));
    }

    final theme = Theme.of(context);

    final list = vyuh.content.buildContent(context,
        vf.Group(title: title, items: data, layout: vf.ListGroupLayout()));

    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: LimitedBox(
        maxHeight: 200,
        child: list,
      ),
    );
  }
}
