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

- iOS: Keychain
- Android: EncryptedSharedPreferences
- Web: LocalStorage with encryption
- macOS: Keychain
- Linux: Secret Service API
- Windows: Windows Credential Manager

## Features ✨

- **Platform-specific Secure Storage** 🛡️: Uses the most secure storage
  mechanism available on each platform
- **Encrypted Data** 🔒: All data is encrypted before storage
- **Simple API** 🎯: Easy-to-use key-value storage interface
- **Configurable Options** ⚙️: Platform-specific configuration options for
  fine-tuned control
- **Null Safety** ✅: Built with sound null safety

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_plugin_storage_secure: ^1.1.0
```

## Usage 💡

### Basic Setup

Configure secure storage in your Vyuh application:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

void main() {
  vyuh.runApp(
    plugins: PluginDescriptor(
      secureStorage: FlutterSecureStoragePlugin(
        androidOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      ),
      // ... other plugins
    ),
    // ... other configuration
  );
}
```

### Using the Plugin

Access the secure storage plugin:

```dart
final storage = vyuh.platform.getPlugin<SecureStoragePlugin>();

// Store sensitive data
await storage.write('auth.token', 'your-secure-token');

// Read stored data
final token = await storage.read('auth.token');
print('Token: $token');

// Check if key exists
final hasToken = await storage.has('auth.token');
if (hasToken) {
  // Key exists
}

// Delete data
final deleted = await storage.delete('auth.token');
if (deleted) {
  // Key was successfully deleted
}
```

### Platform-specific Configuration

Configure platform-specific options when creating the plugin:

```dart
void main() {
  vyuh.runApp(
    plugins: PluginDescriptor(
      secureStorage: FlutterSecureStoragePlugin(
        androidOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOSOptions: const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
        // ... other platform options
      ),
    ),
  );
}
```

## Platform Support 🌍

| Platform | Storage Mechanism          | Encryption                 |
| -------- | -------------------------- | -------------------------- |
| Android  | EncryptedSharedPreferences | AES-256 with CBC           |
| iOS      | Keychain                   | Hardware-backed encryption |
| Web      | LocalStorage               | AES encryption in memory   |
| macOS    | Keychain                   | Hardware-backed encryption |
| Linux    | Secret Service API         | System-provided encryption |
| Windows  | Credential Manager         | System-provided encryption |

## Contributing 🤝

Contributions are welcome! Please read our
[contributing guidelines](https://github.com/vyuh-tech/vyuh/blob/main/CONTRIBUTING.md)
to get started.

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
