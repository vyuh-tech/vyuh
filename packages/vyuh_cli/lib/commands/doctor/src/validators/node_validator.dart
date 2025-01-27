import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class NodeValidator extends DoctorValidator {
  NodeValidator() : super('Node');

  @override
  String get installHelp => 'https://nodejs.org/en/download';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'node',
      );

  @override
  String extractVersion(String output) {
    return output.isEmpty ? 'Unknown' : output;
  }
}
