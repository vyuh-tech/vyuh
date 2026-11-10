import 'package:vyuh_core/plugin/event_plugin.dart';
import 'package:vyuh_core/runtime/failure.dart';

/// The base type for every event the platform emits about its own lifecycle.
///
/// Listen to [SystemEvent] to observe all of them, or to a specific subtype.
/// Features declare their listeners with `FeatureDescriptor.events`.
///
/// | Event | When |
/// |---|---|
/// | [SystemInitStartedEvent] | Platform init (or a restart) begins |
/// | [FeatureLoadedEvent] | An eager feature finished init, or a lazy feature activated |
/// | [FeatureLoadFailedEvent] | A lazy feature failed to load or is disabled |
/// | [SystemReadyEvent] | Plugins, features and routes are ready |
/// | [SystemInitFailedEvent] | Platform init failed |
/// | [RouteFailureEvent] | A route could not be shown |
abstract class SystemEvent<T> extends VyuhEvent<T> {
  SystemEvent({required super.name, super.data});
}

/// Emitted when platform initialization starts, including on restart.
final class SystemInitStartedEvent extends SystemEvent<void> {
  /// Whether this init is a restart of an already-initialized platform.
  final bool isRestart;

  SystemInitStartedEvent({required this.isRestart})
    : super(name: 'vyuh.event.systemInitStarted');
}

/// An event indicating that the system is ready.
///
/// This event is emitted when the system initialization process is complete
/// and the platform is ready for operation. It can be used by listeners to
/// perform actions that require the system to be fully initialized.
final class SystemReadyEvent extends SystemEvent<void> {
  /// Creates a new [SystemReadyEvent].
  SystemReadyEvent() : super(name: 'vyuh.event.systemReady');
}

/// Emitted when platform initialization fails.
final class SystemInitFailedEvent extends SystemEvent<VyuhFailure> {
  /// The failure that stopped initialization.
  final VyuhFailure failure;

  SystemInitFailedEvent(this.failure)
    : super(name: 'vyuh.event.systemInitFailed', data: failure);
}

/// Emitted after a feature is ready: an eager feature finished its `init`,
/// or a lazy feature finished loading and activating.
final class FeatureLoadedEvent extends SystemEvent<String> {
  /// The name of the feature.
  final String featureName;

  /// Whether the feature was loaded lazily.
  final bool isLazy;

  FeatureLoadedEvent({required this.featureName, required this.isLazy})
    : super(name: 'vyuh.event.featureLoaded', data: featureName);
}

/// Emitted when a lazy feature fails to load, or is disabled by its flag.
final class FeatureLoadFailedEvent extends SystemEvent<VyuhFailure> {
  /// The name of the feature.
  final String featureName;

  /// The failure. Its kind is [FailureKind.featureDisabled] for a disabled
  /// feature and [FailureKind.featureLoad] otherwise.
  final VyuhFailure failure;

  FeatureLoadFailedEvent({required this.featureName, required this.failure})
    : super(name: 'vyuh.event.featureLoadFailed', data: failure);
}

/// Emitted once each time a route cannot be shown: no match, a page that
/// failed to load or a failed lazy feature.
final class RouteFailureEvent extends SystemEvent<VyuhFailure> {
  /// The failure, including the location that failed.
  final VyuhFailure failure;

  RouteFailureEvent(this.failure)
    : super(name: 'vyuh.event.routeFailure', data: failure);
}
