import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:test/test.dart';

import 'package:vyuh_cli/commands/create/feature/vyuh_feature_bundle.dart';
import 'package:vyuh_cli/commands/create/project/vyuh_project_bundle.dart';

void main() {
  for (final bundle in [vyuhFeatureBundle, vyuhProjectBundle]) {
    test('${bundle.name} embeds the current authoritative brick', () {
      final source = createBundle(Directory('bricks/${bundle.name}'));
      expect(bundle.toJson(), source.toJson());
    });
    test('${bundle.name} generates a Material UI feature without CMS imports',
        () async {
      final directory = Directory.systemTemp.createTempSync('vyuh-template-');
      try {
        final generator = await MasonGenerator.fromBundle(bundle);
        await generator.generate(DirectoryGeneratorTarget(directory),
            vars: {'name': 'sample'});
        final pubspec = bundle.name == 'vyuh_feature'
            ? File('${directory.path}/sample/pubspec.yaml')
            : File(
                '${directory.path}/sample/features/counter/feature_counter/pubspec.yaml');
        final text = pubspec.readAsStringSync();
        expect(text, contains('material_ui:'));
        for (final dependency in [
          'flutter_sanity_portable_text:',
          'vyuh_extension_content:',
          'vyuh_feature_system:'
        ]) {
          expect(text, isNot(contains(dependency)));
        }
        for (final file
            in bundle.files.where((file) => file.path.endsWith('.dart'))) {
          final source = utf8.decode(base64.decode(file.data));
          expect(source, isNot(contains('package:flutter/material.dart')));
          expect(source, isNot(contains('package:vyuh_feature_system/')));
          expect(source, isNot(contains("'/developer'")));
        }
      } finally {
        directory.deleteSync(recursive: true);
      }
    });
  }
}
