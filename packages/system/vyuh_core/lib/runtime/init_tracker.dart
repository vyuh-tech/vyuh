import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The possible states of the system initialization.
enum InitState {
  /// The system has not started initializing.
  notStarted,

  /// The system has initialized the plugins.
  plugins,

  /// The system has initialized the features.
  features,

  /// The system is ready for operation.
  ready,
}

/// A tracker for the system initialization process.
abstract interface class SystemInitTracker {
  /// The platform that is being initialized.
  VyuhPlatform get platform;

  /// The current state of the initialization process.
  Observable<InitState> get currentState;

  /// The status of the future that is being awaited.
  FutureStatus? get status;

  /// The error that occurred during initialization.
  dynamic get error;

  /// Initializes the system.
  Future<void> init([InitState initialState]);
}
