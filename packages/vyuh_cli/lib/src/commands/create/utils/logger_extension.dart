import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart';

@visibleForTesting
const fallbackStdoutTerminalColumns = 80;

extension LoggerX on Logger {
  void created(String message) {
    info(lightCyan.wrap(styleBold.wrap(message)));
  }

  void wrap(
    String? text, {
    required void Function(String?) print,
    int? length,
  }) {
    late final int maxLength;
    if (length != null) {
      maxLength = length;
    } else if (stdout.hasTerminal) {
      maxLength = stdout.terminalColumns;
    } else {
      maxLength = fallbackStdoutTerminalColumns;
    }

    for (final sentence in text?.split('/n') ?? <String>[]) {
      final words = sentence.split(' ');

      final currentLine = StringBuffer();
      for (final word in words) {
        // Replace all ANSI sequences so we can get the true character length.
        final charLength = word
            .replaceAll(RegExp('\x1B(?:[@-Z\\-_]|[[0-?]*[ -/]*[@-~])'), '')
            .length;

        if (currentLine.length + charLength > maxLength) {
          print(currentLine.toString());
          currentLine.clear();
        }
        currentLine.write('$word ');
      }

      print(currentLine.toString());
    }
  }
}
