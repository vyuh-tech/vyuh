import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/user_messages.dart';

import 'doctor_validator.dart';

Future<ValidationResult> commandVersionValidator(
  DoctorValidator validator, {
  required String command,
  List<String> arguments = const ['--version'],
}) async {
  try {
    final result = Process.runSync(command, arguments);
    if (result.exitCode != 0) {
      return ValidationResult(
        ValidationType.missing,
        [
          const ValidationMessage(''),
          const ValidationMessage.error(UserMessages.commandNotFound),
          ValidationMessage.warning('${result.stdout}'),
          ValidationMessage(validator.installInstructions),
          const ValidationMessage(''),
        ],
      );
    }

    return ValidationResult(
      ValidationType.success,
      [],
      statusInfo: UserMessages.isInstalledMessage(
        validator.extractVersion('${result.stdout}'.trim()),
      ),
    );
  } on ProcessException catch (e) {
    return ValidationResult(
      ValidationType.missing,
      [
        const ValidationMessage(''),
        ValidationMessage.error(UserMessages.exceptionMessage(e)),
        ValidationMessage(validator.installInstructions),
        const ValidationMessage(''),
      ],
    );
  } catch (e, stackTrace) {
    return ValidationResult.crash(e, stackTrace);
  }
}
