# Vyuh Console Telemetry Provider

A simple console-based telemetry provider for the Vyuh framework that logs telemetry events, errors, and messages to the console using the [logger](https://pub.dev/packages/logger) package. This provider is ideal for development and debugging scenarios where you need to monitor application events and errors in real-time through the console.

## Features 

- **Console Logging** : Log telemetry events directly to the console with pretty formatting
- **Error Tracking** : Detailed error logging with stack traces
- **Flutter Error Support** : Special handling for Flutter-specific errors
- **Log Levels** : Support for multiple log levels (fatal, error, warning, info, debug, trace)
- **Pretty Printing** : Formatted output for better readability
- **No External Dependencies** : Only requires the logger package

## Installation 

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_plugin_telemetry_provider_console: ^1.0.0
```

## Usage 💡

### Basic Setup

Add the console telemetry provider to your Vyuh app's plugin configuration:

```dart
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_telemetry_provider_console/vyuh_plugin_telemetry_provider_console.dart';

void main() {
  runApp(
    plugins: vyuh.PluginDescriptor(
      telemetry: vyuh.TelemetryPlugin(
        providers: [
          ConsoleLoggerTelemetryProvider(),
        ],
      ),
      // ... other plugins
    ),
    features: () => [
      // Your features here
    ],
  );
}
```

### Logging Examples

The provider will automatically log various telemetry events:

```dart
// Log a message
vyuh.telemetry.reportMessage(
  'User logged in',
  level: LogLevel.info,
);

// Log an error
try {
  // Some operation
} catch (e, stack) {
  vyuh.telemetry.reportError(
    e,
    stackTrace: stack,
    fatal: false,
  );
}

// Flutter errors are automatically logged
FlutterError.onError = (details) {
  vyuh.telemetry.reportFlutterError(details);
};
```

## Configuration 

The console logger is configured with sensible defaults:

- Colors disabled for better cross-platform compatibility
- No boxing for cleaner output
- Method count set to 0 to reduce noise
- Line length of 80 characters

## Log Levels 

The provider supports the following log levels:

- **Fatal** : Critical errors that crash the application
- **Error** : Errors that need immediate attention
- **Warning** : Important issues that don't require immediate action
- **Info** : General information about application flow
- **Debug** : Detailed information for debugging
- **Trace** : Very detailed debugging information

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
