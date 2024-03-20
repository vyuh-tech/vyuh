import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'script_runtime.dart'
    if (dart.library.html) 'web_script_runtime.dart' as rt;

part 'js_script.g.dart';

@JsonSerializable()
final class JavaScriptAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.javascript';

  static final typeDescriptor = TypeDescriptor(
    schemaType: JavaScriptAction.schemaName,
    title: 'JavaScript Action',
    fromJson: JavaScriptAction.fromJson,
  );

  @JsonKey(defaultValue: '')
  final String script;

  JavaScriptAction({required this.script, super.isAsync})
      : super(schemaType: schemaName);

  factory JavaScriptAction.fromJson(Map<String, dynamic> json) =>
      _$JavaScriptActionFromJson(json);

  @override
  void execute(BuildContext context) {
    rt.ScriptRuntime.evaluate(script, context);
  }
}
