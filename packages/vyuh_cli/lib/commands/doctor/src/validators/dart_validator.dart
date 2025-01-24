import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class DartValidator extends DoctorValidator {
  DartValidator() : super('Dart');

  @override
  String get installHelp => 'https://dart.dev/get-dart';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'dart',
      );

  @override
  String extractVersion(String output) {
    final versionRegex = RegExp(r'Dart SDK version: (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
