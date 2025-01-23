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
          [],
        );
      }
      final loggedIn = await _isLoggedIn();
      if (!loggedIn) {
        return ValidationResult(
          ValidationType.partial,
          [
            const ValidationMessage.warning(
              'Run `pnpm sanity login` to log in to Sanity',
            ),
          ],
          statusInfo: '${_extractVersion(result)} is installed',
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

  Future<bool> _isLoggedIn() async {
    try {
      final result = Process.runSync('pnpm', ['sanity', 'login', '--check']);

      // If exit code is 0, user is logged in
      // If exit code is non-zero, user is not logged in
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  String _extractVersion(ProcessResult result) {
    final versionRegex = RegExp(r'@sanity/cli version (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(result.stdout);
    return match?.group(1) ?? 'Unknown';
  }
}
