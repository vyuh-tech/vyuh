import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:yaml_edit/yaml_edit.dart';

import 'cli_command.dart';

final class FlutterCommand extends CliCommand {
  @override
  Future<void> run(HookContext context) async {
    final String name = context.vars['name'];
    final String description = context.vars['description'];
    final appName = name.snakeCase;

    await _createProject(context, name, description, appName);
    await _addPackages(context, name, appName);
    await _applyOverrides(context, appName);
  }

  _createProject(HookContext context, String name, String description,
          String appName) =>
      trackOperation(context,
          startMessage:
              p.normalize('Setting up the Flutter project @ apps/$appName'),
          endMessage: p.normalize('Flutter project ready @ apps/$appName'),
          operation: () => Process.run(
                'flutter',
                [
                  'create',
                  name.snakeCase,
                  '--template=app',
                  '--platforms=ios,android,web',
                  '--description=$description',
                ],
                workingDirectory: p.normalize('$appName/apps'),
              ));

  _addPackages(HookContext context, String name, String appName) =>
      trackOperation(
        context,
        startMessage: p.normalize('Adding Flutter packages @ apps/$appName'),
        endMessage: p.normalize('Added Flutter packages @ apps/$appName'),
        operation: () async => Process.run(
          'flutter',
          [
            'pub',
            'add',
            ...'sanity_client vyuh_core vyuh_extension_content vyuh_feature_system vyuh_feature_developer vyuh_plugin_content_provider_sanity mobx flutter_mobx'
                .split(' '),
          ],
          workingDirectory: p.normalize('$appName/apps/$appName'),
        ),
      );

  _applyOverrides(HookContext context, String appName) => trackOperation(
        context,
        startMessage: 'Updating Flutter project',
        endMessage: 'Flutter project updated',
        operation: () async {
          await _addFeature(appName);
          await _updateMain(context, appName);
        },
      );

  _addFeature(String appName) async {
    final pubspec =
        File.fromUri(Uri.parse('./$appName/apps/$appName/pubspec.yaml'));
    final text = await pubspec.readAsString();
    final editor = YamlEditor(text)
      ..update(['dependencies', 'feature_counter'], '^1.0.0');

    await pubspec.writeAsString(editor.toString());
  }

  _updateMain(HookContext context, String appName) async {
    // Copy the main.dart file
    final mainFile = File.fromUri(Uri.parse('./$appName/overrides/main.dart'));
    await mainFile.copy(p.normalize('./$appName/apps/$appName/lib/main.dart'));

    // Clear out the test file
    final testFile = File.fromUri(
        Uri.parse('./$appName/apps/$appName/test/widget_test.dart'));
    await testFile.writeAsString('');

    // Delete the overrides folder
    await Directory.fromUri(Uri.parse('./$appName/overrides'))
        .delete(recursive: true);
  }
}
