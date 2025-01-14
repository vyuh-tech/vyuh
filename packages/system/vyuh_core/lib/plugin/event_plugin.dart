import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Base class for implementing event handling in Vyuh applications.
/// 
/// The event plugin provides a pub/sub system for decoupled communication
/// between different parts of the application. It supports:
/// - Event subscription with [on] and [once]
/// - Event emission with [emit]
/// - Automatic cleanup of event subscriptions
/// 
/// Example:
/// ```dart
/// // Subscribe to events
/// final dispose = vyuh.event.on<UserLoggedInEvent>((event) {
///   print('User ${event.data.userId} logged in');
/// });
/// 
/// // Emit events
/// vyuh.event.emit(UserLoggedInEvent(
///   data: UserData(userId: '123'),
/// ));
/// 
/// // Clean up subscription
/// dispose();
/// ```
abstract class EventPlugin extends Plugin with PreloadedPlugin {
  EventPlugin({required super.name, required super.title});

  /// Subscribe to events of type [T].
  /// 
  /// Returns a dispose function that can be called to cancel the subscription.
  /// The [listener] will be called whenever an event of type [T] is emitted.
  /// 
  /// Example:
  /// ```dart
  /// final dispose = vyuh.event.on<UserEvent>((event) {
  ///   print('User event: ${event.name}');
  /// });
  /// ```
  DisposeFunction on<T extends VyuhEvent>(VyuhEventListener<T> listener);

  /// Subscribe to a single occurrence of an event of type [T].
  /// 
  /// The [listener] will be called only once when an event of type [T]
  /// is emitted, then the subscription will be automatically cancelled.
  /// 
  /// Example:
  /// ```dart
  /// vyuh.event.once<AppStartEvent>((event) {
  ///   print('App started at ${event.timestamp}');
  /// });
  /// ```
  void once<T extends VyuhEvent>(VyuhEventListener<T> listener);

  /// Emit an event to all subscribers.
  /// 
  /// The event will be delivered to all listeners subscribed to events
  /// of type [T].
  /// 
  /// Example:
  /// ```dart
  /// vyuh.event.emit(UserLoggedInEvent(
  ///   data: UserData(userId: '123'),
  /// ));
  /// ```
  void emit<T extends VyuhEvent>(T event);
}

/// Base class for all events in a Vyuh application.
/// 
/// Events represent discrete occurrences in the application that other
/// components might be interested in. They can carry optional data
/// and are automatically timestamped.
/// 
/// Example:
/// ```dart
/// class UserLoggedInEvent extends VyuhEvent<UserData> {
///   UserLoggedInEvent({required UserData data})
///     : super(name: 'user.logged_in', data: data);
/// }
/// ```
class VyuhEvent<T> {
  /// The name of the event, used for identification and logging.
  final String name;

  /// When the event was created.
  final DateTime timestamp;

  /// Optional data associated with the event.
  final T? data;

  VyuhEvent({
    required this.name,
    this.data,
  }) : timestamp = DateTime.now();
}

/// A function that can be called to dispose of (cancel) an event subscription.
typedef DisposeFunction = void Function();

/// A function that handles events of type [T].
typedef VyuhEventListener<T extends VyuhEvent> = void Function(T event);

/// Default implementation of [EventPlugin] using the event_bus package.
/// 
/// This implementation provides a simple and efficient event bus that:
/// - Supports multiple subscribers
/// - Handles event type safety
/// - Provides automatic cleanup
/// 
/// Example:
/// ```dart
/// final plugins = PluginDescriptor(
///   event: DefaultEventPlugin(),
/// );
/// ```
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
