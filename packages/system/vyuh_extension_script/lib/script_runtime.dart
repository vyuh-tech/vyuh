import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';

final class ScriptRuntime {
  static JavascriptRuntime? _runtime;

  static BuildContext? get currentBuildContext =>
      _runtime?.localContext['buildContext'];

  static void init() {
    _runtime ??= getJavascriptRuntime();
  }

  static void registerFunction(String name, Function(dynamic args) function) {
    _runtime?.onMessage(name, function);
  }

  static Future<void> evaluate(String script, BuildContext context,
      {bool isAsync = false}) async {
    if (_runtime == null) {
      return;
    }

    try {
      _runtime!.localContext['buildContext'] = context;
      if (isAsync) {
        final result = await _runtime!.evaluateAsync(script);
        _runtime!.executePendingJob();
        await _runtime!.handlePromise(result);
      } else {
        _runtime!.evaluate(script);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _runtime!.localContext['buildContext'] = null;
    }
  }
}
