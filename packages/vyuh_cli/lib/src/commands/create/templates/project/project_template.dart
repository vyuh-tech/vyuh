import 'dart:io';

import 'package:mason/mason.dart';
import 'package:vyuh_cli/src/commands/create/templates/index.dart';
import 'package:vyuh_cli/src/commands/create/utils/utils.dart';

class ProjectTemplate extends Template {
  ProjectTemplate()
      : super(
          name: 'project',
          bundle: vyuhInitBundle,
          help:
              'Generate a Vyuh Project with a Flutter Application and a Sanity Studio.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    templateSummary(
      logger: logger,
      outputDir: outputDir,
      message: 'Created a Vyuh Project! 🚀',
    );
  }
}
