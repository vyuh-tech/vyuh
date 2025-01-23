import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class SanityValidator extends DoctorValidator {
  SanityValidator() : super('Sanity');

  @override
  Future<ValidationResult> validateImpl() async {
    try {
      final result = Process.runSync('pnpm', ['sanity', '--version']);
      if (result.exitCode != 0) {
        return ValidationResult(
          ValidationType.missing,
          [
            ValidationMessage.warning(
              'Install $title from https://www.sanity.io/docs/installation',
            ),
            ValidationMessage.error(
              'Exit Code:${result.exitCode} ${result.stdout}',
            ),
          ],
        );
      }

      return ValidationResult(
        ValidationType.success,
        [],
        statusInfo: '${_extractVersion(result)} is installed',
      );
    } on ProcessException catch (e) {
      return ValidationResult(
        ValidationType.missing,
        [
          ValidationMessage(
            'Install $title from https://www.sanity.io/docs/installation',
          ),
          ValidationMessage.error(
            'Error running sanity: ${e.message}',
          ),
        ],
      );
    } catch (e, stackTrace) {
      return ValidationResult.crash(e, stackTrace);
    }
  }

  String _extractVersion(ProcessResult result) {
    final versionRegex = RegExp(r'@sanity/cli version (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(result.stdout);
    return match?.group(1) ?? 'Unknown';
  }
}
