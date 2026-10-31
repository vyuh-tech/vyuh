# Vyuh Framework Review — 2026-10-31

Scope: `vyuh_core`, `vyuh_extension_content`, `vyuh_feature_system`,
`vyuh_content_widget`, `vyuh_cache`, system features (auth, onboarding,
developer), `vyuh_cli`, examples, `apps/vyuh_demo`, CI and schemas.
Focus: whether features, plugins and routes fit together as one system for
large apps; error and theming handling; performance.

---

## 1. Verdict

The base design holds up. Features own behaviour (routes, init/dispose,
extensions). Plugins own shared capabilities (DI, content, nav, auth,
telemetry, storage, …). The app composes the two. Lazy features with
`deferred as` imports, transactional rollback, dependency ordering and
lifecycle generations are well built.

Nothing is fundamentally broken. But four things stop it feeling cohesive at
scale:

1. **Errors have no exit.** Route and content failures show error views with
   no Back or Home. The only escape hatch ("Restart"/"Retry") tears down the
   whole app tree.
2. **Theming is not a framework concept.** Core hardcodes
   `ThemeData.light()`, black/white loaders and red debug widgets. The
   splash/error `MaterialApp` has no theme at all. `ThemeService` lives in
   an optional feature.
3. **There's a refetch bug at the heart of CMS routes.** `DocumentBuilder`
   passes a new closure on every build, so every parent rebuild re-fetches
   the route, resets its DI scope and re-runs `route.init`.
4. **Features can't contribute cross-cutting things.** Route guards
   (redirect is a single static), app-level hooks ("on ready"), themes,
   observers, or their own extension builders when lazy.

---

## 2. What's good

- **Clear split between features and plugins.** System plugins use named
  slots; `others` holds custom ones. `PluginDescriptor.get<T>` is cached
  (`plugin_descriptor.dart:132`).
- **`InitOncePlugin`.** Concurrent init is shared, init can be retried after
  a failure, and dispose waits for init (`plugin.dart:33`).
- **Feature dependency graph.** Eager features are topologically sorted with
  cycle detection, and init waits on dependencies
  (`default_platform.dart:172-190, 391`).
- **Lazy features are solid:**
  - placeholder routes for each prefix
  - concurrent loads are de-duplicated
  - lazy→lazy dependencies load first
  - feature-flag gating
  - generation-based cancellation on restart
  - full rollback of extension registries and routes on failure
  (`lazy_feature_manager.dart`, `default_platform.dart:320`)
- **One place to override all UI.** `PlatformWidgetBuilder` covers app,
  loaders, error, unknown content and image placeholders, and has
  `copyWith`.
- **Content registry.** O(1) map lookups by schemaType, typed failures
  (`ContentItemFailure`, `LayoutFailure`, `ModifierFailure`, …), and unknown
  types degrade gracefully into placeholders.
- **Telemetry traces** wrap plugin, feature, extension and route init.
- **`vyuh_cache`.** In-flight coalescing, TTL, invalidation generations,
  optional LRU.
- **Widget mode** (`VyuhContentBinding` + `VyuhContentWidget`) lets you embed
  Vyuh content in a non-Vyuh app.

---

## 3. How it fits together today

```
runApp(features, lazyFeatures, plugins, platformWidgetBuilder)
 └─ VyuhBinding._appInit         → PreloadedPlugin.init (event bus, …)
 └─ _FrameworkInitView           → tracker.init()
     ├─ initPlugins              → dispose all, then init all concurrently (no plugin deps)
     ├─ initFeatures
     │   ├─ features()  + lazyFeatures() → unique-name check, topo sort
     │   ├─ _initFeatureExtensions        → one ExtensionBuilder per descriptor type,
     │   │                                  init sequentially (BEFORE feature.init)
     │   ├─ feature.init → feature.routes (run once per lifecycle)
     │   └─ router.initRouter(routes + lazy placeholders + fallback "/:path(.*)")
     └─ ready → appBuilder(context, vyuh)
```

How routes resolve:
- **Local routes** are plain `GoRoute`s from features.
- **`CMSRoute`** is a GoRoute whose page is
  `vyuh.content.buildRoute(url)`.
- **Anything else** hits the fallback route, which also asks the CMS for
  that path. So a URL that matches nothing becomes a CMS fetch.
- **A lazy prefix** hits a placeholder page. That page loads the feature,
  calls `replaceRoutes`, then calls `router.go(target)`.

---

## 4. Conceptual gaps for large apps

### 4.1 Features
| Gap | Where | Impact |
|---|---|---|
| A lazy feature's `extensionBuilders` are ignored; only descriptors for builders that already exist are registered | `default_platform.dart:336-351` | A lazy feature cannot introduce a new extension *kind* |
| Extension builders init **before** `feature.init`, sequentially | `default_platform.dart:192-197` | A feature can't prepare state its extensions need; extra startup latency |
| No app-level hooks (`onReady`, `onRouteError`, `onRestart`) | demo `root_feature.dart` works around this with `event.once(SystemReadyEvent)` | Boilerplate "root features" |
| Lazy `name`/`routePrefixes` duplicated by hand between the app and the feature | `apps/vyuh_demo/lib/main.dart:48-65` | Drift; only checked after load |
| Feature list duplicated across vyuh_demo, content_explorer and Studio config | | No single feature manifest |
| No per-feature DI scope; everything goes into global GetIt, and examples never unregister in `dispose` | `examples/tmdb/feature_tmdb/lib/feature.dart:33` | Leaks across restarts/lazy reloads; name collisions between teams |
| Duplicate registration policy is inconsistent: builders throw, but layouts/actions/conditions/modifiers warn and overwrite, and the lazy path silently skips | `content_extension_builder.dart:114-121, 209, 232` | Two teams can hijack each other's schema types without noticing |
| Schema type strings are copied by hand between TS schemas and Dart | e.g. `'auth.emailPasswordForm'` | No contract check |

### 4.2 Plugins
- **No dependency graph between plugins.** All non-preloaded plugins init
  concurrently. A plugin that needs another (auth → network, content → env)
  has to wait for it by hand.
- **Default plugin instances are shared.** `PluginDescriptor` defaults
  (`system.get<…>()`) are the same static instances for every descriptor, so
  tests and widget mode share state.
- **`dispose()` is called on every plugin before `init()`,** including at
  first launch (`default_platform.dart:110`). Plugins must tolerate dispose
  before init.
- **Routing hooks are global.** `NavigationPlugin` has a single static
  `_redirect` (`default_navigation_plugin.dart:12`). Features can't
  contribute guards (auth, flags, onboarding), and there's no ordered guard
  chain.
- **`runApp` is `void … async`.** Errors thrown before `_appRunner` are
  unhandled.

### 4.3 Routes
- **`router.go(target)` after a lazy load replaces the stack**
  (`lazy_feature_manager.dart:255`). If the user *pushed* into a lazy
  feature, Back no longer works. Rebuild the current match after
  `replaceRoutes` instead (for example `router.refresh()`), or use
  `pushReplacement` when the placeholder was pushed.
- **Placeholder removal only matches top-level `GoRoute.path`**
  (`default_platform.dart:355-358`). A lazy feature whose routes sit under a
  `ShellRoute`/`StatefulShellRoute` leaves the placeholder behind.
- **`state.extra as RouteBase?`** (`cms_route.dart:49`) crashes if anything
  else is passed as `extra`. `extra` is also lost on web refresh.
- **Route lifecycle `dispose()` is never called.** `Route.dispose` exists
  (`vyuh_feature_system/lib/content/route/route.dart:110`) but nothing in the
  runtime invokes it, so `RouteLifecycleConfiguration.dispose` never runs.
- **`ConditionalRoute` caches its first result forever.** Auth or flag
  changes don't re-route.
- **`fetchRoute(path: url?.path)` drops query parameters.**
- **The static path ignores `includeDrafts`.** It's hardwired to
  `kDebugMode` in the content plugin.

---

## 5. Errors: what happens today and what's needed

### Today
| Situation | Widget shown | Exit |
|---|---|---|
| App init fails (`framework_init_view.dart:33`) | `routeErrorView` inside an **unthemed** `MaterialApp` | "Restart" only, no retry |
| GoRouter error (`default_navigation_plugin.dart:80`) | `routeErrorView` | "Retry" = `tracker.init(currentState)`; see bug below |
| CMS route fetch fails / null document | `errorView`, a bare `Center` card with no Scaffold | **None**: stuck unless the route has chrome |
| Lazy feature fails / disabled | `routeErrorView` | Retry; no Home |
| Widget throws in build (anywhere) | Flutter's default `ErrorWidget` | None; also **not reported to telemetry** |
| Content/layout failure | `unknown` (hardcoded red) | n/a |

Bugs in this area:
- **Router error "Retry" doesn't reload the failing route.** It calls
  `tracker.init(InitState.ready)`. The init loop does nothing, but the loader
  future goes pending → fulfilled. `_FrameworkInitView`'s `AnimatedSwitcher`
  then swaps the app for the splash and back, **throwing away the whole
  navigator and all app state**. "Restart" does the same on purpose.
- **Error hooks are never installed.** Nothing sets `FlutterError.onError`,
  `PlatformDispatcher.instance.onError` or `ErrorWidget.builder`, so
  `TelemetryPlugin.reportFlutterError` is never called by the framework.
- **Stack traces show in release builds** (`error_view.dart`).
- **Text color on the error background is wrong.** `_ErrorViewScaffold` uses
  `onSurface` on top of an `errorContainer` background; it should be
  `onErrorContainer`.
- **`errorView` ignores `showRestart`.**
- **Errors are reported from `build()`** (`document_future_builder.dart:85,
  103`), so each rebuild in the error state reports the same error again.
- **The layout/modifier try/catch** (`content_plugin.dart:79-95`) only
  catches errors thrown synchronously in that frame, not in child widgets.
  It also drops the stack trace and doesn't report to telemetry.

### Proposed design
1. **A `VyuhFailure` model.** Kind (`network`, `notFound`, `contentType`,
   `featureDisabled`, `featureLoad`, `init`, `unexpected`), plus title,
   message, error, stack and `isRecoverable`. Map exceptions to failures in
   one place.
2. **A recovery contract on every error view.** Add
   `List<FailureAction> actions` (or named `onRetry`, `onBack`, `onHome`,
   `onRestart`) to both builder typedefs. The framework supplies sensible
   defaults:
   - **Back** when `router.canPop()`
   - **Home** = `router.go(homeLocation)`
   - **Retry** = re-run *only* the failing operation (route fetch, lazy load,
     init stage)
   - **Restart** only for init failures
3. **A configurable home location.** Add `runApp(homeLocation: '/')`, or
   `NavigationPlugin.homeLocation`, defaulting to `initialLocation`. If the
   home route itself fails, Home becomes Restart.
4. **Route-level failures always use a page-level view** with
   AppBar/back/home. Content-level failures stay inline cards.
5. **An `ErrorBoundary` widget** around each route page and content item. It
   catches descendant build errors through a scoped `ErrorWidget.builder`
   override, reports once to telemetry, and renders `unknown`/`errorView`.
6. **Global hooks installed in `run()`.**
   - `FlutterError.onError` and `PlatformDispatcher.instance.onError` →
     `telemetry`
   - `ErrorWidget.builder` → themed fallback
7. **Debug details only behind `kDebugMode`.** Error text and stack go into a
   collapsible "Details" panel.
8. **Localizable strings.** Move every literal ("Failed to load route",
   "Retry", "Restart", …) into a `VyuhStrings` object on
   `PlatformWidgetBuilder` (or the i18n plugin).

---

## 6. Theming: proposal

The core package already depends on `material_ui`, so the framework itself
can own a theme contract.

1. **`VyuhTheme`.** Light and dark `ThemeData`, `themeMode`, plus a
   `VyuhThemeExtension` (`ThemeExtension`) for framework surfaces: loader
   background and progress colors, error/warning/info surfaces, debug-overlay
   colors, image placeholder, spacing and radius.
2. **Pass it in.** Add `PlatformWidgetBuilder.theme` (or
   `runApp(theme: …)`) so the **splash/error `MaterialApp` uses the same
   theme** as the real app, and the default `appBuilder` wires `theme`,
   `darkTheme`, `themeMode` and localization delegates. That removes the
   demo's custom `appBuilder`.
3. **Move `ThemeService` into core** (or make it a `ThemePlugin`):
   - make the theme map observable
   - persist the mode through `StoragePlugin`
   - remove the `WidgetsBindingObserver` on dispose (it leaks today)
   - fix `theme(ThemeMode.system)` returning null in `ThemeModifier`
4. **Replace every hardcoded `Colors.*`.** In core these are the loaders,
   image placeholder, `unknown_content_view`, the fallback route banner and
   `PoweredByWidget`; in content they're `unknown_content_indicator` and the
   dialog barrier. Read from `colorScheme` and the extension instead, so dark
   mode works.
5. **Default loaders:**
   - remove the `BackdropFilter` blur (expensive, especially on web and
     low-end Android)
   - give route/content loaders a short delay (~150–300 ms) to avoid flashes
   - make "Powered by Vyuh" opt-out; today it's in every content loader
6. **Make `DesignSystem.lightTheme`/`darkTheme` cached `static final`s**
   (examples). They currently rebuild `ThemeData` on every access.

---

## 7. Performance, ranked

| # | Issue | Location | Fix |
|---|---|---|---|
| 1 | **CMS route refetches on every parent rebuild.** A new `future:` closure each build makes `didUpdateWidget` always refetch, reset the DI scope and re-run `route.init`. The live path re-subscribes the same way. | `document_builder.dart:195, 94, 157`; `document_future_builder.dart:49`; `document_builder.dart:260` | Make `DocumentBuilder`/`RouteBuilder` stateful and key the request by `(url, routeId, isLive)`; compare identities, not closures |
| 2 | **Futures created in `build()`.** Refetch and loader flash on rebuild; `APIContent` makes a network call per rebuild. | `conditional.dart:189`, `conditional_layout.dart:50`, `conditional_route/default_layout.dart:35`, `api_content.dart:120` | Hold the future in State; invalidate on input change |
| 3 | **Router error Retry/Restart remounts the whole app.** | `framework_init_view.dart`, `default_navigation_plugin.dart:86` | Keep the app mounted during restart (overlay a loader); retry only the failing route |
| 4 | **JSON is re-parsed on every cache hit** (raw Sanity responses are cached); JsonPath is recompiled per field and decoded on the main isolate. | sanity provider, `json_path_api_configuration.dart:112,141` | Cache parsed `ContentItem`s per query; `compute()` for big payloads; precompile JsonPath |
| 5 | **The Observer scope wraps the whole route content,** so any observable read in a layout rebuilds the full page. | `document_future_builder.dart:69-99` | Observe only the status; build content outside the Observer |
| 6 | **Non-virtualized lists:** `shrinkWrap` grids, ListView-in-ListView, eager carousel, nested `primary: true` scroll views. | `grid_layout.dart:39,56`, list layout, `carousel.dart:44` | Slivers + builders; one primary scroll per route |
| 7 | **Tabs re-fetch each switch** (no keep-alive) and nest Scaffolds. | `route/tabs.dart:56-64` | `AutomaticKeepAliveClientMixin`; one Scaffold |
| 8 | **Image decode size uses logical pixels** and `dpr.toInt()` (blurry on 2.6x/3x); the placeholder is unsized, so layout shifts. | `content_image.dart:71,105-128` | `(w * dpr).round()`; sized placeholder |
| 9 | **About 125 ms added before every tap action** by `PressEffect`; no semantics or focus. | `press_effect.dart:41-53` | Fire the action on tap-up and animate in parallel; add `Semantics`/`FocusableActionDetector` |
| 10 | **Refresh FAB and its Stack wrapper on every route in release** (`allowRouteRefresh` defaults to true). | `content_plugin.dart:23`, `route_builder_proxy.dart:36` | Default to `kDebugMode` |
| 11 | **Loader `BackdropFilter` blur** on every route load. | `default_route_loader.dart:43` | Remove, or make it opt-in |
| 12 | **Startup is serialized:** extension builders init one at a time and before features. | `default_platform.dart:306` | Init in parallel where independent; measure with existing traces |
| 13 | **Leaks:** unbounded memory cache by default, undisposed `Carousel` PageController, `ThemeService` observer, global DI registrations without unregister. | various | Bounded LRU default; dispose everything |
| 14 | **Lazy activation rebuilds the full `RoutingConfig`** (O(routes) each time). | `default_platform.dart:353-361` | Fine for now; batch if many lazy features load together |

---

## 8. Bugs to fix (verified or high-confidence)

- **`DrawerAction` "close" opens the drawer.** Both branches call
  `open*Drawer` (`action/drawer.dart:69-75`).
- **`OpenUrlAction` crashes on a null URL.** It logs, then still does
  `url!` (`action/open_url.dart:91-95`).
- **`DocumentListViewBuilder` treats a rejected future as success.** It
  checks `snapshot.result == FutureStatus.rejected` (should be `.status`), so
  a rejected future falls through to `snapshot.result!`
  (`document_listview_builder.dart:40-53`).
- **`VideoPlayer` dispose can throw.** `late final _controller` is never
  set when there's no URL, so `dispose` throws.
- **`ShowAlertAction` buttons don't close the dialog.**
- **`NavigateBack` mixes routers.** It checks go_router's `canPop`, then
  calls `Navigator.pop`.
- **`ConditionalAction` misses arguments and errors.** It doesn't await the
  nested action and doesn't forward `arguments`.
- **`DocumentDefaultLayout` cast.** It casts `content.layout as
  DocumentDefaultLayout?`, a TypeError for other layouts.
- **Unknown-layout detection breaks under obfuscation.** It relies on
  `type.toString().startsWith(...)` (`unknown_placeholder_factory.dart:43`).
- **False "Overriding" warning for every builder at startup**
  (`content_extension_builder.dart:60` vs `:136`).
- **`LinkedRoute.identifier` is unstable.** It's a new `nanoid()` per
  deserialization, so it can't be used as a key.
- **Route lifecycle `dispose()` is never invoked** (see 4.3).

---

## 9. Tooling and DX

- **CI coverage:**
  - tests run for 7 packages
  - `vyuh_extension_content`, `vyuh_content_widget`, `vyuh_feature_auth` and
    `vyuh_cli` tests aren't in the matrix
  - no example or app analysis
  - no check that generated `.g.dart` files are up to date
- **`vyuh_test` is minimal.** Add:
  - `VyuhTestHarness` (boot a single feature with fake plugins)
  - fake content/auth/env/storage plugins
  - route and failure assertions
- **CLI:**
  - `create feature` doesn't wire into the app, workspace or Studio
  - the two bundle scripts each miss bricks
  - the feature brick has an empty test and stale lints
  - the item brick freezes a `.g.dart`
- **Codegen.** A hand-maintained `gen-*` recipe for each package, one of
  which points at a path that doesn't exist (`gen-tmdb_client`). Recipes need
  the fish shell. Add one `gen-all` that runs build_runner per workspace
  member.
- **Lints.** No shared strict lint set. Consider custom lints for:
  - register-in-init / unregister-in-dispose
  - unique schemaType
  - no `Colors.*` in framework UI
- **Versioning.** About 20 independently versioned Dart packages plus npm
  schemas, with no compatibility matrix or "BOM" package.
- **Secrets.** A Sanity read token is hardcoded in
  `apps/vyuh_demo/lib/main.dart` and `apps/content_widget_demo/lib/main.dart`,
  and `.env` is bundled as a Flutter asset in web builds.
- **Schema contract.** Generate Dart schemaType constants from the TS
  schemas (or the reverse), or add a contract test.

---

## 10. Suggested order of work

1. **Stability and performance (small, high value).**
   - Fix the DocumentBuilder refetch (#1)
   - Fix futures in `build()` (#2)
   - Stop the Retry/Restart remount (#3)
   - Fix the bugs in §8
   - Add the missing packages to the CI test matrix
2. **Error system.** `VyuhFailure`, recovery actions (Back / Home / Retry /
   Restart), `homeLocation`, route-level error page, `ErrorBoundary`,
   global error hooks → telemetry, release-safe details, `VyuhStrings`.
3. **Theme system.** `VyuhTheme` + `VyuhThemeExtension`, themed splash/error
   app, default `appBuilder` wires theme and localization, `ThemeService`
   into core with persistence, remove hardcoded colors and blur.
4. **Composition for scale.**
   - Feature-contributed route guards (ordered redirect chain)
   - App lifecycle hooks
   - Lazy features may bring their own extension builders
   - Per-feature DI scopes with automatic teardown
   - One strict duplicate-registration policy that names the source feature
5. **DX.** Test harness, CLI wiring, `gen-all`, codegen CI check, shared
   lints, schema-type contract, compatibility matrix.

---

# Part 2: Cohesive model, what changed, and API ergonomics

## The model, in one table

| Layer | Owns | Declares through |
|---|---|---|
| App | Which features and plugins exist, theme, initial and home routes | `runApp(features, lazyFeatures, plugins, platformWidgetBuilder, homeLocation)` |
| Feature | A product slice | `FeatureDescriptor(routes, init, dispose, dependencies, events, redirects, extensions)` |
| Plugin | One shared capability behind a contract | `PluginDescriptor(...)` |
| Extension | A registry many features contribute to | `ExtensionDescriptor` + one `ExtensionBuilder` |

The platform owns lifecycle. A feature *declares*; the platform subscribes,
orders, starts, stops and rolls back. Lazy features get exactly the same
treatment when they activate. Features talk through public routes, typed
events and plugin contracts. Every failure is a `VyuhFailure`, reported once
and shown with a way out. One `VyuhTheme` drives every framework screen.

The same model is written for agents in `.claude/skills/vyuh/SKILL.md`.

## Done in this pass

- **Lifecycle events.** `SystemEvent` base, plus `SystemInitStartedEvent`,
  `FeatureLoadedEvent`, `FeatureLoadFailedEvent`, `SystemInitFailedEvent`
  and `RouteFailureEvent`, next to the existing `SystemReadyEvent`. Emitting is
  safe: it never masks the original error, and a cancelled lazy load emits
  nothing.
- **Declarative feature hooks.**
  - `FeatureDescriptor.events` takes `EventHandler<T>` listeners. They're
    subscribed before `init` and cancelled on dispose, restart and lazy
    rollback.
  - `FeatureDescriptor.redirects` takes `FeatureRedirect`s. They compose after
    the global redirect, in feature order, and re-run on `refreshOn` events or
    a `listenable`.
  - A throwing redirect is reported to telemetry and skipped.
- **Failure model.** `VyuhFailure` / `FailureKind`, `reportFailure`,
  `RouteFailureView`, `VyuhFailureScope` and `FailureActions`, with
  `FailurePage` / `FailureCard` as the defaults:
  - Back only when there is history.
  - Go home unless the failure is on the home route.
  - Restart only when nothing else can help.
  - Try again re-runs just the failed operation. A router error no longer
    restarts the whole app.
  - Details are debug-only.
- **Home.** `runApp(homeLocation:)`, `vyuh.router.homeLocation` and
  `vyuh.router.goHome()`.
- **Global errors.** `runApp(captureErrors: true)` sends `FlutterError` and
  platform errors to telemetry, keeping existing handlers, and shows a themed
  placeholder for failed builds in release. It's skipped under `flutter test`.
- **CMS routes.** A failed or missing CMS page is a full failure page with
  Back and Go home (it used to be a bare card). Route loading uses
  `routeLoader`. Errors are reported once, never from `build`.
- **Theme.**
  - `VyuhTheme` (light, dark, mode, `fromSeed`) on
    `PlatformWidgetBuilder.theme`. The startup screen, startup failure,
    default root, loaders, failure views and placeholders all use it.
  - A `VyuhThemeExtension` token set, with fallbacks from `ColorScheme`.
  - Every hardcoded `Colors.*` is gone from core and the content
    indicators.
  - The loader blur is removed; loaders appear after `loaderDelay`.
  - "Powered by" is opt-out.
- **`ThemeService`.**
  - It's seeded from `VyuhTheme`, so there's one source of truth.
  - The theme map is observable.
  - System mode resolves correctly, including in `ThemeModifier`.
  - The brightness listener is removed on dispose.
- **Docs.**
  - The site moved into `docs/`, flattened (old `/docs/*` URLs redirect),
    upgraded to the newest releases, and deploys from `deploy_web.yml`.
  - New guides: Theming, Errors and recovery.
  - Updated: Events (it wrongly called delivery synchronous), Routes (feature
    redirects), Lifecycle, Feature descriptors, Platform customization.
  - The API reference was regenerated with `pnpm docs:api`.

## API ergonomics: gaps that remain

Ordered by how much they hurt day to day. **S** means a small fix, safe to do
now. **M** means a design decision first.

| # | Gap | Size |
|---|---|---|
| 1 | **Two ways to reach plugins.** `vyuh.router` (`NamedPlugins`) and `VyuhBinding.instance.content` (`NamedBindings`, which lacks `auth`, `router` and `locale`). Content packages use the second. Converge on `vyuh.*`. | S |
| 2 | **`routes` is required** even for features with none (`routes: () => []`). Make it optional with an empty default. Non-breaking. | S |
| 3 | **Restart order.** Plugins (DI included) re-initialize before the previous features are disposed, so a feature's `dispose` can't find its DI registrations. Dispose features and extensions first, then re-init plugins. | S |
| 4 | **Global static router config.** `DefaultNavigationPlugin.setRouterRedirect` / `usePathStrategy` are statics shared by every instance. Make them constructor parameters; the redirect already is one. | S |
| 5 | **Lazy descriptors repeat the feature.** The app re-types `name`, `title` and `routePrefixes`. Let the feature package export its own lazy descriptor (prefixes next to the routes), so the app writes `orders.lazy`. | M |
| 6 | **Features can't contribute app-root things:** localization delegates, `ThemeExtension`s, navigator observers (plugins only), shell layouts. Add `FeatureDescriptor.localizations` / `themeExtensions`, merged into the default root. | M |
| 7 | **No per-feature DI scope.** Features register into one global GetIt and rarely clean up. A scope per feature, disposed with it, would remove a whole class of leaks and name collisions. | M |
| 8 | **Strings aren't localizable.** Failure titles, "Try again", "Go home" and "Restart app" are English literals. Add a `VyuhStrings` on `PlatformWidgetBuilder` (or source them from `LocalePlugin`). | S |
| 9 | **`refreshOn` matches exact types.** Subtypes don't trigger. Fine for now; add a predicate form if feature event hierarchies appear. | S |
| 10 | **Builder typedefs are loosely typed** (`dynamic error`, positional `[Uri?, String?]` on `RouteLoader`). Clean up at the next major version; until then the scope pattern covers new context. | M |
| 11 | **No plugin dependency graph.** Non-preloaded plugins init concurrently; a plugin needing another waits by hand. Add `Plugin.dependsOn` and order like features. | M |
| 12 | **Naming conventions vary:** `feature` vs `feature()`, `'vyuh_feature_onboarding'` vs `'auth'`. Pick one and lint it. | S |
| 13 | **CMS route refetch on rebuild** (part 1, §7 #1). A new closure each build triggers a refetch. It also re-reports a failure when the parent rebuilds. | S |

## On a feature DSL

**Not recommended.**
- Dart has no real DSL support, so a fluent builder (`feature('orders').route(...).on<E>(...)`)
  would be a second way to write what named parameters already say clearly.
  It would split docs, examples and tooling.
- What makes setup feel heavy today is repetition (gap 5), required noise
  (gap 2), and app-root things features can't declare (gap 6).
- Fixing those keeps one obvious way to write a feature.
- If more help is wanted, the better lever is the CLI: `vyuh create feature`
  should also wire the feature into the app, workspace and docs.

---

# Part 3: Safe API fixes, Bun, and the release plan

## Fixed

| Gap | Before | After |
|---|---|---|
| Routes required | `routes: () => []` on every route-less feature | `routes` is optional |
| Restart order | Plugins (DI included) reset, *then* old features were disposed | Features stop first, while their services exist. A throwing `dispose` is reported and the rest still stop |
| Global router config | `DefaultNavigationPlugin.setRouterRedirect(...)`, `usePathStrategy()` statics | `DefaultNavigationPlugin(redirect: ..., urlStyle: RouterUrlStyle.path)`. The static is deprecated, not removed |
| Two accessor sets | `VyuhBinding.instance` lacked `auth`, `router` and `locale`; neither set had `storage`/`secureStorage` | Both have the same set, including `storage` and `secureStorage` |
| English-only UI | Literals in the views | `PlatformWidgetBuilder.strings` takes a `VyuhStrings`, used by every framework view and failure |
| CMS refetch on rebuild | A new closure each build triggered a refetch and DI reset | `requestKey` decides when to refetch. `fromRoute`, `fromQuery` and `fromId` set it automatically |

**Left as is (not worth the churn now):**
- `refreshOn` matches exact types.
- Inconsistent feature names (`feature` vs `feature()`, `'vyuh_feature_onboarding'`). Renaming them would break apps that depend on them.

## Bun

- **What changed.**
  - The JavaScript workspace uses Bun: root `workspaces`, `overrides`, `trustedDependencies` and a `bun.lock`.
  - `pnpm-workspace.yaml`, `.npmrc` and all seven pnpm lockfiles are gone.
  - Node still runs VitePress, the Sanity Studio and Wrangler.
- **Checked.** The docs, both schema packages and the demo Studio build under Bun, and `bun install --frozen-lockfile` passes.
- **Deploys.**
  - `deploy_web.yml` deploys the demo app and now uses Bun.
  - The new `deploy_docs.yml` publishes docs.vyuh.tech on every push to `main` that touches `docs/`.
- **Not changed.** The CLI's project and schema templates still generate pnpm workspaces for users. That's a separate product decision.

## Release plan

Default behaviour changed:
- The default theme is now Material 3 light and dark.
- The error views are new.
- Lazy loading now shows the route loader.
- `VyuhBinding` gains accessors that could clash with app extensions.

So this ships as a **major** release of `vyuh_core`, `vyuh_extension_content` and `vyuh_feature_system`.

`melos version` derives bumps from conventional commits, so mark the commits breaking (`feat!:` or a `BREAKING CHANGE:` footer) and let melos:
- bump those three packages to their next major
- raise the `vyuh_core` constraint and bump every dependent package (feature packages, plugins, widgetbook, the CLI templates)

Don't edit versions by hand.

**Breaking-change notes for the release:**
- The default app root uses `VyuhTheme.system` (Material 3, light and dark, following the OS) instead of `ThemeData.light()`. Pass `theme:` to keep a fixed look.
- The default `routeErrorView` and `errorView` are `FailurePage` and `FailureCard`. Error details show only in debug builds. `errorView`'s `showRestart` now defaults to `false`.
- A route-level CMS failure renders a full page with `routeErrorView` instead of an inline `errorView`.
- Failure titles changed (for example "The app could not start"). All are configurable through `VyuhStrings`.
- `runApp` installs global error handlers (`captureErrors: true`). Pass `false` if the app installs its own.
- `DefaultNavigationPlugin.setRouterRedirect` is deprecated.

