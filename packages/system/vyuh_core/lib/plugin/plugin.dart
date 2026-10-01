import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

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

mixin RouteObservers on Plugin {
  List<NavigatorObserver> get observers;
}

/// Initializes a plugin once per active lifecycle, sharing concurrent calls.
///
/// Disposal waits for initialization, releases resources once, and allows a new
/// lifecycle. Failed initialization can be retried. This can be combined with
/// [PreloadedPlugin] to select the initialization stage.
mixin InitOncePlugin on Plugin {
  Future<void>? _initFuture;
  Future<void>? _disposeFuture;
  bool _initialized = false;

  bool get initialized => _initialized;

  @override
  @nonVirtual
  Future<void> init() {
    final disposal = _disposeFuture;
    if (disposal != null) return disposal.then((_) => init());
    if (_initialized) return Future.value();
    return _initFuture ??= Future.sync(initOnce).then(
      (_) {
        _initialized = true;
      },
      onError: (Object error, StackTrace stack) {
        _initFuture = null;
        Error.throwWithStackTrace(error, stack);
      },
    );
  }

  @override
  @nonVirtual
  Future<void> dispose() {
    return _disposeFuture ??= _dispose().whenComplete(() {
      _disposeFuture = null;
    });
  }

  Future<void> _dispose() async {
    final initialization = _initFuture;
    if (initialization == null) return;
    if (!_initialized) {
      try {
        await initialization;
      } catch (_) {
        return;
      }
    }
    if (!_initialized) return;
    await disposeOnce();
    _initialized = false;
    _initFuture = null;
  }

  Future<void> initOnce();
  Future<void> disposeOnce();
}
