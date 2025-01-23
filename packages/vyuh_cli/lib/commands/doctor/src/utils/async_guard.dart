import 'dart:async';

Future<T> asyncGuard<T>(Future<T> Function() fn, {Function? onError}) {
  if (onError != null &&
      onError is! _UnaryOnError<T> &&
      onError is! _BinaryOnError<T>) {
    throw ArgumentError(
      'onError must be a unary function accepting an Object, '
      'or a binary function accepting an Object and '
      'StackTrace. onError must return a T',
    );
  }
  final Completer<T> completer = Completer<T>();

  void handleError(Object e, StackTrace s) {
    if (completer.isCompleted) {
      return;
    }
    if (onError == null) {
      completer.completeError(e, s);
      return;
    }
    if (onError is _BinaryOnError<T>) {
      completer.complete(onError(e, s));
    } else if (onError is _UnaryOnError<T>) {
      completer.complete(onError(e));
    }
  }

  runZoned<void>(
    () async {
      try {
        final T result = await fn();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
        // This catches all exceptions so that they can be propagated to the
        // caller-supplied error handling or the completer.
        // ignore: avoid_catches_without_on_clauses, forwards to Future
      } catch (e, s) {
        handleError(e, s);
      }
    },
    onError: (Object e, StackTrace s) {
      handleError(e, s);
    },
  );

  return completer.future;
}

typedef _UnaryOnError<T> = FutureOr<T> Function(Object error);
typedef _BinaryOnError<T> = FutureOr<T> Function(
    Object error, StackTrace stackTrace);
