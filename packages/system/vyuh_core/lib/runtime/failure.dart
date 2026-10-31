import 'package:vyuh_core/vyuh_core.dart';

/// What went wrong, used to pick the message and the recovery actions.
enum FailureKind {
  /// Platform initialization failed. Only a restart can recover.
  init,

  /// No route matched the location.
  notFound,

  /// A route matched but its content could not be loaded.
  route,

  /// A lazy feature failed to download or activate.
  featureLoad,

  /// A lazy feature is turned off by its feature flag.
  featureDisabled,

  /// A piece of content inside a page failed.
  content,

  /// Anything else.
  unexpected,
}

/// A failure the framework shows to the user and reports to telemetry.
///
/// The same object flows through [RouteFailureEvent], [SystemInitFailedEvent],
/// [FeatureLoadFailedEvent] and the error views of [PlatformWidgetBuilder],
/// so listeners and views see one consistent description.
final class VyuhFailure {
  /// The category of the failure.
  final FailureKind kind;

  /// A short, user-facing title.
  final String title;

  /// An optional user-facing explanation.
  final String? message;

  /// The underlying error, shown only in debug builds.
  final Object? error;

  /// The stack trace of [error], shown only in debug builds.
  final StackTrace? stackTrace;

  /// The location that failed, when the failure belongs to a route.
  final Uri? location;

  /// The feature involved, when known.
  final String? featureName;

  const VyuhFailure({
    required this.kind,
    required this.title,
    this.message,
    this.error,
    this.stackTrace,
    this.location,
    this.featureName,
  });

  /// Whether going to the home route can recover from this failure.
  /// Init failures happen before the router exists, so only restart helps.
  bool get canGoHome => kind != FailureKind.init;

  @override
  String toString() =>
      'VyuhFailure(${kind.name}: $title'
      '${location != null ? ' @ $location' : ''}'
      '${error != null ? ', $error' : ''})';
}

/// Reports a failure in one consistent way: to telemetry and, for route-level
/// failures, as a [RouteFailureEvent].
///
/// Call this once per failure, where it is detected, not from `build`.
void reportFailure(VyuhFailure failure, {bool emitRouteEvent = true}) {
  try {
    vyuh.telemetry.reportError(
      failure.error ?? failure.title,
      stackTrace: failure.stackTrace,
    );
  } catch (_) {
    // Telemetry may not be ready, for example during an init failure.
  }

  if (!emitRouteEvent) return;

  try {
    vyuh.event.emit(RouteFailureEvent(failure));
  } catch (_) {
    // The event plugin may not be ready.
  }
}
