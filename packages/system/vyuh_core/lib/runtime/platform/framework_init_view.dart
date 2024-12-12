part of '../run_app.dart';

// Sets up the root view that loads the entire app. It waits for the platform to init and then loads the main App. During
// the load, a splash screen is shown, which can be customized.
//
// Note
// =====
// We could have done this with a dynamic routing-config for GoRouter where this view is loaded as part of the '/' route.
// When the app gets loaded we switch the routing-config to the routes from the app. However, this has the issue
// of not being able to control the transition from the splash screen to the app.
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
          loadedApp = vyuh.widgetBuilder.appBuilder(vyuh);
        }

        if (vyuh.tracker.error != null) {
          vyuh.telemetry.reportError(vyuh.tracker.error);
        }

        final child = status == null || status == FutureStatus.pending
            ? vyuh.widgetBuilder.appLoader(context)
            : vyuh.widgetBuilder.routeErrorView(
                context,
                title: 'Failed to load app',
                error: vyuh.tracker.error,
              );
        final pendingApp = MaterialApp(home: child);

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
}
