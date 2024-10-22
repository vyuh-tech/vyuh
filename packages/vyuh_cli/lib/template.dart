import 'package:mason/mason.dart';
import 'package:universal_io/io.dart';

abstract class Template {
  const Template({
    required this.name,
    required this.bundle,
    required this.help,
  });

  final String name;

  final MasonBundle bundle;

  final String help;

  Future<void> onGenerateComplete(Logger logger, Directory outputDir);
}
