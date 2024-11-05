import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/process_run.dart';

class DoctorCommand extends Command<int> {
  DoctorCommand({required Logger logger}) : _logger = logger {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Display additional information about the checks.',
      negatable: false,
    );
  }

  final Logger _logger;
  int _issuesFound = 0;

  @override
  String get invocation => 'vyuh doctor';

  @override
  String get description => 'Check the health of the CLI.';

  static const String commandName = 'vyuh doctor';

  @override
  String get name => commandName;

  @override
  Future<int> run() async {
    _logger.info('\nRunning Vyuh Doctor...\n');

    final checks = [
      _checkTool('Node.js', 'node', ['-v']),
      _checkTool('Dart', 'dart', ['--version']),
      _checkTool('Melos', 'melos', ['--version']),
      _checkTool('Pnpm', 'pnpm', ['--version']),
      _checkSanityCLI(),
    ];

    try {
      await Future.wait(checks);
      _logger.info('\nVyuh Doctor Summary:');
      _logger.info(_issuesFound == 0
          ? 'No issues found. Everything is working correctly!'
          : 'Found $_issuesFound issue${_issuesFound > 1 ? "s" : ""}. Please address the above issues.');
      return _issuesFound == 0 ? ExitCode.success.code : ExitCode.software.code;
    } catch (e) {
      _logger.err(e.toString());
      return ExitCode.software.code;
    }
  }

  Future<void> _checkTool(String name, String command, List<String> args) async {
    try {
      final result = await runExecutableArguments(command, args);
      final output = (result.stdout ?? result.stderr).toString().trim();
      if (output.isNotEmpty) {
        _logger.info('✅ $name is installed (version: $output)');
      } else {
        _logger.info('❌ $name not found. Please install $name to continue.');
        _issuesFound++;
      }
    } catch (e) {
      _logger.info('❌ Error occurred while checking for $name: ${e.toString()}');
      _issuesFound++;
    }
  }

  Future<void> _checkSanityCLI() async {
    try {
      final result = await runExecutableArguments('sanity', ['versions']);
      _logger.info('✅ Sanity CLI is installed (version: ${result.stdout.trim()})');
      await _checkSanityLogin();
    } catch (e) {
      _logger.info('❌ Sanity CLI not found. Run `npm install -g @sanity/cli` to install.');
      _issuesFound++;
    }
  }

  Future<void> _checkSanityLogin() async {
    try {
      final result = await runExecutableArguments('sanity', ['projects', 'list']);
      if (result.stderr.contains('You must login first')) {
        _logger.info('\t❌ Sanity CLI is not logged in. Run `sanity login` to log in.');
        _issuesFound++;
      } else {
        _logger.info('\t✅ Sanity CLI is logged in.');
      }
    } catch (e) {
      _logger.info('\t❌ Error occurred while checking Sanity CLI login: ${e.toString()}');
      _issuesFound++;
    }
  }
}
