import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'invoke_action.g.dart';

@JsonSerializable()
final class InvokeActionMarkDef extends MarkDef {
  final Action action;

  InvokeActionMarkDef(
      {required this.action, required super.key, required super.type});

  factory InvokeActionMarkDef.fromJson(Map<String, dynamic> json) =>
      _$InvokeActionMarkDefFromJson(json);
}
