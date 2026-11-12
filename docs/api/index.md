---
title: API Reference
description: Public APIs for composition, shared capabilities, and tooling, derived from source.
prev: false
---

# API reference

Start with the contract you need, then follow its source link for implementation details. These pages list declarations and directly declared public members from the checked-out framework source. They exclude generated serializers, inherited Flutter members, and external package APIs. The catalog includes all public top-level library entry points; library-specific exports determine which import exposes each symbol.

For release-specific inherited documentation, use each package’s linked pub.dev API. Source references point to the owning repository; the current audit includes local fixes that have not been published.

| Package | What it owns | Public declarations |
| --- | --- | --- |
| [vyuh_core](vyuh-core) | Compose features with FeatureDescriptor, choose shared capabilities with PluginDescriptor, and launch through runApp. | 109 |
| [vyuh_cache](vyuh-cache) | Cache&lt;V&gt; wraps CacheStorage&lt;V&gt; with a configured TTL. | 6 |
| [vyuh_plugin_storage_hive](vyuh-plugin-storage-hive) | HiveStoragePlugin persists general values in a Hive box. | 1 |
| [vyuh_plugin_storage_secure](vyuh-plugin-storage-secure) | FlutterSecureStoragePlugin implements string persistence through flutter_secure_storage. | 1 |
| [vyuh_plugin_storage_shared_preferences](vyuh-plugin-storage-shared-preferences) | SharedPreferencesStoragePlugin stores values as strings: write uses value.toString() and read uses getString. | 1 |
| [vyuh_plugin_telemetry_provider_console](vyuh-plugin-telemetry-provider-console) | ConsoleLoggerTelemetryProvider is a telemetry provider used inside TelemetryPlugin.providers. | 1 |
| [vyuh_test](vyuh-test) | Test utilities help wait for the platform to reach ready/error and provide a mocked BuildContext. | 2 |

## Learn the runtime contracts

- [Architecture and ownership](/concepts/features-and-plugins)
- [Startup and lifecycle](/concepts/runtime-lifecycle)
- [Caching and correctness](/concepts/performance)

The optional integration packages have their own [CMS API catalog](/cms/api).
