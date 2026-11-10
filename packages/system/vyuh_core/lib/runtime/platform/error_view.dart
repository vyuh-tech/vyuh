part of '../platform_widget_builder.dart';

Widget _defaultRouteErrorView(
  BuildContext context, {
  required String title,
  String? retryLabel,
  VoidCallback? onRetry,
  dynamic error,
  StackTrace? stackTrace,
  String? subtitle,
}) => FailurePage(
  title: title,
  message: subtitle,
  error: error,
  stackTrace: stackTrace,
  onRetry: onRetry,
  retryLabel: retryLabel,
);

Widget _defaultErrorView(
  BuildContext context, {
  required String title,
  dynamic error,
  StackTrace? stackTrace,
  String? retryLabel,
  VoidCallback? onRetry,
  String? subtitle,
  bool showRestart = false,
}) => FailureCard(
  title: title,
  message: subtitle,
  error: error,
  stackTrace: stackTrace,
  onRetry: onRetry,
  retryLabel: retryLabel,
  showRestart: showRestart,
);
