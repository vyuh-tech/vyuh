import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'restart.g.dart';

@JsonSerializable()
final class RestartApplication extends ActionConfiguration {
  static const schemaName = 'tmdb.action.restart';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: RestartApplication.fromJson,
    title: 'Restart Application',
  );

  RestartApplication() : super(schemaType: schemaName);

  factory RestartApplication.fromJson(Map<String, dynamic> json) =>
      _$RestartApplicationFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context) {
    vyuh.tracker.init();
  }
}
