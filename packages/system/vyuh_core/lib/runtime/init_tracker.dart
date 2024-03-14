import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

enum InitState { notStarted, plugins, features, ready }

abstract interface class SystemInitTracker {
  VyuhPlatform get platform;
  Observable<InitState> get currentState;

  FutureStatus? get status;
  dynamic get error;

  Future<void> init([InitState initialState]);
}
