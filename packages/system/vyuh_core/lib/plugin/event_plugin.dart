import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class EventPlugin extends Plugin with PreloadedPlugin {
  EventPlugin({required super.name, required super.title});

  DisposeFunction on<T extends VyuhEvent>(VyuhEventListener<T> listener);
  void once<T extends VyuhEvent>(VyuhEventListener<T> listener);

  void emit<T extends VyuhEvent>(T event);
}

class VyuhEvent<T> {
  final String name;
  final DateTime timestamp;
  final T? data;

  VyuhEvent({
    required this.name,
    this.data,
  }) : timestamp = DateTime.now();
}

typedef DisposeFunction = void Function();
typedef VyuhEventListener<T extends VyuhEvent> = void Function(T event);

final class DefaultEventPlugin extends EventPlugin {
  EventBus? _eventBus;

  DefaultEventPlugin()
      : super(name: 'vyuh.plugin.event.default', title: 'Default Event Plugin');

  @override
  void emit<T extends VyuhEvent>(T event) {
    _eventBus!.fire(event);
  }

  @override
  DisposeFunction on<T extends VyuhEvent>(VyuhEventListener<T> listener) {
    final subscription = _eventBus!.on<T>().listen((event) {
      listener(event);
    });

    return () {
      subscription.cancel();
    };
  }

  @override
  void once<T extends VyuhEvent>(VyuhEventListener<T> listener) {
    late final StreamSubscription<T> subscription;
    subscription = _eventBus!.on<T>().listen((event) {
      listener(event);

      subscription.cancel();
    });
  }

  @override
  Future<void> dispose() async {
    _eventBus?.destroy();
  }

  @override
  Future<void> init() async {
    _eventBus = EventBus();
  }
}
