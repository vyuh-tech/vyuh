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
          loadedApp = vyuh.widgetBuilder.appBuilder(vyuh);
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
