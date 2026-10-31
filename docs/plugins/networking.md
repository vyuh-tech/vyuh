---
title: Networking
description: Make HTTP requests from any feature with vyuh.network, with timeouts, retries and web cookies built in.
---

# Networking

The network plugin is the app's shared HTTP client: every feature calls
`vyuh.network` instead of creating its own.

| | |
|---|---|
| Contract | `NetworkPlugin` (implements `Client` from [`package:http`](https://pub.dev/packages/http)) |
| Default implementation | `HttpNetworkPlugin` |
| Accessor | `vyuh.network` |
| `PluginDescriptor` slot | `network` |
| Implementations | `HttpNetworkPlugin`, or your own |

Because `NetworkPlugin` implements the standard `http` `Client`, you can pass
`vyuh.network` to any code or package that expects a `Client`.

## Set up

Every app gets an `HttpNetworkPlugin` with default settings. To change them,
fill the `network` slot:

```dart
import 'package:retry/retry.dart';
import 'package:vyuh_core/vyuh_core.dart';

void main() {
  runApp(
    plugins: PluginDescriptor(
      network: HttpNetworkPlugin(
        timeout: const Duration(seconds: 10),
        retryOptions: const RetryOptions(maxAttempts: 5),
      ),
    ),
    features: () => [/* ... */],
  );
}
```

`HttpNetworkPlugin` takes these optional arguments:

| Argument | Default | What it does |
|---|---|---|
| `timeout` | 30 seconds | How long each attempt may take before it fails with a `TimeoutException` |
| `retryOptions` | `RetryOptions(maxAttempts: 3, delayFactor: Duration(milliseconds: 200))` | How often and how quickly to retry, from the [`retry`](https://pub.dev/packages/retry) package |
| `client` | a new `Client` | Use this `http` `Client` instead of creating one |
| `webIncludeCredentials` | `true` | On the web, send cookies with cross-origin requests (see below). The source declares it as the private named parameter `this._webIncludeCredentials`; callers write `webIncludeCredentials:` |

::: warning HttpNetworkConfig is not used
`vyuh_core` also exports an `HttpNetworkConfig` class (with
`HttpNetworkConfig.standard`: 5 second timeout, 3 attempts, 10 second maximum
delay). `HttpNetworkPlugin` does not read it. Configure the plugin with the
constructor arguments above.
:::

### Cookies on the web

Web apps that sign in with HTTP-only session cookies need the browser to send
those cookies on cross-origin requests. When the app runs on the web and
`webIncludeCredentials` is `true` (the default), `HttpNetworkPlugin` creates a
`BrowserClient` with `withCredentials = true`. Your server must answer with
matching CORS headers (`Access-Control-Allow-Credentials: true` and an
explicit origin).

Turn it off if your API is public and must not receive cookies. On mobile and
desktop the setting has no effect.

## Use it

Call `vyuh.network` from a feature, usually inside a small service class:

```dart
import 'dart:convert';

import 'package:vyuh_core/vyuh_core.dart';

class OrdersApi {
  final _base = Uri.parse('https://api.example.com');

  Future<List<dynamic>> orders() async {
    final response = await vyuh.network.get(
      _base.resolve('/orders'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw StateError('Could not load orders (${response.statusCode})');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<void> placeOrder(Map<String, Object?> order) async {
    final response = await vyuh.network.post(
      _base.resolve('/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order),
    );

    if (response.statusCode >= 400) {
      throw StateError('Order failed (${response.statusCode})');
    }
  }
}
```

The available methods are the `http` `Client` ones: `get`, `head`, `post`,
`put`, `patch`, `delete`, `read`, `readBytes`, `send` and `close`. They return
the `http` types `Response`, `StreamedResponse`, `String` and `Uint8List`;
import `package:http/http.dart` when you need those types by name.

The plugin does not check status codes or decode bodies. A `404` or `500` is a
normal `Response`; deciding what it means is up to your service.

## Behaviour and lifecycle

- **Preloaded.** `NetworkPlugin` is a preloaded plugin, so it starts before the
  platform and every other plugin can use it in `init`.
- **Start-up.** `init()` creates the client: a `BrowserClient` with
  credentials on the web (when `webIncludeCredentials` is on), otherwise a
  standard `Client`. If you passed `client`, that one is used and nothing is
  created.
- **Shutdown.** `dispose()` closes the client. `close()` does the same, so
  don't call `vyuh.network.close()` from a feature: it closes the client for
  the whole app.
- **Timeouts and retries.** `get`, `head`, `post`, `put`, `patch` and `delete`
  each run with the timeout and are retried, but only for a `TimeoutException`
  or a socket error (a failure to reach the server). An HTTP error status is
  never retried. If every attempt fails, the last error is thrown.
- **No retries for the rest.** `read`, `readBytes` and `send` go straight to the
  client, with no timeout and no retries.
- **No auth headers.** The plugin adds no headers of its own. Add
  `Authorization` yourself, for example from `vyuh.auth.token`.

## Testing

Pass a mock `Client` to `HttpNetworkPlugin`. Here with
[mocktail](https://pub.dev/packages/mocktail):

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_test/vyuh_test.dart';

class MockClient extends Mock implements Client {}

void main() {
  late MockClient client;

  setUp(() {
    client = MockClient();
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  tearDown(() async {
    if (VyuhBinding.instance.initialized) await vyuh.dispose();
  });

  testWidgets('loads orders', (tester) async {
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => Response('[]', 200));

    runApp(
      plugins: PluginDescriptor(network: HttpNetworkPlugin(client: client)),
      features: () => [],
    );
    await vyuh.getReady(tester);

    expect(await OrdersApi().orders(), isEmpty);
  });
}
```

`MockClient` from `package:http/testing.dart` works just as well.

## Write your own

Extend `NetworkPlugin` to add behaviour every request should share, such as
an auth header or logging. `NetworkPlugin` declares `get`, `head`, `post`,
`put`, `delete` and `patch`; as a `Client` you also implement `read`,
`readBytes`, `send` and `close`, plus `init` and `dispose`.

The simplest approach wraps `HttpNetworkPlugin`'s client argument with your own
`http` `BaseClient`:

```dart
import 'package:http/http.dart';
import 'package:vyuh_core/vyuh_core.dart';

class AuthClient extends BaseClient {
  final _inner = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    final token = vyuh.auth.token;
    if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

final network = HttpNetworkPlugin(client: AuthClient());
```

This keeps the timeouts and retries. When you pass `client`, the web
`BrowserClient` is not created for you, so wrap a `BrowserClient` yourself on
the web if you need cookies. For a completely different transport, extend
`NetworkPlugin` directly. See [writing a plugin](/plugins/custom-plugins).

## API

- [NetworkPlugin](/api/vyuh-core#networkplugin)
- [HttpNetworkPlugin](/api/vyuh-core#httpnetworkplugin)
- [HttpNetworkConfig](/api/vyuh-core#httpnetworkconfig)
