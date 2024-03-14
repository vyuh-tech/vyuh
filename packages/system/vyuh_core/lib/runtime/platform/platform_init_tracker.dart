import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class PlatformInitTracker implements SystemInitTracker {
  @override
  final VyuhPlatform platform;

  @override
  final Observable<InitState> currentState = Observable(InitState.notStarted);

  final Observable<ObservableFuture<void>?> _loader = Observable(null);

  @override
  FutureStatus? get status => _loader.value?.status;

  @override
  dynamic get error => _loader.value?.error;

  PlatformInitTracker(this.platform);

  @override
  Future<void> init([InitState initialState = InitState.notStarted]) {
    return runInAction(() {
      /// The loader is being created with a Future<void> first just to set the value.
      /// This happens very early in the bootstrapping process.
      /// There could be plugins that can depend on the platform getting
      /// ready before they do their work.
      _loader.value = ObservableFuture(Future.value()).then((_) async {
        final trace = vyuh.analytics.createTrace('Init Platform');

        try {
          await trace.start();
          await _initLoop(initialState);
        } catch (exception, trace) {
          vyuh.analytics.reportError(exception, stackTrace: trace);
          rethrow;
        } finally {
          await trace.stop();
        }
      });

      return _loader.value!;
    });
  }

  Future<void> _initLoop(InitState initialState) async {
    runInAction(() => currentState.value = initialState);

    while (currentState.value != InitState.ready) {
      switch (currentState.value) {
        case InitState.notStarted:
          runInAction(() => currentState.value = InitState.plugins);
          break;

        case InitState.plugins:
          await platform.initPlugins();
          runInAction(() => currentState.value = InitState.features);
          break;

        case InitState.features:
          await platform.initFeatures();
          runInAction(() => currentState.value = InitState.ready);

        case InitState.ready:
          break;
      }
    }
  }
}
