import 'dart:convert';

import 'package:feature_misc/content/api/model.dart';
import 'package:feature_misc/content/api/widgets.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'dummy_json_api_content.g.dart';

@JsonSerializable()
final class DummyJsonApiConfiguration extends ApiConfiguration<ProductList> {
  static const schemaName = 'misc.apiContent.dummyJson';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DummyJsonApiConfiguration.fromJson,
    title: 'DummyJSON API',
  );

  final DummyJsonProductApiType type;
  final String? searchText;
  final int limit;
  final int skip;

  DummyJsonApiConfiguration({
    required this.type,
    this.searchText,
    required this.limit,
    required this.skip,
  }) : super(schemaType: schemaName, title: 'DummyJSON API');

  factory DummyJsonApiConfiguration.fromJson(Map<String, dynamic> json) =>
      _$DummyJsonApiConfigurationFromJson(json);

  @override
  Widget build(BuildContext context, ProductList? data) {
    if (data == null) {
      return empty;
    }

    return ListContainer(
      title: Text(
        '${type.name} | Showing ${data.products.length} of ${data.total}',
        textAlign: TextAlign.center,
      ),
      child: LimitedBox(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          itemBuilder: (_, index) {
            final item = data.products[index];
            return ProductTile(item: item);
          },
          itemCount: data.products.length,
        ),
      ),
    );
  }

  @override
  Future<ProductList> invoke(BuildContext context) async {
    final parameters = {
      if (type == DummyJsonProductApiType.search) 'q': searchText,
      'limit': limit,
      'skip': skip,
    }.entries.map((x) => '${x.key}=${x.value}').join('&');

    final basePath = switch (type) {
      DummyJsonProductApiType.products => 'https://dummyjson.com/products',
      DummyJsonProductApiType.search => 'https://dummyjson.com/products/search',
    };

    final response = await vyuh.network.get(Uri.parse('$basePath?$parameters'));
    final list = ProductList.fromJson(jsonDecode(response.body));

    return list;
  }
}
