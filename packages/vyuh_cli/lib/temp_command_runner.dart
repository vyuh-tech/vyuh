import 'package:mason_logger/mason_logger.dart';
import 'package:vyuh_cli/doctor/command.dart';

void main(List<String> args) {
  if(args.isEmpty) {
    print('Please provide arguments');
    return;
  }


  final command = args[0];
  switch (command) {
    case 'doctor':
      final doctorCommand = DoctorCommand(logger: Logger());
      doctorCommand.run();
      break;
    default:
      print('Unknown command: $command');
  }
}