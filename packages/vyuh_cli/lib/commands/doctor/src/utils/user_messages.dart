import 'dart:io';

sealed class UserMessages {
  static const String vyuhToolBugInstructions =
      'Please report a bug at https://github.com/vyuh-tech/vyuh/issues';

  static const String doctorError =
      'Due to an error, the doctor check did not complete. '
      'If the error message below is not helpful, '
      '$vyuhToolBugInstructions';

  static const String doctorCrash = 'the doctor check crashed';

  static String summarizeDoctorCheckup(int issues) {
    if (issues == 0) {
      return '🚀 No issues found!';
    }
    return '❗ Doctor found issues in $issues categor${issues > 1 ? "ies" : "y"}.';
  }

  static String isInstalledMessage(String version) => '$version is installed';

  static const commandNotFound = 'Command not found';

  static String exceptionMessage(Exception e) {
    switch (e) {
      case ProcessException _:
        return '$commandNotFound: [${e.errorCode}] ${e.message}';
      default:
        return commandNotFound;
    }
  }
}
