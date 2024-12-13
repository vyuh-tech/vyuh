import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class Plugin {
  final String name;
  final String title;

  Plugin({required this.name, required this.title});

  Future<void> init();

  Future<void> dispose();
}

/// A mixin to mark any plugin to be loaded before the Platform.
///
/// This mixin should be applied to plugins that need to be initialized
/// before the main platform initialization. It ensures that the
/// plugin is loaded at the correct time in the initialization sequence.
mixin PreloadedPlugin on Plugin {}

/// A mixin to mark any plugin to be loaded only once after the Platform has been initialized.
/// This mixin can be used together with [PreloadedPlugin] to ensure that the plugin is loaded at the
/// correct time in the initialization sequence.
mixin InitOncePlugin on Plugin {
  Completer? _initCompleter;
  bool _initialized = false;

  bool get initialized => _initialized;

  @override
  @nonVirtual
  Future<void> init() async {
    if (_initCompleter == null) {
      _initCompleter = Completer();

      initOnce().then((final _) {
        _initCompleter!.complete();
        _initialized = true;
      }).catchError((final e) {
        _initCompleter!.completeError(e);
      });
    }

    return _initCompleter!.future;
  }

  @override
  Future<void> dispose() {
    // Since we have opted into the InitOnce mixin, we should not dispose
    // multiple times
    if (_initialized) {
      return Future.value();
    }

    return disposeOnce();
  }

  Future<void> initOnce();

  Future<void> disposeOnce();
}
