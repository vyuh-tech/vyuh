import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class PnPmValidator extends DoctorValidator {
  PnPmValidator() : super('pnpm');

  @override
  String get installHelp => 'https://pnpm.io/installation';

  @override
  Future<ValidationResult> validate() async {
    try {
      final result = Process.runSync('pnpm', ['--version']);
      if (result.exitCode != 0) {
        return ValidationResult(
          ValidationType.missing,
          [
            const ValidationMessage(''),
            const ValidationMessage.error(UserMessages.commandNotFound),
            ValidationMessage.warning('${result.stdout}'),
            ValidationMessage(installInstructions),
            const ValidationMessage(''),
          ],
        );
      }

      return ValidationResult(
        ValidationType.success,
        [],
        statusInfo: UserMessages.isInstalledMessage(
          extractVersion('${result.stdout}'.trim()),
        ),
      );
    } on ProcessException catch (e) {
      return ValidationResult(
        ValidationType.missing,
        [
          const ValidationMessage(''),
          ValidationMessage.error(UserMessages.exceptionMessage(e)),
          ValidationMessage(installInstructions),
          const ValidationMessage(''),
        ],
      );
    } catch (e, stackTrace) {
      return ValidationResult.crash(e, stackTrace);
    }
  }

  @override
  String extractVersion(String output) {
    return output.isEmpty ? 'Unknown' : output;
  }
}
