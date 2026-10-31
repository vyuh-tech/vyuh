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
    final isRestart = currentState.value != InitState.notStarted;
    return runInAction(() {
      /// The loader is being created with a Future<void> first just to set the value.
      /// This happens very early in the bootstrapping process.
      /// There could be plugins that can depend on the platform getting
      /// ready before they do their work.
      _loader.value = ObservableFuture(Future.value()).then((_) async {
        Trace? trace;
        try {
          await VyuhBinding.instance._ensurePreloadedPlugins(retry: isRestart);
          trace = await vyuh.telemetry.startTrace('Platform', 'Init');
          _LazyFeatureManager._emit(
            SystemInitStartedEvent(isRestart: isRestart),
          );

          await _initLoop(initialState, trace);

          _LazyFeatureManager._emit(SystemReadyEvent());
        } catch (exception, stack) {
          try {
            await vyuh.telemetry.reportError(exception, stackTrace: stack);
          } catch (_) {
            /* Telemetry itself may be what failed to start. */
          }
          _LazyFeatureManager._emit(
            SystemInitFailedEvent(
              VyuhFailure(
                kind: FailureKind.init,
                title: VyuhStrings.current.appStartFailedTitle,
                message: VyuhStrings.current.appStartFailedMessage,
                error: exception,
                stackTrace: stack,
              ),
            ),
          );

          runInAction(() => currentState.value = InitState.error);

          rethrow;
        } finally {
          await trace?.stop();
        }
      });

      return _loader.value!;
    });
  }

  Future<void> _initLoop(InitState initialState, Trace parentTrace) async {
    runInAction(() => currentState.value = initialState);

    final nextOperation = {
      InitState.notStarted: () async {
        await platform.initPlugins(parentTrace);
        runInAction(() => currentState.value = InitState.plugins);
      },
      InitState.plugins: () async {
        await platform.initFeatures(parentTrace);
        runInAction(() => currentState.value = InitState.features);
      },
      InitState.features: () async {
        runInAction(() => currentState.value = InitState.ready);
      },
    };

    while (currentState.value != InitState.ready) {
      final fn = nextOperation[currentState.value]!;
      await fn();
    }
  }
}
