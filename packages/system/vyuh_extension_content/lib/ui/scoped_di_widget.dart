import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A widget that wraps its child with a scoped instance of [DIPlugin].
///
/// This widget is useful when you want to provide a scoped instance of
/// [DIPlugin] to its descendants. If no scoped instance is provided,
/// the [ScopedDIWidget] will fallback to the platform [DIPlugin].
///
/// The [of] method can be used to get the [DIPlugin] from the nearest
/// [ScopedDIWidget] in the widget tree.
final class ScopedDIWidget extends StatefulWidget {
  const ScopedDIWidget({
    super.key,
    required this.child,
    required this.debugLabel,
  });

  final Widget child;

  /// The debug label for the [DIPlugin]. It is useful to identify the scope.
  final String debugLabel;

  /// Get the DIPlugin from the nearest DI scope. If no scope is found,
  /// it will fallback to the platform [DIPlugin].
  static DIPlugin of(BuildContext context) {
    final scopeDI =
        context.dependOnInheritedWidgetOfExactType<_InheritedDIScope>()?.scope;

    if (scopeDI == null) {
      // Fallback to platform DI
      return VyuhBinding.instance.di;
    }

    return scopeDI;
  }

  @override
  State<ScopedDIWidget> createState() => _ScopedDIWidgetState();
}

class _ScopedDIWidgetState extends State<ScopedDIWidget> {
  late final DIPlugin _scopeDI;

  @override
  void initState() {
    super.initState();
    _initScope();
  }

  void _initScope() {
    // Create a DIPlugin that wraps the GetIt instance
    _scopeDI = GetItDIPlugin(debugLabel: widget.debugLabel);
  }

  @override
  void dispose() {
    // Reset the scope when disposed
    Future.microtask(_scopeDI.reset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedDIScope(
      scope: _scopeDI,
      child: widget.child,
    );
  }
}

class _InheritedDIScope extends InheritedWidget {
  final DIPlugin scope;

  const _InheritedDIScope({
    required this.scope,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedDIScope oldWidget) {
    return scope != oldWidget.scope;
  }
}

extension DIExtension on BuildContext {
  DIPlugin get di => ScopedDIWidget.of(this);
}
