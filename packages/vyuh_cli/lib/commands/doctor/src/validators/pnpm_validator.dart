import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class PnPmValidator extends DoctorValidator {
  PnPmValidator() : super('pnpm');

  @override
  Future<ValidationResult> validateImpl() async {
    try {
      final result = Process.runSync('pnpm', ['--version']);
      if (result.exitCode != 0) {
        return ValidationResult(
          ValidationType.missing,
          [],
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
    return result.stdout.trim() ?? 'Unknown';
  }
}
