import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class PnPmValidator extends DoctorValidator {
  PnPmValidator() : super('PNPM');

  @override
  String get installHelp => 'https://pnpm.io/installation';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'pnpm',
      );

  @override
  String extractVersion(String output) {
    return output.isEmpty ? 'Unknown' : output;
  }
}
