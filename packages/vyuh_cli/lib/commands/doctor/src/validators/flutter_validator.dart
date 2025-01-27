import 'package:vyuh_cli/commands/doctor/src/utils/utils.dart';

class FlutterValidator extends DoctorValidator {
  FlutterValidator() : super('Flutter');

  @override
  String get installHelp => 'https://flutter.dev/docs/get-started/install';

  @override
  Future<ValidationResult> validate() => commandVersionValidator(
        this,
        command: 'flutter',
      );

  @override
  String extractVersion(String output) {
    final versionRegex = RegExp(r'Flutter (\d+\.\d+\.\d+)');
    final match = versionRegex.firstMatch(output);
    return match?.group(1) ?? 'Unknown';
  }
}
