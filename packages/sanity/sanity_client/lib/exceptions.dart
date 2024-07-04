/// Base type for exceptions thrown by the Sanity client.
abstract base class SanityException implements Exception {
  /// Creates a new Sanity exception.
  SanityException([
    this._message,
    this._prefix,
  ]);

  final String? _message;
  final String? _prefix;

  @override
  String toString() => '${_prefix ?? ''}${_message ?? ''}';
}

/// Exception thrown when a document is not found.
final class FetchDataException extends SanityException {
  /// Creates a new fetch data exception.
  FetchDataException([final String? message])
      : super(message, 'Error during communication: ');
}

/// Exception when the request is invalid.
final class BadRequestException extends SanityException {
  /// Creates a new bad request exception.
  BadRequestException([final String? message])
      : super(message, 'Invalid request: ');
}

/// Exception when the request is unauthorized and does not include a valid token
/// in the Authorization header.
final class UnauthorizedException extends SanityException {
  /// Creates a new unauthorized exception.
  UnauthorizedException([final String? message])
      : super(message, 'Unauthorized: ');
}

/// Exception when the request is forbidden.
final class InvalidReferenceException extends SanityException {
  /// Creates a new invalid reference exception.
  InvalidReferenceException([final String? message])
      : super(message, 'Invalid reference: ');
}
