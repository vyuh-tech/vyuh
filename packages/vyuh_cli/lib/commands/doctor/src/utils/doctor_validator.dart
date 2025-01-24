import 'dart:async';
import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

enum ValidationType { crash, missing, partial, notAvailable, success }

enum ValidationMessageType { error, warning, information }

abstract class DoctorValidator {
  DoctorValidator(this.title);

  final String title;

  String get installHelp;

  String get installInstructions => 'Install $title from $installHelp';

  Future<ValidationResult> validate();

  String extractVersion(String output);
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

  bool get isWarning => type == ValidationMessageType.warning;

  bool get isInformation => type == ValidationMessageType.information;

  String get indicator => switch (type) {
        ValidationMessageType.error => '🚩',
        ValidationMessageType.warning => '⚠️',
        ValidationMessageType.information => '👉',
      };

  @override
  String toString() => message.isNotEmpty ? '   $indicator $message' : message;

  @override
  bool operator ==(Object other) {
    return other is ValidationMessage &&
        other.message == message &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(type, message);
}
