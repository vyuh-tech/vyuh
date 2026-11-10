import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Describes a document that failed to load.
///
/// [error] is null when the fetch succeeded but returned no document.
VyuhFailure documentFailure({
  required bool isRoute,
  Uri? location,
  Object? error,
  StackTrace? stackTrace,
}) {
  final missing = error == null;
  final strings = VyuhStrings.current;
  return VyuhFailure(
    kind: isRoute
        ? (missing ? FailureKind.notFound : FailureKind.route)
        : FailureKind.content,
    title: isRoute
        ? (missing ? strings.pageNotFoundTitle : strings.pageLoadFailedTitle)
        : (missing
              ? strings.contentNotFoundTitle
              : strings.contentLoadFailedTitle),
    message: missing ? strings.missingMessage : strings.checkConnectionMessage,
    error: error ?? StateError('No document was returned'),
    stackTrace: stackTrace,
    location: location,
  );
}

/// Shows [failure]: a full page with Back and Go home for routes, or an
/// inline card for content inside a page.
///
/// Route failures report themselves once through [RouteFailureView]. Inline
/// failures are reported by the caller when they happen, so nothing is
/// reported from `build`.
Widget buildDocumentFailure(
  BuildContext context, {
  required VyuhFailure failure,
  required bool isRoute,
  VoidCallback? onRetry,
}) {
  if (isRoute) {
    return RouteFailureView(
      key: ObjectKey(failure),
      failure: failure,
      onRetry: onRetry,
    );
  }

  return VyuhFailureScope(
    failure: failure,
    child: Builder(
      builder: (context) => vyuh.widgetBuilder.errorView(
        context,
        title: failure.title,
        subtitle: failure.message,
        error: failure.error,
        stackTrace: failure.stackTrace,
        onRetry: onRetry,
      ),
    ),
  );
}
