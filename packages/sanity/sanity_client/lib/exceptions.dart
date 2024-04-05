/// Base type for exceptions thrown by the Sanity client.
abstract class SanityException implements Exception {
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
class FetchDataException extends SanityException {
  FetchDataException([final String? message])
      : super(message, 'Error during communication: ');
}

/// Exception when the request is invalid.
class BadRequestException extends SanityException {
  BadRequestException([final String? message])
      : super(message, 'Invalid request: ');
}

/// Exception when the request is unauthorized and does not include a valid token
/// in the Authorization header.
class UnauthorizedException extends SanityException {
  UnauthorizedException([final String? message])
      : super(message, 'Unauthorized: ');
}

/// Exception when the request is forbidden.
class InvalidReferenceException extends SanityException {
  InvalidReferenceException([final String? message])
      : super(message, 'Invalid reference: ');
}
