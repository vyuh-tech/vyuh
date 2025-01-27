import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class SanityValidator extends DoctorValidator {
  SanityValidator() : super('Sanity');

  @override
  String get installHelp => 'https://www.sanity.io/docs/installation';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'sanity',
      );

  @override
  String extractVersion(String output) {
    final versionRegex = RegExp(r'@sanity/cli version (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
