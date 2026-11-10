import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A typed event listener that a feature declares in
/// [FeatureDescriptor.events].
///
/// The platform subscribes every handler of a feature when the feature
/// starts, and cancels them when the feature is disposed, when the platform
/// restarts, or when a lazy feature's activation is rolled back. Features
/// never manage these subscriptions themselves.
///
/// ```dart
/// FeatureDescriptor(
///   name: 'auth',
///   title: 'Auth',
///   events: [
///     EventHandler<SystemReadyEvent>((_) => restoreSession()),
///     EventHandler<RouteFailureEvent>((e) => log(e.failure)),
///   ],
///   routes: () => [...],
/// );
/// ```
final class EventHandler<T extends VyuhEvent> {
  /// Called for every event of type [T].
  final VyuhEventListener<T> listener;

  /// Creates a handler for events of type [T].
  const EventHandler(this.listener);

  /// The event type this handler listens to.
  Type get eventType => T;

  /// Subscribes [listener] on [events], keeping the generic type [T].
  /// Used by the platform; features do not call this.
  DisposeFunction subscribe(EventPlugin events) => events.on<T>(listener);
}

/// A redirect that a feature contributes to the app's router.
///
/// Redirects of all features compose into one chain, in feature order
/// (dependencies first, lazy features after they activate). The first
/// redirect that returns a location wins; returning `null` passes to the
/// next one. The global redirect given to `DefaultNavigationPlugin` runs
/// before all feature redirects.
///
/// Redirects re-run when any event in [refreshOn] is emitted, or when
/// [listenable] notifies. Use this to react to sign-in, feature flags or
/// onboarding state without wiring the router yourself.
///
/// ```dart
/// FeatureRedirect(
///   name: 'require-sign-in',
///   refreshOn: [UserChangedEvent],
///   redirect: (context, state) =>
///       !signedIn && state.matchedLocation.startsWith('/account')
///           ? '/login'
///           : null,
/// )
/// ```
final class FeatureRedirect {
  /// A short name used in logs and error reports.
  final String name;

  /// Returns a new location to redirect to, or `null` to continue.
  final GoRouterRedirect redirect;

  /// Event types that make the router re-run its redirects.
  /// Matching is by exact runtime type.
  final List<Type> refreshOn;

  /// An optional listenable (a `ValueNotifier`, a `ChangeNotifier`, or a
  /// MobX store bridged to a listenable) that makes the router re-run its
  /// redirects when it notifies.
  final Listenable? listenable;

  /// Creates a feature redirect.
  const FeatureRedirect({
    required this.name,
    required this.redirect,
    this.refreshOn = const [],
    this.listenable,
  });
}

/// The redirects and refresh triggers currently contributed by features.
///
/// Owned by the platform and read by the [NavigationPlugin] on every
/// navigation, so a lazy feature's redirects apply as soon as it activates.
final class RedirectRegistry {
  final List<(String feature, FeatureRedirect redirect)> _entries = [];
  final List<VoidCallback> _listeners = [];

  /// The redirects in evaluation order.
  List<FeatureRedirect> get redirects =>
      List.unmodifiable(_entries.map((e) => e.$2));

  /// Adds the redirects of [feature] at the end of the chain.
  void add(String feature, List<FeatureRedirect> redirects) {
    if (redirects.isEmpty) return;
    for (final redirect in redirects) {
      _entries.add((feature, redirect));
    }
    _notify();
  }

  /// Removes every redirect contributed by [feature].
  void remove(String feature) {
    final before = _entries.length;
    _entries.removeWhere((entry) => entry.$1 == feature);
    if (_entries.length != before) _notify();
  }

  /// Removes all redirects.
  void clear() {
    if (_entries.isEmpty) return;
    _entries.clear();
    _notify();
  }

  /// Whether any redirect asks to refresh on events of [type].
  bool refreshesOn(Type type) =>
      _entries.any((entry) => entry.$2.refreshOn.contains(type));

  /// All listenables that should refresh the router.
  List<Listenable> get listenables =>
      _entries.map((e) => e.$2.listenable).nonNulls.toList();

  /// Notified whenever the set of redirects changes.
  void addListener(VoidCallback listener) => _listeners.add(listener);

  /// Removes a listener added with [addListener].
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  /// Runs [base] then each feature redirect, returning the first location.
  ///
  /// A redirect that throws is reported to telemetry and skipped, so one
  /// broken feature cannot block navigation for the whole app.
  Future<String?> evaluate(
    BuildContext context,
    GoRouterState state, {
    GoRouterRedirect? base,
  }) async {
    if (base != null) {
      final location = await base(context, state);
      if (location != null) return location;
    }

    for (final (feature, redirect) in List.of(_entries)) {
      if (!context.mounted) return null;
      try {
        final location = await redirect.redirect(context, state);
        if (location != null && location != state.uri.toString()) {
          return location;
        }
      } catch (error, stack) {
        try {
          vyuh.telemetry.reportError(
            StateError(
              'Redirect "${redirect.name}" of feature "$feature" failed: $error',
            ),
            stackTrace: stack,
          );
        } catch (_) {}
      }
    }

    return null;
  }
}
