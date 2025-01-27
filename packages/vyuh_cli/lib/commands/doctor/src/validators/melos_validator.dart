import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class MelosValidator extends DoctorValidator {
  MelosValidator() : super('Melos');

  @override
  String get installHelp =>
      'https://melos.invertase.dev/~melos-latest/getting-started';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'melos',
      );

  @override
  String extractVersion(String output) {
    final versionRegex = RegExp(r'^(\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
