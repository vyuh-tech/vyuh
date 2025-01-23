import 'dart:io';

import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class DartValidator extends DoctorValidator {
  DartValidator() : super('Dart');

  @override
  Future<ValidationResult> validateImpl() async {
    try {
      final result = Process.runSync('dart', ['--version']);
      if (result.exitCode != 0) {
        return ValidationResult(
          ValidationType.missing,
          [
            ValidationMessage.warning(
              'Install $title from https://dart.dev/get-dart',
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
            'Install $title from https://dart.dev/get-dart',
          ),
          ValidationMessage.error(
            'Error running $title: ${e.message}',
          ),
        ],
      );
    } catch (e, stackTrace) {
      return ValidationResult.crash(e, stackTrace);
    }
  }

  String _extractVersion(ProcessResult result) {
    final versionRegex = RegExp(r'Dart SDK version: (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(result.stdout);
    return match?.group(1) ?? 'Unknown';
  }
}
