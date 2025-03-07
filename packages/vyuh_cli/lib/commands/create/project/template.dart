import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import 'package:vyuh_cli/commands/create/project/vyuh_project_bundle.dart';
import 'package:vyuh_cli/template.dart';
import 'package:vyuh_cli/utils/utils.dart';

class ProjectTemplate extends Template {
  ProjectTemplate()
      : super(
          name: 'project',
          bundle: vyuhProjectBundle,
          help:
              'Generate a Vyuh Project with a Flutter Application and a Sanity Studio.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDir) async {
    // For projects, the outputDir is the parent directory where the project was created
    // We need to determine the actual project directory based on the directory contents
    
    // Look for a subdirectory that contains pubspec.yaml (the Flutter project)  
    final entries = outputDir.listSync();
    Directory? projectDir;
    
    for (final entry in entries) {
      if (entry is Directory) {
        final pubspecFile = File(path.join(entry.path, 'pubspec.yaml'));
        if (pubspecFile.existsSync()) {
          projectDir = entry;
          break;
        }
      }
    }
    
    // If we couldn't find a project directory, use the output directory
    final targetDir = projectDir ?? outputDir;
    
    templateSummary(
      logger: logger,
      outputDir: targetDir,
      message: 'Created a Vyuh Project! 🚀',
    );
  }
}
