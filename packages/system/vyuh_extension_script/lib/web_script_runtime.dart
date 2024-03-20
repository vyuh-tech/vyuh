import 'package:flutter/widgets.dart';

final class ScriptRuntime {
  static void registerFunction(String name, Function(dynamic args) function) {}

  static Future<void> evaluate(String script, BuildContext context,
      {bool isAsync = false}) async {}

  static void init() {}
}
