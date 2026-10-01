import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:test/test.dart';
import 'package:vyuh_cli/commands/create/feature/command.dart';
import 'package:vyuh_cli/commands/create/plugin/command.dart';
import 'package:vyuh_cli/commands/create/plugin/vyuh_plugin_bundle.dart';
import 'package:vyuh_cli/commands/create/project/command.dart';

void main() {
  test(
      'App options default to no CMS and honor platform and organization choices',
      () {
    final c = CreateProjectCommand(
        logger: Logger(), generatorFromBundle: null, generatorFromBrick: null);
    c.argResultOverrides = c.argParser.parse([
      'catalog',
      '--platforms=web,android',
      '--org-name=com.acme',
      '--application-id=com.acme.shop'
    ]);
    c.validateArgs();
    final v = c.getTemplateVars();
    expect(v['cms'], 'none');
    expect(v['platforms'], 'web,android');
    expect(v['org_name'], 'com.acme');
    expect(v['application_id'], 'com.acme.shop');
    c.argResultOverrides = c.argParser.parse(['catalog', '--cms=sanity']);
    expect(c.getTemplateVars()['cms'], 'sanity');
    expect(() => c.argParser.parse(['catalog', '--cms=unknown']),
        throwsFormatException);
  });
  test('feature parameters generate escaped metadata and the requested route',
      () async {
    final c = CreateFeatureCommand(
        logger: Logger(), generatorFromBundle: null, generatorFromBrick: null);
    c.argResultOverrides = c.argParser.parse([
      'feature_catalog',
      '--title=Our "Catalog"',
      '--description=Customer\'s catalog',
      '--route=/shop'
    ]);
    c.validateArgs();
    final d = Directory.systemTemp.createTempSync('vyuh-feature-options-');
    try {
      final g = await MasonGenerator.fromBundle(c.template.bundle);
      await g.generate(DirectoryGeneratorTarget(d), vars: c.getTemplateVars());
      final s =
          File('${d.path}/feature_catalog/lib/feature.dart').readAsStringSync();
      expect(s, contains('path: "/shop"'));
      expect(s, contains(r'title: "Our \"Catalog\""'));
      expect(s, contains('description: "Customer\'s catalog"'));
      expect(s, isNot(contains('{{')));
    } finally {
      d.deleteSync(recursive: true);
    }
  });
  test('plugin scaffold exports the chosen class and a lifecycle test',
      () async {
    final c = CreatePluginCommand(
        logger: Logger(), generatorFromBundle: null, generatorFromBrick: null);
    c.argResultOverrides = c.argParser
        .parse(['search', '--class-name=SearchCapability', '--title=Search']);
    c.validateArgs();
    final d = Directory.systemTemp.createTempSync('vyuh-plugin-options-');
    try {
      final g = await MasonGenerator.fromBundle(vyuhPluginBundle);
      await g.generate(DirectoryGeneratorTarget(d), vars: c.getTemplateVars());
      final s = File('${d.path}/search/lib/src/plugin.dart').readAsStringSync();
      expect(
          s,
          contains(
              'class SearchCapability extends Plugin with InitOncePlugin'));
      expect(s, contains('Future<void> disposeOnce()'));
      expect(File('${d.path}/search/test/plugin_test.dart').readAsStringSync(),
          contains('SearchCapability()'));
      expect(File('${d.path}/search/pubspec.yaml').readAsStringSync(),
          isNot(contains('sanity')));
      expect(vyuhPluginBundle.toJson(),
          createBundle(Directory('bricks/vyuh_plugin')).toJson());
    } finally {
      d.deleteSync(recursive: true);
    }
  });
  test('invalid package names, routes, and class names are rejected', () {
    final f = CreateFeatureCommand(
        logger: Logger(), generatorFromBundle: null, generatorFromBrick: null);
    CommandRunner<int>('vyuh', 'Test runner').addCommand(f);
    for (final args in [
      ['invalid-name'],
      ['catalog', '--route=relative']
    ]) {
      f.argResultOverrides = f.argParser.parse(args);
      expect(f.validateArgs, throwsA(isA<UsageException>()));
    }
    final p = CreatePluginCommand(
        logger: Logger(), generatorFromBundle: null, generatorFromBrick: null);
    CommandRunner<int>('vyuh', 'Test runner').addCommand(p);
    p.argResultOverrides =
        p.argParser.parse(['search', '--class-name=invalid-class']);
    expect(p.validateArgs, throwsA(isA<UsageException>()));
  });
}
