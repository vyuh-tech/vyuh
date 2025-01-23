import 'package:mason_logger/mason_logger.dart';
import 'package:vyuh_cli/commands/doctor/src/utils/doctor_validator.dart';

import 'utils/user_messages.dart';
import 'validators/validators.dart';

class Doctor {
  final Logger _logger;

  Doctor({
    required Logger logger,
  }) : _logger = logger;

  List<DoctorValidator> validators = [
    FlutterValidator(),
    DartValidator(),
    MelosValidator(),
    NodeValidator(),
    PnPmValidator(),
  ];

  Future<bool> diagnose() async {
    _logger.info('Doctor summary:');

    bool doctorResult = true;
    int issues = 0;
    for (final validator in validators) {
      final progress = _logger.progress('Checking ${validator.title}');
      final result = await validator.validate();

      switch (result.type) {
        case ValidationType.crash:
        case ValidationType.missing:
          doctorResult = false;
          issues += 1;
          progress.fail(
            '${validator.title} ${result.statusInfo ?? result.typeStr} ${result.leadingIcon}',
          );
        case ValidationType.partial:
        case ValidationType.notAvailable:
          issues += 1;
          progress.fail(
            '${validator.title} ${result.statusInfo ?? result.typeStr} ${result.leadingIcon}',
          );
        case ValidationType.success:
          progress.complete(
            '${validator.title} ${result.statusInfo ?? result.typeStr} ${result.leadingIcon}',
          );
          break;
      }

      for (final ValidationMessage message in result.messages) {
        switch (message.type) {
          case ValidationMessageType.error:
            _logger.err(message.toString());
            break;
          case ValidationMessageType.warning:
            _logger.alert(message.toString());
            break;
          case ValidationMessageType.information:
            _logger.info(message.toString());
            break;
        }
      }
    }

    _logger.info('');
    _logger.info(UserMessages.summarizeDoctorCheckup(issues));

    return doctorResult;
  }
}
