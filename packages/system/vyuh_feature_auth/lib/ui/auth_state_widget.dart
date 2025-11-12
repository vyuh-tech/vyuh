import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

typedef ScopedWidgetBuilder = Widget Function(
    BuildContext context, AuthFlowScope scope);

final class AuthFlow extends StatefulWidget {
  final ScopedWidgetBuilder builder;
  const AuthFlow({
    super.key,
    required this.builder,
  });

  @override
  State<AuthFlow> createState() => AuthFlowState();
}

enum AuthState {
  signedOut,
  signedIn,
  passwordResetEmailSent,
  inProgress,
  error,
  cancelled,
  partial,
}

final class AuthFlowScope {
  final AuthState authState;
  final dynamic error;
  final Function(Future<void> Function() action, {AuthState endState})
      runAuthAction;

  AuthFlowScope({
    required this.authState,
    required this.error,
    required this.runAuthAction,
  });
}

class AuthFlowState extends State<AuthFlow> {
  final authState = Observable(AuthState.signedOut);
  dynamic error;

  static final List<CancelableOperation<void>> _operations = [];
  static final List<AuthFlowState> _flows = [];

  @override
  void initState() {
    super.initState();

    _flows.add(this);
  }

  @override
  void dispose() {
    _flows.remove(this);

    if (_flows.isEmpty) {
      _cancelOtherOperations();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return widget.builder(
        context,
        AuthFlowScope(
          authState: authState.value,
          error: error,
          runAuthAction: runAuthAction,
        ),
      );
    });
  }

  void runAuthAction(Future<void> Function() action,
      {AuthState endState = AuthState.signedIn}) async {
    runInAction(() => authState.value = AuthState.inProgress);
    try {
      _cancelOtherOperations();
      _resetOtherFlows();
      final operation =
          CancelableOperation<void>.fromFuture(action(), onCancel: () {
        runInAction(() => authState.value = AuthState.cancelled);
      });
      _operations.add(operation);

      await operation.valueOrCancellation();

      if (operation.isCompleted) {
        runInAction(() => authState.value = endState);
      }
    } catch (e) {
      error = e;
      runInAction(() => authState.value = AuthState.error);
    }
  }

  void _cancelOtherOperations() {
    for (final operation in _operations) {
      operation.cancel();
    }

    _operations.clear();
  }

  void _resetOtherFlows() {
    for (final flow in _flows) {
      if (flow != this) {
        runInAction(() => flow.authState.value = AuthState.signedOut);
      }
    }
  }
}
