<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Secure Storage Plugin</h1>
  <p align="center">Secure Storage Plugin for Vyuh Framework using flutter_secure_storage</p>
  <p align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </p>
</p>

# Vyuh Secure Storage Plugin 🔐

[![vyuh_plugin_storage_secure](https://img.shields.io/pub/v/vyuh_plugin_storage_secure.svg?label=vyuh_plugin_storage_secure&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_plugin_storage_secure)

A secure storage plugin for the Vyuh framework that provides encrypted key-value
storage for sensitive information using platform-specific secure storage
mechanisms:

- iOS and macOS: Keychain
- Android: encrypted storage backed by the Android Keystore
- Web: encrypted browser storage
- Linux: Secret Service API
- Windows: Windows Credential Manager

## Installation

```yaml
dependencies:
  vyuh_plugin_storage_secure: ^1.6.0
```

## Setup

The package re-exports the platform option classes of
`flutter_secure_storage`, so you don't need to depend on it directly.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

void main() {
  vyuh.runApp(
    plugins: vyuh.PluginDescriptor(
      secureStorage: FlutterSecureStoragePlugin(
        iOSOptions: const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ),
    ),
    features: () => [/* ... */],
  );
}
```

## Usage

```dart
final storage = vyuh.vyuh.secureStorage;

await storage.write('auth.token', 'your-secure-token'); // returns the stored string
final token = await storage.read('auth.token');          // String?
final hasToken = await storage.has('auth.token');
final deleted = await storage.delete('auth.token');      // false if it wasn't there
```

Values are stored as strings: `write` stores `value.toString()` and returns
it. Writing `null` deletes the key. Using the plugin before `init` or after
`dispose` throws a `StateError`.

## Contributing 🤝

Contributions are welcome! Please read our
[contributing guidelines](https://github.com/vyuh-tech/vyuh/blob/main/CONTRIBUTING.md)
to get started.

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
