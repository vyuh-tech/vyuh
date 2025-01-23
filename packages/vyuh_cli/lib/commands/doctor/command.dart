import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:vyuh_cli/commands/doctor/src/doctor.dart';

final class DoctorCommand extends Command<int> {
  DoctorCommand({
    required Logger logger,
  }) : _logger = logger;

  final Logger _logger;

  @override
  String get summary => '$invocation\n$description';

  @override
  final String description = 'Show information about the installed tooling.';

  @override
  String get name => 'doctor';

  @override
  String get invocation => 'vyuh doctor';

  @override
  Future<int> run() async {
    Doctor doctor = Doctor(logger: _logger);
    final bool success = await doctor.diagnose();
    return success ? ExitCode.success.code : ExitCode.tempFail.code;
  }
}
