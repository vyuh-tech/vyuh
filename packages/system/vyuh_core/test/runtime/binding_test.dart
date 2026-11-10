import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'helpers.dart';

void main() {
  tearDown(() async {
    if (VyuhBinding.instance.initialized) await VyuhBinding.instance.dispose();
  });

  test('widget mode starts plugins and one extension builder without '
      'an app', () async {
    final builder = TestBuilder();
    final descriptor = TestDescriptor();
    VyuhBinding? readyBinding;

    final binding = VyuhBinding.instance;
    expect(binding.initInvoked, isFalse);

    binding.widgetInit(
      extensionBuilder: builder,
      extensionDescriptors: [descriptor],
      onReady: (b) async => readyBinding = b,
    );
    expect(binding.initInvoked, isTrue);
    expect(binding.initialized, isTrue);
    expect(binding.widgetBuilder, same(PlatformWidgetBuilder.system));

    await binding.widgetReady;
    expect(readyBinding, same(binding));
    expect(builder.registered, [descriptor]);

    // The same named accessors as `vyuh.*`.
    expect(binding.di, isA<DIPlugin>());
    expect(binding.analytics, isA<AnalyticsPlugin>());
    expect(binding.telemetry, isA<TelemetryPlugin>());
    expect(binding.network, isA<NetworkPlugin>());
    expect(binding.featureFlag, isNull);
    expect(binding.env, isA<EnvPlugin>());
    expect(binding.event, isA<EventPlugin>());
    expect(binding.auth, isA<AuthPlugin>());
    expect(binding.router, isA<NavigationPlugin>());
    expect(binding.locale, isNull);
    expect(binding.storage, isA<StoragePlugin>());
    expect(binding.secureStorage, isA<SecureStoragePlugin>());

    // A second call is ignored.
    binding.widgetInit(
      extensionBuilder: TestBuilder(title: 'other'),
      extensionDescriptors: [],
    );
    expect(binding.plugins, PluginDescriptor.system.plugins);

    await binding.dispose();
    expect(builder.isDisposed, isTrue);
    expect(builder.registered, isEmpty);
    expect(binding.initialized, isFalse);
    expect(VyuhBinding.instance, isNot(same(binding)));
  });

  test('widget mode uses the given plugins and widget builder', () async {
    final telemetry = RecordingTelemetry();
    final plugins = recordingPlugins(telemetry);
    final widgetBuilder = PlatformWidgetBuilder.system.copyWith(
      strings: const VyuhStrings(tryAgain: 'Retry'),
    );

    VyuhBinding.instance.widgetInit(
      plugins: plugins,
      widgetBuilder: widgetBuilder,
      extensionBuilder: TestBuilder(),
      extensionDescriptors: [],
    );
    await VyuhBinding.instance.widgetReady;

    expect(VyuhBinding.instance.plugins, plugins.plugins);
    expect(VyuhBinding.instance.widgetBuilder, same(widgetBuilder));
    expect(VyuhStrings.current.tryAgain, 'Retry');

    VyuhBinding.instance.log.warn('careful');
    expect(telemetry.messages, ['careful']);
  });

  test('disposing a binding that never started does nothing', () async {
    await VyuhBinding.instance.dispose();
    expect(VyuhBinding.instance.initialized, isFalse);
  });
}
