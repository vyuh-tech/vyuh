import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class MelosValidator extends DoctorValidator {
  MelosValidator() : super('Melos');

  @override
  Future<ValidationResult> validateImpl() async {
    try {
      final result = Process.runSync('melos', ['--version']);
      if (result.exitCode != 0) {
        return ValidationResult(
          ValidationType.missing,
          [
            ValidationMessage.warning(
              'Install $title using dart: dart pub global activate melos',
            ),
          ],
        );
      }

      return ValidationResult(
        ValidationType.success,
        [],
        statusInfo: '${_extractVersion(result)} is installed',
      );
    } catch (e, stackTrace) {
      return ValidationResult.crash(e, stackTrace);
    }
  }

  String _extractVersion(ProcessResult result) {
    final versionRegex = RegExp(r'^(\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(result.stdout);
    return match?.group(1) ?? 'Unknown';
  }
}
