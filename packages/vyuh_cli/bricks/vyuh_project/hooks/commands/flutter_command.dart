import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
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

  _createProject(
    HookContext context,
    String name,
    String description,
    String appName,
  ) =>
      trackOperation(
        context,
        startMessage: path.normalize(
          'Setting up the Flutter project @ apps/$appName',
        ),
        endMessage: path.normalize('Flutter project ready @ apps/$appName'),
        operation: () => Process.run(
          'flutter',
          [
            'create',
            name.snakeCase,
            '--template=app',
            '--platforms=ios,android,web',
            '--description=$description',
          ],
          workingDirectory: path.normalize('$appName/apps'),
          runInShell: true,
        ),
      );

  _addPackages(HookContext context, String name, String appName) =>
      trackOperation(
        context,
        startMessage: path.normalize('Adding Flutter packages @ apps/$appName'),
        endMessage: path.normalize('Added Flutter packages @ apps/$appName'),
        operation: () async => Process.run(
          'flutter',
          [
            'pub',
            'add',
            'sanity_client',
            'vyuh_core',
            'vyuh_extension_content',
            'vyuh_feature_system',
            'vyuh_feature_developer',
            'vyuh_plugin_content_provider_sanity',
            'vyuh_plugin_telemetry_provider_console',
            'mobx',
            'flutter_mobx',
            'go_router',
            'flutter_launcher_icons',
            'flutter_native_splash',
          ],
          workingDirectory: path.normalize('$appName/apps/$appName'),
          runInShell: true,
        ),
      );

  _applyOverrides(HookContext context, String appName) => trackOperation(
        context,
        startMessage: 'Updating Flutter project',
        endMessage: 'Flutter project updated',
        operation: () async {
          await _updateYaml(appName);
          await _finalizeOverrides(context, appName);
        },
      );

  _updateYaml(String appName) async {
    final pubspec = File.fromUri(
      Uri.parse('./$appName/apps/$appName/pubspec.yaml'),
    );
    final text = await pubspec.readAsString();

    final json = jsonDecode(r'''
    {
      "flutter": {
        "uses-material-design": true,
        "assets": [
          ".env",
          "assets/app-icon.png"
        ]
      },
      "flutter_launcher_icons": {
        "android": true,
        "ios": true,
        "image_path": "assets/app-icon.png",
        "background_color_ios": "#ffffff",
        "remove_alpha_ios": true,
        "web": {
          "generate": true,
          "image_path": "assets/app-icon.png",
          "background_color": "#ffffff",
          "theme_color": "#a17fff"
        }
      },
      "flutter_native_splash": {
        "color": "#ffffff",
        "image": "assets/launchscreen-image.png"
      }
    }
    ''');

    final editor = YamlEditor(text)
      ..update(['flutter'], json['flutter'])
      ..update(['flutter_launcher_icons'], json['flutter_launcher_icons'])
      ..update(['flutter_native_splash'], json['flutter_native_splash'])
      ..update(['dependencies', 'feature_counter'], '^1.0.0');

    await pubspec.writeAsString(editor.toString());
  }

  _finalizeOverrides(HookContext context, String appName) async {
    await copyPath('./$appName/overrides', './$appName/apps/$appName');

    // Clear out the test file
    final testFile = File.fromUri(
      Uri.parse('./$appName/apps/$appName/test/widget_test.dart'),
    );
    await testFile.writeAsString('');

    // Delete the overrides folder
    await Directory.fromUri(
      Uri.parse('./$appName/overrides'),
    ).delete(recursive: true);
  }
}
