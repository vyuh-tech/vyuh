import 'package:vyuh_core/vyuh_core.dart';

/// A capability shared by features in an App.
class {{class_name}} extends Plugin with InitOncePlugin {
  {{class_name}}() : super(name: '{{name.snakeCase()}}', title: {{{title_literal}}});

  @override
  Future<void> initOnce() async {
    // Initialize resources used by this capability.
  }

  @override
  Future<void> disposeOnce() async {
    // Close streams, clients, and other resources owned by this plugin.
  }
}
