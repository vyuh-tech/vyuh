import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

const _cliDirectory = 'packages/vyuh_cli';

void main() async {
  final logger = Logger();
  logger.info('Starting version update process');

  try {
    // Read the pubspec.yaml file
    final pubspecFile = File('$_cliDirectory/pubspec.yaml');
    logger.info('Reading pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsString();
    final pubspec = Pubspec.parse(pubspecContent);

    // Get the current version
    final version = pubspec.version.toString();
    logger.info('Current version: $version');

    // Update the version.dart file
    final versionFile = File('$_cliDirectory/lib/version.dart');
    logger.info('Updating $_cliDirectory/lib/version.dart');
    await versionFile.writeAsString('''
// Generated code. Do not modify.
const packageVersion = '$version';
''');

    logger.success('Successfully updated version.dart with version $version');
  } catch (e) {
    logger.err('An error occurred while updating the version $e');
    exit(1);
  }
}
