import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class DartValidator extends DoctorValidator {
  DartValidator() : super('Dart');

  @override
  String get installHelp => 'https://dart.dev/get-dart';

  @override
  Future<ValidationResult> validate() async {
    try {
      final result = Process.runSync('dart', ['--version']);
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
    final versionRegex = RegExp(r'Dart SDK version: (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
