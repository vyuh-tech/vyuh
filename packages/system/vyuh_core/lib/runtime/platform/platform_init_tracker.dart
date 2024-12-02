part of '../run_app.dart';

final class _PlatformInitTracker implements SystemInitTracker {
  @override
  final VyuhPlatform platform;

  @override
  final Observable<InitState> currentState = Observable(InitState.notStarted);

  final Observable<ObservableFuture<void>?> _loader = Observable(null);

  @override
  FutureStatus? get status => _loader.value?.status;

  @override
  dynamic get error => _loader.value?.error;

  _PlatformInitTracker(this.platform);

  @override
  Future<void> init([InitState initialState = InitState.notStarted]) {
    return runInAction(() {
      /// The loader is being created with a Future<void> first just to set the value.
      /// This happens very early in the bootstrapping process.
      /// There could be plugins that can depend on the platform getting
      /// ready before they do their work.
      _loader.value = ObservableFuture(Future.value()).then((_) async {
        final trace = await vyuh.analytics.startTrace('Platform', 'Init');

        try {
          await _initLoop(initialState, trace);

          vyuh.event.emit(SystemReadyEvent());
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

  Future<void> _initLoop(
      InitState initialState, AnalyticsTrace parentTrace) async {
    runInAction(() => currentState.value = initialState);

    while (currentState.value != InitState.ready) {
      switch (currentState.value) {
        case InitState.notStarted:
          runInAction(() => currentState.value = InitState.plugins);
          break;

        case InitState.plugins:
          await platform.initPlugins(parentTrace);
          runInAction(() => currentState.value = InitState.features);
          break;

        case InitState.features:
          await platform.initFeatures(parentTrace);
          runInAction(() => currentState.value = InitState.ready);

        case InitState.ready:
          break;
      }
    }
  }
}
