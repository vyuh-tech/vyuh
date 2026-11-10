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

        // The loading surface must not create a Navigator. A temporary
        // Navigator selects single-entry browser history while the loaded
        // Router selects multi-entry history. Their overlap during the fade
        // can strand navigation messages waiting for a browser traversal.
        // The loaded app alone owns the initial deep link and browser history.
        final theme = vyuh.widgetBuilder.theme;
        final pendingApp = MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          builder: (_, _) => const _PendingView(),
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
}

/// The loader while the app loads, and the failure if it does not.
class _PendingView extends StatelessWidget {
  const _PendingView();

  @override
  Widget build(BuildContext context) {
    return Observer(
      name: 'Framework Pending',
      builder: (context) {
        // Only a failed boot is a failure. When boot succeeds this screen
        // may still be fading out while the app fades in, so it keeps
        // showing the loader rather than reading success as a failure.
        if (vyuh.tracker.status != FutureStatus.rejected) {
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
