import 'dart:async';
import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

enum ValidationType { crash, missing, partial, notAvailable, success }

enum ValidationMessageType { error, warning, information }

abstract class DoctorValidator {
  DoctorValidator(this.title);

  final String title;

  String get slowWarning => UserMessages.slowWarning;

  static const Duration _slowWarningDuration = Duration(seconds: 10);

  /// Duration before the spinner should display [slowWarning].
  Duration get slowWarningDuration => _slowWarningDuration;

  Future<ValidationResult> validate() async {
    final Stopwatch stopwatch = Stopwatch()..start();
    final ValidationResult result = await validateImpl();
    stopwatch.stop();
    result._executionTime = stopwatch.elapsed;
    return result;
  }

  Future<ValidationResult> validateImpl();
}

class ValidationResult {
  /// [ValidationResult.type] should only equal [ValidationResult.success]
  /// if no [messages] are hints or errors.
  ValidationResult(
    this.type,
    this.messages, {
    this.statusInfo,
  });

  factory ValidationResult.crash(Object error, [StackTrace? stackTrace]) {
    return ValidationResult(
      ValidationType.crash,
      <ValidationMessage>[
        const ValidationMessage.error(UserMessages.doctorError),
        ValidationMessage.error('$error'),
        if (stackTrace != null) ValidationMessage('$stackTrace'),
      ],
      statusInfo: UserMessages.doctorCrash,
    );
  }

  final ValidationType type;

  // A short message about the status.
  final String? statusInfo;
  final List<ValidationMessage> messages;

  String get leadingIcon => switch (type) {
        ValidationType.crash => '🚧',
        ValidationType.missing => '🧐',
        ValidationType.success => '✅',
        ValidationType.notAvailable || ValidationType.partial => '⌛',
      };

  /// The time taken to perform the validation, set by [DoctorValidator.validate].
  Duration? get executionTime => _executionTime;
  Duration? _executionTime;

  /// The string representation of the type.
  String get typeStr => switch (type) {
        ValidationType.crash => 'crash',
        ValidationType.missing => 'missing',
        ValidationType.success => 'installed',
        ValidationType.notAvailable => 'notAvailable',
        ValidationType.partial => 'partial',
      };

  @override
  String toString() {
    return '$runtimeType($type, $messages, $statusInfo)';
  }
}

class ValidationMessage {
  const ValidationMessage(this.message)
      : type = ValidationMessageType.information;

  const ValidationMessage.error(this.message)
      : type = ValidationMessageType.error;

  const ValidationMessage.warning(this.message)
      : type = ValidationMessageType.warning;

  final ValidationMessageType type;
  final String message;

  bool get isError => type == ValidationMessageType.error;

  bool get isHint => type == ValidationMessageType.warning;

  bool get isInformation => type == ValidationMessageType.information;

  String get indicator => switch (type) {
        ValidationMessageType.error => '🚩',
        ValidationMessageType.warning => '⚠️',
        ValidationMessageType.information => '👉',
      };

  @override
  String toString() => '$indicator $message';

  @override
  bool operator ==(Object other) {
    return other is ValidationMessage &&
        other.message == message &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(type, message);
}
