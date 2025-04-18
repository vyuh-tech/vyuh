# Vyuh Secure Storage Plugin Example

This example demonstrates how to use the `vyuh_plugin_storage_secure` plugin in a Vyuh application.

## Setup

First, add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  vyuh_core: ^1.39.4
  vyuh_plugin_storage_secure: ^1.1.1
```

## Basic Usage

Here's a complete example showing how to configure and use the secure storage plugin:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

void main() {
  // Configure the app with secure storage plugin
  vyuh.runApp(
    plugins: PluginDescriptor(
      secureStorage: FlutterSecureStoragePlugin(
        // Platform-specific options
        androidOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
          sharedPreferencesName: 'my_secure_prefs',
        ),
        iOSOptions: const IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
          synchronizable: true,
        ),
        macOsOptions: const MacOsOptions(
          accessibility: KeychainAccessibility.first_unlock,
          synchronizable: true,
        ),
        linuxOptions: const LinuxOptions(
          // Linux-specific configuration
        ),
        windowsOptions: const WindowsOptions(
          // Windows-specific configuration
        ),
      ),
    ),
  );
}

// Example widget using secure storage
class SecureStorageExample extends StatefulWidget {
  const SecureStorageExample({super.key});

  @override
  State<SecureStorageExample> createState() => _SecureStorageExampleState();
}

class _SecureStorageExampleState extends State<SecureStorageExample> {
  late final SecureStoragePlugin _storage;
  String? _storedValue;

  @override
  void initState() {
    super.initState();
    _storage = vyuh.platform.getPlugin<SecureStoragePlugin>();
    _loadStoredValue();
  }

  Future<void> _loadStoredValue() async {
    final value = await _storage.read('example.key');
    setState(() {
      _storedValue = value;
    });
  }

  Future<void> _saveValue(String value) async {
    await _storage.write('example.key', value);
    await _loadStoredValue();
  }

  Future<void> _deleteValue() async {
    await _storage.delete('example.key');
    await _loadStoredValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Stored Value: $_storedValue'),
        ElevatedButton(
          onPressed: () => _saveValue('Hello from secure storage!'),
          child: const Text('Save Value'),
        ),
        ElevatedButton(
          onPressed: _deleteValue,
          child: const Text('Delete Value'),
        ),
      ],
    );
  }
}
```

## Advanced Usage

### Handling Multiple Values

```dart
// Store multiple values
Future<void> storeUserData(String userId, String token, String email) async {
  final storage = vyuh.platform.getPlugin<SecureStoragePlugin>();
  
  await Future.wait([
    storage.write('user.id', userId),
    storage.write('user.token', token),
    storage.write('user.email', email),
  ]);
}

// Check if values exist
Future<bool> isUserLoggedIn() async {
  final storage = vyuh.platform.getPlugin<SecureStoragePlugin>();
  
  return await storage.has('user.token');
}

// Clear user data
Future<void> logout() async {
  final storage = vyuh.platform.getPlugin<SecureStoragePlugin>();
  
  await Future.wait([
    storage.delete('user.id'),
    storage.delete('user.token'),
    storage.delete('user.email'),
  ]);
}
```

### Error Handling

```dart
Future<String?> safeRead(String key) async {
  try {
    final storage = vyuh.platform.getPlugin<SecureStoragePlugin>();
    return await storage.read(key);
  } catch (e) {
    print('Error reading from secure storage: $e');
    return null;
  }
}
