import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Sets up the root view that loads the entire app. It waits for the platform to init and then loads the main App. During
/// the load, a splash screen is shown, which can be customized.
class FrameworkInitWidget extends StatefulWidget {
  final VyuhPlatform platform;

  const FrameworkInitWidget({super.key, required this.platform});

  @override
  State<FrameworkInitWidget> createState() => _FrameworkInitWidgetState();
}

class _FrameworkInitWidgetState extends State<FrameworkInitWidget> {
  @override
  void initState() {
    super.initState();
    widget.platform.tracker.init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      name: 'Framework Init',
      builder: (context) {
        final status = widget.platform.tracker.status;

        Widget? loadedApp;
        if (status == FutureStatus.fulfilled) {
          loadedApp = widget.platform.widgetBuilder.appBuilder(vyuh);
        }

        final child = status == null || status == FutureStatus.pending
            ? widget.platform.widgetBuilder.appLoader(context)
            : widget.platform.widgetBuilder.routeErrorView(
                context,
                title: 'Failed to load app',
                error: widget.platform.tracker.error,
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
