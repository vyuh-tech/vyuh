import 'dart:async';

import 'package:vyuh_core/vyuh_core.dart';

import 'script_runtime.dart' if (dart.library.html) 'web_script_runtime.dart'
    as rt;

final class ScriptExtensionDescriptor extends ExtensionDescriptor {
  final String name;

  String get runtime => 'javascript';

  final FutureOr<dynamic> Function(dynamic args) function;

  ScriptExtensionDescriptor({required this.name, required this.function})
      : super(title: 'ScriptExtension: $name');
}

final class ScriptExtensionBuilder extends ExtensionBuilder {
  ScriptExtensionBuilder()
      : super(
            extensionType: ScriptExtensionDescriptor,
            title: 'Script Extension Builder');

  @override
  void build(List<ExtensionDescriptor> extensions) {
    for (final extension in extensions.cast<ScriptExtensionDescriptor>()) {
      rt.ScriptRuntime.registerFunction(extension.name, extension.function);
    }
  }

  @override
  void init() {
    rt.ScriptRuntime.init();
  }
}