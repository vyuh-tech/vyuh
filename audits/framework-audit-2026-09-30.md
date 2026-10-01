# Framework and documentation audit — 30 September 2026

The framework is presented as three layers: app-selected plugin capabilities, portable Flutter features, and apps composed from those features. Managed content is an optional integration category.

This audit inventories the public surface of all 18 Dart packages and the local TypeScript schema packages. Static analysis covers the system, Sanity, plugin, and CLI libraries. Detailed runtime review and regression tests focus on lifecycle, dependency ordering, lazy activation, caching, provider policy, action sequencing, and timing accuracy. This is not a claim that every behavior or target platform has been exhaustively tested.

## Implemented corrections

| Area | Failure or inconsistency | Change and evidence |
| --- | --- | --- |
| Plugin lifecycle | InitOncePlugin ran cleanup before initialization and skipped cleanup after initialization | Share initialization/disposal futures, await pending setup, clean up once, and allow a new lifecycle. Four regression tests cover ordering, concurrency, and retry. |
| Storage lifecycle | Hive and secure-storage late-final adapters could not be assigned during a second lifecycle | Retain mutable adapter references so the same plugins can initialize after cleanup. A secure-storage regression test verifies two lifecycles. |
| Platform startup | The app could start before binding initialization completed | Await binding setup before launching the initialization view. |
| Feature initialization | Sorting did not ensure asynchronous dependencies had completed | Await named prerequisites while independent features remain concurrent. Reject missing dependencies and cycles. |
| Lazy features | Duplicate loads, orphaned errors, mismatched names, dropped URL parameters, and failed route activation could leave incorrect state | Share a loading future, validate names/dependencies, preserve full URIs, copy incoming feature lists, resolve routes before publication, and clean up failed route activation for retry. |
| Cache | get/has could return expired data; concurrent misses generated repeatedly; unawaited expiration cleanup could delete a replacement | Enforce TTL on all reads, await mutation, coalesce generation per key, and preserve fresh results when storage fails. Five regression tests cover these contracts. |
| Sanity provider | fetchById and fetchRoute ignored useCache; disposal retained local cached responses | Forward cache policy and clear local cache. Three tests verify request counts, fresh revisions, typed route conversion, and disposal. |
| Sanity timing | clientTimeMs came from the server-timing header, not client transport elapsed time | Measure GET and POST with a stopwatch through full response receipt. Keep serverTimeMs from the response. Two tests verify the distinction. |
| Configured actions | Navigation and refresh used async void, so an awaited action could finish early | Return Future<void>, await route resolution/refresh, and validate the selected destination type at runtime. Three regression tests cover completion and invalid configuration. |
| Documentation accuracy | Examples described nonexistent i18n/plugin slots, incorrect platform builder methods, automatic custom-plugin DI registration, incorrect condition results, invalid storage/provider class names, and nonexistent console trace/metric output | Replace these with source-backed contracts. Conditions return string case values; custom plugins use getPlugin or explicit DI registration; platform widgets use callback fields and copyWith; Flutter owns localization delegates, while optional LocalePlugin coordinates locale changes. |
| API documentation | Hand-maintained signatures drifted from implementation | Extract declarations and directly declared members from source, generate 18 package pages, and ensure duplicate names receive distinct anchors. |
| Website duplication | Multiple old presentation components and diagram controls implemented overlapping behavior | Reuse ActionLink, FrameworkLayers, TechStack, ReadingTools, BrandLogo, SiteFooter, and one Mermaid renderer. Reading controls share one reactive preference. |

## Package coverage

| Package | Reviewed ownership and contracts |
| --- | --- |
| vyuh_core | Composition, plugin slots/defaults, lifecycle, feature dependencies, lazy activation, routing, events, DI, widget callbacks |
| vyuh_cache | TTL, invalidation, concurrency, storage failures, memory storage |
| vyuh_extension_content | Registry/deserialization contracts, layouts, actions, condition values, document widgets and scopes |
| vyuh_feature_system | Built-in configurations; navigation and refresh sequencing; optional content contributions |
| vyuh_feature_auth | Auth capability boundary, content form registrations, corresponding schema exports |
| vyuh_feature_onboarding | Steps, layouts, content builder, matching authoring schema |
| vyuh_feature_developer | Registry inspection and preview ownership |
| vyuh_content_widget | Embedded binding/readiness and host navigation ownership |
| sanity_client | Query transport, GET/POST selection, response timing, media URLs, live update concurrency |
| vyuh_plugin_content_provider_sanity | Typed conversion, local cache policy, provider disposal, live adapter |
| flutter_sanity_portable_text | Public models, renderer builders, configuration boundary |
| vyuh_plugin_storage_hive | Storage lifecycle and persistence semantics |
| vyuh_plugin_storage_secure | String-only secure storage and platform adapter boundary |
| vyuh_plugin_storage_shared_preferences | String conversion/read semantics; not arbitrary-object round trips |
| vyuh_plugin_telemetry_provider_console | Telemetry provider integration and logging/trace contract |
| vyuh_cli | Commands, name validation, templates, authoring prerequisites |
| vyuh_test | Readiness helpers, binding assumptions, cleanup between lifecycles |
| vyuh_widgetbook | Preview adapter contracts; production registry remains separate |

The source inventory contains 357 library Dart files including generated serializers. The API snapshot contains 391 declarations. It excludes generated serializers, private names, inherited members, and APIs from external packages. It scans public library entry points and relative exports; it does not fully resolve show/hide combinators or inferred types. Import availability is governed by the actual library export. Published Dartdoc remains the release-specific reference.

The auth and onboarding schema exports were checked against their local entry points. Shared schema core/system/forms packages are external dependencies; their implementation is not owned by this checkout.

## Remaining findings

| Priority | Finding and owner | Suggested correction |
| --- | --- | --- |
| P1 | Sanity live fetches can overlap and publish an older response after a newer response. Connection errors throw from callbacks instead of reliably arriving as stream errors. Owner: sanity_client/lib/live.dart | Serialize/coalesce refresh requests or use request generations; deliver connection failures through the controller; add cancellation/reconnect and out-of-order-response tests. |
| P1 | DocumentFutureBuilder refreshes only at init or explicit refresh; replacing its future callback with new document parameters can retain the prior result. Owner: vyuh_extension_content/lib/ui/document_future_builder.dart | Handle didUpdateWidget with request identity/generation and verify parameter changes and stale completion behavior. |
| P1 | Lazy activation can publish partial extension contributions if registration or router replacement fails. Reset does not cancel activation already in flight. Owner: vyuh_core/lib/runtime/platform/default_platform.dart and lazy_feature_manager.dart | Introduce lifecycle generations and an activation transaction with rollback, then test disposal during loading and failed publication. |
| P2 | DocumentStreamBuilder does not explicitly surface ObservableStream.error and refresh resubscribes to the same stream. Single-subscription streams may reject another listener. Owner: vyuh_extension_content/lib/ui/document_stream_builder.dart | Expose error state and make refresh ownership explicit, preferably with a stream factory; test stream replacement, retry, and cancellation. |
| P2 | PluginDescriptor rejects named system plugin types in others only through assert; behavior differs in release builds | Enforce the contract with a runtime error and add release-independent tests. |
| P2 | Cache storage has no capacity eviction, and remove/clear do not cancel generation already in flight | Add a bounded backend when measured workloads require it; specify invalidation generations before promising cancellation semantics. Existing docs disclose both limits. |
| P2 | The content-extension suite still fails or stalls, including missing binding setup, layout/modifier error expectations, registry assertions, and lifecycle cleanup | Repair test setup and clarify the expected error contracts before adding that entire suite as a release gate. Do not infer that its runtime behavior is validated from core test results. |
| P3 | LazyFeatureManager stores an unused route-prefix map alongside descriptors | Remove redundant derived state in a scoped cleanup after lifecycle transaction work. |
| P3 | Mermaid ships large lazy chunks | Measure first-diagram latency and compare a flowchart-only bundle. It is already imported only near visible diagrams; no latency benchmark was performed. |

## Documentation and website

- The header contains only Getting Started and Concepts.
- Core navigation follows Getting Started, Concepts, Guides, Framework, Examples, and API References. A CMS Integration entry opens a dedicated sidebar; optional examples remain last there.
- A Why Vyuh page explains ownership, app-selected capabilities, portability, explicit contributions, lifecycle, and the costs and limits of the model. Getting Started progresses from one feature to two features sharing a plugin.
- Core entry pages and guides describe Flutter features, plugin capabilities, routing, lifecycle, state, DI, and tooling. Content-system tutorials, Sanity, schemas, content feature flags, document scopes, template routing, and integration examples belong to CMS Integration.
- 39 integration guides, package overviews, API pages, and examples have canonical /docs/cms/ paths. Previous URLs are redirect-only pages, excluded from search and the sitemap; Cloudflare 301 rules and local dev redirects preserve entry points. API generation keeps the new separation.
- The Bookmarks tutorial omits the optional developer-content feature, registers/unregisters its own store, and uses a counter for unique entry identifiers.
- Runtime example tests exposed missing Flutter MaterialLocalizations under the current material_ui root. The app examples explicitly select Flutter MaterialApp.router through PlatformWidgetBuilder; the default framework root is unchanged.
- Storage examples use actual getPlugin lookups, and the abstract contracts no longer promise encryption/persistence from the default memory adapters. The current core package still depends on Portable Text and exports content contracts; optional runtime activation does not erase those source dependencies.
- The homepage explains shared plugins beneath reusable features and app compositions. It uses white, the logo’s indigo #5856D6, dark primary CTAs, text secondary actions, and one light blue #1684D8 for both tech marks and Flutter emphasis.
- DM Sans handles headings/body/captions, Lora adds limited hero emphasis, Kalam handles diagram labels, and JetBrains Mono handles code.
- Dart syntax highlighting is shared across the homepage and docs. Homepage code uses 14px text and 24px left padding.
- Documentation diagrams are editable Mermaid sources rendered as sketch SVGs. There are no download controls, text-expansion links, or captions around those diagrams. The build validates all 115 Mermaid blocks.
- SVG text labels replace clipped HTML labels; padding and font metrics keep text within blocks. Representative light/dark diagrams were inspected in the browser.
- The shared footer includes a visible original Rive brand asset with a static fallback, website links, tagline, copyright, GitHub, and Twitter/X.
- The design-system page renders the actual shared components. Reading-size controls synchronize their selection. Motion respects reduced-motion preferences.
- The social preview is rebuilt from an editable SVG with the modular framework story.
- The preview remains a VitePress dev server with HMR on port 4173. Build output is ignored by the dev watcher.

## Dependency updates and compatibility

Npm workspace packages and lockfiles were refreshed, including Sanity 6.17, React 19.3, Vue 3.5, Mermaid 12, Tailwind 4.3, Rive 2.43, and tooling. VitePress is pinned to 2.0.0-alpha.20: this is a prerelease, not stable 1.x.

TypeScript is pinned to 6.0.3 because TypeScript 7.0.2 failed tsup declaration generation. The schema builds pass with the compatible compiler. Shared external schema packages retain older peer metadata, so React/Sanity versions are unified through root overrides; Studio runtime interaction still needs a dedicated smoke test.

Dart tooling adds analyzer/path for source extraction. Existing ignored local CDX overrides are used during local verification; these results do not validate a clean consumer against every published private dependency. Unrelated local dependency drift is excluded from the checked-in Dart lock change.

## Verification

- Static analysis across system, Sanity, plugin, CLI libraries, and the API generator: no issues.
- Core, Sanity client, and provider suites: 96 tests pass.
- Cache suite: 5 tests pass.
- Navigation/refresh regression suite: 3 tests pass.
- Secure-storage lifecycle regression: 1 test passes.
- Composition example interaction suite: 2 tests pass, covering shared edits and independent feature reuse.
- Total targeted passing tests across the audit: 107.
- Extracted Bookmarks tutorial, first-app example, composition example, and related source comments pass static analysis.
- Content extension suite: 7 passes, 11 reported failures, and an additional test did not complete; interrupted. This suite is not green.
- All schema packages and Sanity Studio build successfully.
- Frozen offline npm workspace install succeeds.
- Documentation build succeeds with dead-link checking and validation of 115 Mermaid diagrams.
- Additional restructuring checks: separate core/CMS sidebars, legacy API redirects including query and fragment, canonical search results, sitemap exclusion of redirects, and 390px composition rendering without document overflow.
- Browser checks: header links, homepage, code size/padding, matched blues, first-app label containment, dark diagrams, synchronized reading controls, footer logo, and a 390px mobile homepage with no document overflow.

Commands and logs were run locally. No release, deployment, published package verification, or measured performance benchmark is claimed.

## Save checkpoint — 2026-10-01

The implementation and this audit are saved locally; they are not a release or deployment. The stopped documentation dev server was restarted on port 4173 with HMR and returned HTTP 200.

Additional framework follow-ups:

- Decide the default root's Flutter widget compatibility contract. The current material_ui root lacks the MaterialLocalizations expected by ordinary Flutter Material widgets. Examples explicitly select Flutter MaterialApp.router; the default framework root remains unchanged.
- Separate optional CMS dependencies from core and CLI scaffolding where feasible. Core still exports content contracts and depends on Portable Text. Both feature and project counter brick pubspecs include Portable Text, the system content feature, and content extensions even for basic features. Changes must also regenerate the CLI's bundled templates and verify generated apps.

## Regenerating documentation

From the framework checkout:

```sh
dart --packages=.dart_tool/package_config.json tools/generate_api_reference.dart . ../docs/scripts/api-source.json
```

From the documentation checkout:

```sh
pnpm docs:api
pnpm docs:examples
pnpm build
pnpm dev --port 4173 --host 127.0.0.1
```

The example synchronization command expects the sibling framework checkout. The normal docs build uses checked-in Markdown and the API snapshot.

## Follow-up implementation — 2026-10-01

This checkpoint supersedes the outstanding findings and older Material localization workaround above.

- Lazy activation now restores routes and extension state after failure, rejects late activation after disposal, and waits for entered initialization cleanup. Custom builders implement `captureLazyState`; arbitrary external side effects still require feature disposal.
- Plugin slot and extension registration checks run at runtime. Navigation disposes replaced routers.
- Cache invalidation prevents older generators from restoring removed or overwritten entries. Per-key storage queues preserve concurrency across independent keys, and memory storage supports optional bounded LRU eviction.
- Document futures refresh on callback replacement and isolate stale results. Direct streams retain one subscription; refreshable factories provide fresh streams for retry. Sanity live updates coalesce refresh bursts, discard stale results, emit errors, and guard cancellation/reconnection.
- Material UI migration used the installed package’s `dart fix --apply --code=migrate_design_widgets` fixes. Examples, auth form fields, shared typography, and Widgetbook shells now use Material UI APIs. Third-party dependencies may retain their own Flutter Material internals.
- Core no longer directly depends on Portable Text. The optional system feature supplies the typed unknown Portable Text adapter. Core still exports content contracts; this is not a complete public API extraction.
- Basic CLI templates no longer introduce CMS or developer-feature dependencies. Generated bundles match the brick sources.
- Fresh package runs: core 62, content extension 31, Sanity client 42, cache 9, system feature 4, Material UI auth fields 3, CLI templates 4 tests passed. These are local package checks, not published-package or live backend proof.
- Homepage now includes a responsive plugins/features/lazy-features bento grid, App title casing, and dedicated capability documentation. Documentation build validates 124 Mermaid diagrams and canonical CMS routing. HMR runs on port 4173.

Remaining verification: real SSE reconnect behavior, published dependency/SDK matrices, measured startup and release performance, and Studio interactions with updated npm dependencies. Default memory cache remains unbounded unless `maxEntries` is selected. Custom lazy extension builders must honor their rollback contract.

### CLI scaffolding follow-up

CLI 0.2.0 adds custom capability-plugin packages, feature title/description/route options, and App platform/organization/native identifier parameters. CMS now defaults to none in both commands and bricks; authoring prerequisites and content packages are conditional. App scaffolds use Dart workspaces and local Melos 8. Built-in generation uses embedded bricks to prevent an older registry template overriding tested scaffolds. Setup subprocess failures propagate. Doctor checks Flutter/Dart by default, with optional Node/pnpm checks for Sanity.

22 focused CLI tests and source/hook analysis pass. Generated plugin lifecycle and feature code were checked against local framework dependency metadata. This does not prove an end-to-end fresh registry install, native platform builds, or authenticated Sanity Studio creation.
