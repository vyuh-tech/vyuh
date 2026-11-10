import 'package:flutter/widgets.dart';

/// A bounded alternative to an IndexedStack for stateful shell navigators.
///
/// Supply this from StatefulShellRoute.navigatorContainerBuilder. The app owns
/// branch identity and the retention limit; this widget owns only mount lifetime.
/// The active branch and most recently used branches stay mounted. Eviction
/// disposes widget state, focus and subscriptions; go_router retains its route
/// match history and can reconstruct the navigator on the next visit.
class NavigationBranchContainer extends StatefulWidget {
  const NavigationBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
    required this.maxRetainedBranches,
  }) : assert(maxRetainedBranches > 0),
       assert(currentIndex >= 0 && currentIndex < children.length);

  final int currentIndex;
  final List<Widget> children;
  final int maxRetainedBranches;

  @override
  State<NavigationBranchContainer> createState() =>
      _NavigationBranchContainerState();
}

class _NavigationBranchContainerState extends State<NavigationBranchContainer> {
  final _recent = <Object>[];

  Object _identity(int index) => widget.children[index].key ?? index;

  void _retainCurrent() {
    final available = {
      for (var i = 0; i < widget.children.length; i++) _identity(i),
    };
    _recent.removeWhere((identity) => !available.contains(identity));
    final current = _identity(widget.currentIndex);
    _recent.remove(current);
    _recent.add(current);
    while (_recent.length > widget.maxRetainedBranches) {
      _recent.removeAt(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _retainCurrent();
  }

  @override
  void didUpdateWidget(NavigationBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _retainCurrent();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      for (var index = 0; index < widget.children.length; index++)
        if (_recent.contains(_identity(index)))
          Offstage(
            key: ValueKey(_identity(index)),
            offstage: index != widget.currentIndex,
            child: TickerMode(
              enabled: index == widget.currentIndex,
              child: widget.children[index],
            ),
          ),
    ],
  );
}
