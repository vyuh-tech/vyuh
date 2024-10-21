import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/src/commands/create/templates/index.dart';
import 'package:vyuh_cli/src/commands/create/utils/utils.dart';

class FeatureTemplate extends Template {
  FeatureTemplate()
      : super(
          name: 'feature',
          bundle: vyuhFeatureBundle,
          help: 'Generate a Vyuh Feature as a Flutter package.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
      logger: logger,
      outputDir: outputDir,
      message: 'Created a Vyuh Feature! 🚀',
    );
  }
}
