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
        final pendingApp = MaterialApp(
          debugShowCheckedModeBanner: false,
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
        return status == null || status == FutureStatus.pending
            ? vyuh.widgetBuilder.appLoader(context)
            : vyuh.widgetBuilder.routeErrorView(
                context,
                title: 'Failed to load app',
                error: vyuh.tracker.error,
              );
      },
    );
  }
}
