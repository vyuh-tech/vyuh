import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class FlutterValidator extends DoctorValidator {
  FlutterValidator() : super('Flutter');

  @override
  String get installHelp => 'https://flutter.dev/docs/get-started/install';

  @override
  Future<ValidationResult> validate() async {
    try {
      final result = Process.runSync('flutter', ['--version']);
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
    final versionRegex = RegExp(r'Flutter (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
