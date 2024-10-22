import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:universal_io/io.dart';
import 'package:vyuh_cli/utils/logger_extension.dart';

typedef MasonGeneratorFromBundle = Future<MasonGenerator> Function(MasonBundle);

typedef MasonGeneratorFromBrick = Future<MasonGenerator> Function(Brick);

final RegExp identifierRegExp = RegExp('[a-z_][a-z0-9_]*');
final RegExp orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

const String defaultCMS = 'sanity';
const String vyuhInfoText = '''

+----------------------------------------------------+
| Looking for more features?                         |
|----------------------------------------------------|
| We have an enterprise-grade solution!              |
|                                                    |
| For more info visit:                               |
| https://vyuh.tech                                  |
+----------------------------------------------------+

''';

void templateSummary({
  required Logger logger,
  required Directory outputDir,
  required String message,
}) {
  final relativePath = path.relative(
    outputDir.path,
    from: Directory.current.path,
  );

  final projectPath = relativePath;
  final projectPathLink =
      link(uri: Uri.parse(projectPath), message: projectPath);

  final readmePath = path.join(relativePath, 'README.md');
  final readmePathLink = link(uri: Uri.parse(readmePath), message: readmePath);

  final details = '''
  • To get started refer to $readmePathLink
  • Your project code is in $projectPathLink
''';

  logger
    ..info('\n')
    ..created(message)
    ..info(details)
    ..info(
      lightGray.wrap(vyuhInfoText),
    );
}
