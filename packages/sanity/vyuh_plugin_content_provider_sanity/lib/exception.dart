import 'package:sanity_client/sanity_client.dart';

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
