class SanityException implements Exception {
  SanityException([
    this._message,
    this._prefix,
  ]);

  final String? _message;
  final String? _prefix;

  @override
  String toString() => '${_prefix ?? ''}${_message ?? ''}';
}

class FetchDataException extends SanityException {
  FetchDataException([final String? message])
      : super(message, 'Error during communication: ');
}

class BadRequestException extends SanityException {
  BadRequestException([final String? message])
      : super(message, 'Invalid request: ');
}

class UnauthorizedException extends SanityException {
  UnauthorizedException([final String? message])
      : super(message, 'Unauthorized: ');
}

class InvalidReferenceException extends SanityException {
  InvalidReferenceException([final String? message])
      : super(message, 'Invalid reference: ');
}

final class InvalidResultTypeException extends SanityException {
  final Type expectedType;
  final Type actualType;

  InvalidResultTypeException({
    required this.expectedType,
    required this.actualType,
  });

  @override
  String toString() =>
      'Invalid result type: $actualType. Was expecting $expectedType';
}
