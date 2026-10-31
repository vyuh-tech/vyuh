part of '../run_app.dart';

/// Sets up the root view that loads the entire app. It waits for the platform to init and then loads the main App. During
/// the load, a splash screen is shown, which can be customized.
class _FrameworkInitView extends StatefulWidget {
  const _FrameworkInitView();

  @override
  State<_FrameworkInitView> createState() => _FrameworkInitViewState();
}

class _FrameworkInitViewState extends State<_FrameworkInitView> {
  @override
  void initState() {
    super.initState();
    vyuh.tracker.init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      name: 'Framework Init',
      builder: (context) {
        final status = vyuh.tracker.status;

        Widget? loadedApp;
        if (status == FutureStatus.fulfilled) {
          loadedApp = vyuh.widgetBuilder.appBuilder(context, vyuh);
        }

        // On the web the browser's path (a deep link on reload) is this
        // app's initial route. Only the loaded app's router can match it, so
        // every route name opens the one loading page; the router reads the
        // path again once the app has loaded.
        final theme = vyuh.widgetBuilder.theme;
        final pendingApp = MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          onGenerateInitialRoutes: (initialRoute) => [
            _pendingRoute(RouteSettings(name: initialRoute)),
          ],
          onGenerateRoute: _pendingRoute,
        );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: loadedApp ?? pendingApp,
        );
      },
    );
  }

  Route<void> _pendingRoute(RouteSettings settings) => MaterialPageRoute(
    settings: settings,
    builder: (_) => const _PendingView(),
  );
}

/// The loader while the app loads, and the failure if it does not.
class _PendingView extends StatelessWidget {
  const _PendingView();

  @override
  Widget build(BuildContext context) {
    return Observer(
      name: 'Framework Pending',
      builder: (context) {
        final status = vyuh.tracker.status;
        if (status == null || status == FutureStatus.pending) {
          return vyuh.widgetBuilder.appLoader(context);
        }

        // Telemetry and SystemInitFailedEvent already reported this, so
        // show it without reporting it again.
        final failure = VyuhFailure(
          kind: FailureKind.init,
          title: vyuh.widgetBuilder.strings.appStartFailedTitle,
          message: vyuh.widgetBuilder.strings.appStartFailedMessage,
          error: vyuh.tracker.error,
        );
        return VyuhFailureScope(
          failure: failure,
          child: Builder(
            builder: (context) => vyuh.widgetBuilder.routeErrorView(
              context,
              title: failure.title,
              subtitle: failure.message,
              error: failure.error,
              retryLabel: vyuh.widgetBuilder.strings.restartApp,
              onRetry: () => vyuh.tracker.init(),
            ),
          ),
        );
      },
    );
  }
}
