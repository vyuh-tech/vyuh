---
name: vyuh
description: How to design and build with the Vyuh Flutter framework — features, plugins, lazy features, events, redirects, errors and theming — and how to keep changes to the framework itself consistent. Use when creating or changing a Vyuh app, feature, plugin or extension, when working anywhere in the vyuh monorepo, or when the user mentions FeatureDescriptor, PluginDescriptor, runApp, vyuh.router, EventHandler, FeatureRedirect, VyuhTheme or VyuhFailure.
---

# Vyuh

Vyuh builds large Flutter apps from independent **features** that share
**plugins**, composed by the **app**. Every decision follows from this split
of ownership.

| Layer | Owns | Never owns |
|---|---|---|
| **App** (`runApp`) | Which features and plugins exist, the theme, initial and home routes | Feature behaviour |
| **Feature** (`FeatureDescriptor`) | A product slice: routes, UI, state, event handlers, redirects, extension contributions | Shared infrastructure, other features' internals |
| **Plugin** (`PluginDescriptor`) | One shared capability behind a contract: DI, navigation, auth, network, storage, telemetry, analytics, events, env, flags, locale | Product behaviour |
| **Extension** (`ExtensionDescriptor` + `ExtensionBuilder`) | A registry many features contribute to, aggregated by one builder | — |

## Principles

1. **Features are portable.** A feature must work in any app that supplies
   its declared plugins and dependencies. It never imports another feature's
   internals. Features talk through public routes, events and shared plugin
   contracts.
2. **Declare, don't wire.** Features declare what they contribute
   (`routes`, `events`, `redirects`, `extensions`). The platform subscribes,
   orders, starts, stops and rolls back. If you are storing a subscription or
   calling the router's setup from a feature, use the declarative field instead.
3. **The platform owns lifecycle.** Order: preloaded plugins → plugins →
   feature hooks (events, redirects) → feature `init` in dependency order →
   extensions → routes → `SystemReadyEvent`. Dispose and restart reverse it:
   features stop first, while their plugins still exist. Preloaded plugins
   keep running across restarts; one that failed to start fails startup and
   is retried by Restart.
   Lazy features follow the same lifecycle when they activate, and roll back
   completely if activation fails.
4. **Reactive by events.** State changes that other features care about are
   typed `VyuhEvent`s. Handlers and redirect refreshes subscribe to them.
   Use MobX or Listenables inside a feature; use events between features.
   Sign-in and sign-out already emit `UserChangedEvent`: refresh redirects
   with `refreshOn: [UserChangedEvent]` instead of defining your own.
5. **Every failure has a way out.** Failures are `VyuhFailure`s, reported
   once (telemetry plus `RouteFailureEvent`) and shown in the app's theme with
   Try again, Back, Go home or Restart, whichever applies. Never a dead end,
   never raw stack traces in release builds.
6. **One theme, one set of strings.** `VyuhTheme` on
   `PlatformWidgetBuilder.theme` drives every framework screen, and
   `VyuhStrings` on `PlatformWidgetBuilder.strings` holds every user-facing
   word. Framework UI uses `Theme.of`/`VyuhThemeExtension.of` and
   `VyuhStrings.current`, never hardcoded `Colors.*` or literals.
7. **One way to reach plugins.** `vyuh.router`, `vyuh.auth`, `vyuh.storage`
   and so on in apps and features. `VyuhBinding.instance.*` has the same
   accessors, for code that must also run in widget mode (no `runApp`).
8. **The CMS is an add-on.** `vyuh_core` has no content types. Content items,
   layouts, `ContentPlugin`, `ContentProvider`, `CMSRoute` and the
   `vyuh.content` accessor live in `vyuh_extension_content`. Apps opt in with
   `PluginDescriptor(others: [DefaultContentPlugin(provider: ...)])` and
   `vyuh_feature_system`, which contributes `cmsFallbackRoute` (unmatched
   URL → CMS page). Never add a CMS concept to core.

## Recipes

### A feature

```dart
final feature = FeatureDescriptor(
  name: 'orders',                 // unique, stable, used by dependencies
  title: 'Orders',
  dependencies: ['account'],      // init ordering only, not imports
  init: () async { /* feature-owned setup, plugins are ready */ },
  dispose: () async { /* release what init created; plugins still exist */ },
  routes: () => [GoRoute(path: '/orders', builder: (_, _) => const OrdersPage())],
  events: [
    EventHandler<UserSignedOutEvent>((_) => orderCache.clear()),
  ],
  redirects: [
    FeatureRedirect(
      name: 'orders-need-sign-in',
      refreshOn: [UserSignedOutEvent],
      redirect: (_, state) =>
          !session.signedIn && state.matchedLocation.startsWith('/orders')
              ? '/login'
              : null,
    ),
  ],
);
```

### A lazy feature

```dart
import 'package:feature_orders/feature_orders.dart' deferred as orders;

LazyFeatureDescriptor(
  name: 'orders',                 // must equal the loaded descriptor's name
  title: 'Orders',
  routePrefixes: ['/orders'],
  loader: () async { await orders.loadLibrary(); return orders.feature; },
)
```

### An app

```dart
void main() => runApp(
  initialLocation: '/',
  homeLocation: '/',
  plugins: PluginDescriptor(auth: MyAuthPlugin(), others: [MyFlagsPlugin()]),
  platformWidgetBuilder: PlatformWidgetBuilder.system.copyWith(
    theme: VyuhTheme(light: MyDesign.light, dark: MyDesign.dark),
  ),
  features: () => [system.feature, account.feature, catalog.feature],
  lazyFeatures: () => [ordersLazy],
);
```

### A custom event

```dart
final class UserSignedOutEvent extends VyuhEvent<void> {
  UserSignedOutEvent() : super(name: 'com.example.account.signedOut');
}
vyuh.event.emit(UserSignedOutEvent()); // delivered asynchronously
```

### A custom plugin

Extend `Plugin` (mix in `InitOncePlugin` for safe concurrent init and
re-init), expose it through a named extension on `VyuhPlatform`, and pass it
in `PluginDescriptor(others: [...])`. System plugin types go in their named
slot, never in `others`.

### A catch-all route

A feature may contribute one `GoRoute(path: NavigationPlugin.catchAllPath)`.
The router always places it last; without one, unmatched locations show the
not-found `RouteFailureView`.

### A route that cannot be shown

Return `RouteFailureView(failure: VyuhFailure(kind: ..., title: ..., location: state.uri))`.
For other failures call `reportFailure(failure)` where it happens, never in
`build`.

## Rules for framework changes (vyuh monorepo)

- Public API changes are additive by default. Don't add parameters to the
  `PlatformWidgetBuilder` builder typedefs; expose extra context through an
  `InheritedWidget` scope (as `VyuhFailureScope` does).
- Anything a feature declares must be torn down by the platform on dispose,
  restart and lazy rollback. Add a test for each path
  (`packages/system/vyuh_core/test/feature_hooks_test.dart` shows how).
- Emitting a lifecycle event must never throw or mask the original error.
- No `Colors.*`, hardcoded font sizes or raw exception text in framework UI.
- Report each failure once, at the point of failure.
- Futures and streams are created in `initState`/`didUpdateWidget`, never in
  `build`.
- After changing a public API: run `flutter analyze` at the repo root, run the
  tests of every touched package (CI doesn't cover all of them), update the
  guide in `docs/`, and run `bun run --filter vyuh-docs docs:api` and
  `bun run docs:build`.
- Mark commits that change public behaviour as breaking (`feat!:` or a
  `BREAKING CHANGE:` footer). `melos version` derives every package's bump
  from the commits; never edit versions by hand.

## Anti-patterns

| Instead of | Do |
|---|---|
| `vyuh.event.on(...)` inside `init` | `events: [EventHandler<T>(...)]` |
| A global `redirect` that knows every feature | Each feature's `redirects` |
| Feature A importing feature B's widgets or stores | Public routes and events |
| `vyuh.di.register` in `init` with no cleanup | Register in `init`, unregister in `dispose` |
| `routes: () => []` on a feature with no routes | Leave `routes` out |
| Static `DefaultNavigationPlugin.setRouterRedirect` | `DefaultNavigationPlugin(redirect: ..., urlStyle: ...)` |
| Hardcoded English in framework UI | A field on `VyuhStrings` |
| A custom `appBuilder` just to set the theme | `PlatformWidgetBuilder.theme` |
| Error UI with no exits | `RouteFailureView` / the default views |
| Restart as a fix for a failed route | Retry only the failed operation, or Go home |

## Where things live

- Core runtime: `packages/system/vyuh_core/lib/` (`runtime/` for the platform,
  failures and theme; `plugin/` for contracts; `feature_hooks.dart`)
- CMS add-on (content model, content plugin/provider contracts, `CMSRoute`,
  `cmsFallbackRoute`, `vyuh.content`): `packages/system/vyuh_extension_content`
- Built-in content types, actions, `ThemeService` and the CMS catch-all
  route: `packages/system/vyuh_feature_system`
- Docs site (VitePress): `docs/`. Guides are in `docs/guides/`, concepts in
  `docs/concepts/`
- Review notes: `audits/`
