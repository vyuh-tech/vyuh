## 1.50.0

 - **FEAT**: adding locale plugin.

## 1.49.0

 - **FEAT**: replace `UnknownContentBuilder` with `UnknownContentIndicator`, add comprehensive unknown type handling.

## 1.48.0

 - **FEAT**: upgrading to melos 7.0.

## 1.47.1

 - **FIX**: package updates.

## 1.47.0

 - **FEAT**: adding local content provider.

## 1.46.1

 - **FIX**: adding token and refreshToken to auth plugin.

## 1.46.0

 - **FEAT**: allowing registration of builders directly on ContentExtensionBuilder.

## 1.45.0

 - **FEAT**: upgrading go_router to 16.0.0 across all packages and also upgrading other packages.

## 1.44.2

 - **FIX**: making the router setup the last step in the inti process, after all plugins, features and extensions are initialized.
 - **FIX**: adding the ability to include credentials in browser client for http.

## 1.44.1

 - **FIX**: updated plugin to only include non-url-strategy parameters.

## 1.44.0

 - **FIX**: adding ability to control the fallback route in navigation plugin.
 - **FEAT**: adding the ability to configure the navigation plugin directly from the constructor.

## 1.43.4

 - **FIX**: using a RouteObserver as a mixin on a Plugin.

## 1.43.3

 - **FIX**: adding the missing context parameter for appBuilder.

## 1.43.2

 - **FIX**: removing toJSON from layouts and modifiers.

## 1.43.1

 - **FIX**: package updates and removing dep on introduction_screen.

## 1.43.0

 - **FEAT**: adding a document builder for more generalized document loading from CMS.

## 1.42.1

 - **FIX**: refactoring the live connection code.

## 1.42.0

 - **FEAT**: introducing live route updates for enhanced developer experience when working with the Sanity CMS.

## 1.41.0

 - **FEAT**: adding support for live querying across the board, from the sanity_client to the ContentProvider.

## 1.40.5

 - **FIX**: improve the query handling for live for include drafts. Also added assertions for the proper configurations. Adding a simple profile card to the Vyuh auth feature.

## 1.40.4

 - **FIX**: fixing the check for fallback route and adding direction as a parameter in oauth layout.

## 1.40.3

 - **FIX**: handling errors in the auth user card layout correctly and displaying it, including the auth plugin to return Future.error().

## 1.40.2

 - **FIX**: ensuring there are no duplicate fallback routes, fixed the boxfit of images in onboarding screen.

## 1.40.1

 - **FIX**: improved listener for live events and some linting fixes.

## 1.40.0

 - **FEAT**: adding default implementations for storage and secure storage plugins, updated readmes.

## 1.39.4

 - **FIX**: tests ... wip ... added runmode to distinguish between app and widget mode.
 - **FIX**: working tests for vyuh content binding.

## 1.39.3

 - **FIX**: added some tests (still failing), api docs and some cleanup methods.

## 1.39.2

 - **FIX**: fixed tests in vyuh_core, added check for init on VyuhContentBinding.

## 1.39.1

 - **FIX**: format fixes in readme.

## 1.39.0

 - **FEAT**: adapted some features to be compatible with the VyuhContentWidget.

## 1.38.4

 - **FIX**: fixed analysis issue.

## 1.38.3

 - **FIX**: updating api docs.

## 1.38.2

 - **FIX**: readme updates.

## 1.38.1

 - **FIX**: readme updates to make it more consistent.

## 1.38.0

 - **FEAT**: moving the navigation observers to analytics plugin, readme updates for packages,.

## 1.37.0

 - **FEAT**: adding support for previews of items ..

## 1.36.0

 - **FEAT**: introducing a hive storage plugin.

## 1.35.0

 - **FEAT**: added lineage of features for all typedescriptors and content builders, added the Content Playground for the developer tool and fixed a bunch of analysis issues.

## 1.34.0

 - **FEAT**: added lineage of features for all typedescriptors and content builders.

## 1.33.0

 - **FEAT**: tracking layouts per ContentBuilder.

## 1.32.6

 - **FIX**: simplified the use of `isRegistered<T>` method.

## 1.32.5

 - **FIX**: more readme updates to include emojis...added readme for vyuh_cache as well.

## 1.32.4

 - **FIX**: readme updates to fix some apis which were incorrect.

## 1.32.3

 - **FIX**: updates to vyuh_core readme and vyuh_feature_system README.md.

## 1.32.2

 - **FIX**: updates to vyuh_core readme.

## 1.32.1

 - **FIX**: centering the contentLoader inside its container.

## 1.32.0

 - **FEAT**: added the ability to supply a layout when calling buildContent() of the ContentPlugin.

## 1.31.0

 - **FEAT**: added support to switch out the default layouts for any content item. This is useful when using your Design System that can have unique layouts for the default content items like Card, Group, Form, etc.

## 1.30.2

 - **FIX**: working tests and some simplification in the platform init.

## 1.30.1

 - **FIX**: updated the navigation action to not invoke the lifecycleHandler for Route. Fixed the DI to reset DI on refresh and when loading the route.

## 1.30.0

 - **FIX**: tracing at the feature extension level.
 - **FEAT**: introduced Scoped DI at the Route level that allows configuring DI at the route level itself. This avoid polluting the global DI scope. Also cleaned up some types that are no longer necessary.

## 1.29.2

 - **FIX**: making the extensions async for init and dispose.

## 1.29.1

 - **FIX**: more refactorings and tests.

## 1.29.0

 - **FEAT**: adding a Client parameter to HttpNetworkPlugin, more robust init of ExtensionBuilder even when there are no ExtensionDescriptors, extension method to restart() the platform, simplified runApp, error checking when a modifier build breaks, a vyuh_test package, tentative tests for vyuh_core and vyuh_extension_content (WIP).

## 1.28.0

 - **FEAT**: added a set of tests for VyuhPlatform. Cleaned up some unnecessary properties in VyuhPlatform.

## 1.27.3

 - **FIX**: expanding the API docs.

## 1.27.2

 - **FIX**: adjusting the names of telemetry and analytics providers.

## 1.27.1

 - **FIX**: minor refactoring.

## 1.27.0

 - **FEAT**: LoggerPlugin has been removed and replaced with a Logger interface to the Telemetry Plugin instead.

## 1.26.0

 - **FEAT**: Breaking change. Split up the AnalyticsPlugin into a focused TelemetryPlugin that only does telemetry operations like error reporting and tracing. Analytics is now focused only on User level analytics.

## 1.25.3

 - **FIX**: fixed analysis errors when upgrading to flutter 3.27 and also fixing a few errors.

## 1.25.2

 - **FIX**: refactored the way an InitOnce plugin is used. NPM package upgrades.

## 1.25.1

 - **FIX**: fixed analysis errors.

## 1.25.0

 - **FIX**: adding a test behavior like debug.
 - **FEAT**: first cut of the ability to specify modifiers for content and category.

## 1.24.0

 - **FEAT**: added support for content modifiers that are configurable from the CMS.

## 1.23.3

 - **FIX**: analysis fixes.

## 1.23.2

 - **FIX**: simplifying the setup of extension builders removed the specialized logic that existed earlier for the Content Plugin.

## 1.23.1

 - **FIX**: analysis fixes.

## 1.23.0

 - **FEAT**: introducing events that allow tracking lifecycle events as well as cross-feature communication with type-safety.

## 1.22.5

 - **FIX**: including the sendOtp method in auth plugin.

## 1.22.4

 - **FIX**: updated the message for missing path handler.

## 1.22.3

 - **FIX**: using the right color combinations for error.

## 1.22.2

 - **FIX**: make the AuthPlugin more generic.

## 1.22.1

 - **FIX**: add the layouts parameter to ContentDescriptor and the layout parameter to ContentItem as mandatory.

## 1.22.0

 - **FEAT**: add the ability to cancel out other auth flows when the active is in operation.

## 1.21.0

 - **FEAT**: add new user registration to auth plugin, tweak the title and description of action field.
 - **FEAT**: added oauth sign widgets and schemas.
 - **FEAT**: refactoring the auth package.

## 1.20.0

 - **FEAT**: added document list view.

## 1.19.0

 - **FEAT**: introducing a simpler way to load from a CMS document and rendering with various sections.

## 1.18.0

 - **FEAT**: introducing an EnvPlugin for managing env-vars loaded from .env files or elsewhere.

## 1.17.0

 - **FEAT**: updating the auth plugin to be more open-ended with OAuth. Removes additional methods for github/linkedin/twitter etc.

## 1.16.1

 - **FIX**: using a toString on exception to detect SocketException. This makes it compatible with Web platform.

## 1.16.0

 - Breaking change with the use of PluginDescriptor to describe plugins. The use of PluginType enum has been removed to be more opended with plugins

## 1.15.0

 - **FEAT**: added a transitionsBuilder parameter to the default route page builder.

## 1.14.0

 - **FEAT**: adding support for FileReference, VideoPlayer supports  FileReference from Sanity.

## 1.13.0

 - **FEAT**: added a BuildContext parameter to all loaders and error views. This helps in using the Theme from the context.

## 1.12.0

 - **FEAT**: renaming PageRouteScaffold to RouteScaffold. Added a SingleItemRouteScaffold for showing only the first item in a body region, a common use case.

## 1.11.2

 - **FIX**: better messaging on errors for missing types.

## 1.11.1

 - **FIX**: making the title optional.

## 1.11.0

 - **FEAT**: using the vyuh.network plugin as a preloaded plugin and also setting it for Sanity Content Provider..now there is a single http client used across the board in the Vyuh Framework.

## 1.10.0

 - **FEAT**: adding retry and timeout options in Network plugin.

## 1.9.7

 - **REFACTOR**: deps upgrade.

## 1.9.6

 - **FIX**: adding API documentation..WIP.

## 1.9.5

 - **FIX**: adding API documentation..WIP.

## 1.9.4

 - **FIX**: adding API documentation..WIP.

## 1.9.3

 - **FIX**: keeping the route build for all modes.
 - **FIX**: better handling of keys in pages.

## 1.9.2

 - **FIX**: better handling of keys in pages.
 - **FIX**: using UniqueKey for pages.

## 1.9.1

 - **FIX**: using UniqueKey for pages.

## 1.9.0

 - **FIX**: making sure the navigation happens correctly with a ValueKey for the MaterialPage.
 - **FEAT**: adding repaint boundaries and fixing grid and single item layouts.

## 1.8.0

 - **FEAT**: adding repaint boundaries and fixing grid and single item layouts.

## 1.7.0

 - **FEAT**: pulling some go router configuration into the default navigation plugin.
 - **FEAT**: adding the FSL license at the top level.

## 1.6.0

 - **FEAT**: pulling some go router configuration into the default navigation plugin.
 - **FEAT**: adding the FSL license at the top level.

## 1.5.0

 - **FEAT**: switching to the FSL license with future MIT license after 2 years.
 - **FEAT**: restoring user selected initialRoute.

## 1.4.0

 - **FEAT**: restoring user selected initialRoute.

## 1.3.0

 - **FEAT**: adding ability to resolve a CMS path from a local path. It's currently one-directional...local->CMS.

## 1.2.0

 - **FEAT**: added support for child traces in analytics.

## 1.1.0

 - **FEAT**: refactoring services and introducing some new conditions for screen-size, theme-mode, platform, user-auth.

## 1.0.2

 - **REFACTOR**: version updates of packages.

## 1.0.1

 - **FEAT**: moving more of the routing logic into the navigation plugin. Also added the ability to do dynamic route changes.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.22

 - **FEAT**: adding a toggle theme method.

## 1.0.0-beta.21

 - **FEAT**: adding storage related plugins.

## 1.0.0-beta.20

 - **FIX**: adding the missing TUser generic value.

## 1.0.0-beta.19

 - **FEAT**: added a feature flag condition and included featureFlag has a field of the Vyuh platform instance.

## 1.0.0-beta.18

 - **FEAT**: removed the base modifier from all plugin classes.

## 1.0.0-beta.17

 - **FEAT**: making the AuthPlugin have a generic User parameter.

## 1.0.0-beta.16

 - **FEAT**: the router is now part of the Navigation Plugin.

## 1.0.0-beta.15

 - **FEAT**: refactor for deeper support of Sanity Images.

## 1.0.0-beta.14

 - **REFACTOR**: moving content types into the plugin.

## 1.0.0-beta.13

 - Adding a Powered by Vyuh marker

## 1.0.0-beta.12

 - package updates

## 1.0.0-beta.11

 - **FEAT**: first cut of conditional layouts.

## 1.0.0-beta.10

 - **REFACTOR**: The RouteTypeConfiguration class is removed from the vyuh_extension_content and moved to the vyuh_core content.

## 1.0.0-beta.9

 - **FIX**: ensured the extension builders are also disposed and init-ed correctly.

## 1.0.0-beta.8

 - **FIX**: adding error when using content plugin without configuring it.

## 1.0.0-beta.7

 - **FEAT**: adding better handling of auth with the use of an Unknown User.

## 1.0.0-beta.6

 - **FIX**: removed class modifier "base" to allow external inheritance.

## 1.0.0-beta.5

 - **FIX**: adding missing export.

## 1.0.0-beta.4

 - **FEAT**: added exception to the auth plugin.

## 1.0.0-beta.3

- Using `TypeDescriptor` to register types instead of the previous
  `FromJsonConverter`
- Adding plugin interface for `FeatureFlagPlugin`
- Refactored error views to be different for content and routes
- `features` are now an async function allowing you to decide which ones to
  include at runtime. This becomes a breaking change for `FeatureDescriptor`.
- Added a `NetworkPlugin` interface with the default implementation for Http. It
  now becomes a required plugin.

## 1.0.0-beta.2

- Plugins in the runApp are optional

- **REFACTOR**: moving packages into the system folder.
  ([e1b3a744](https://github.com/vyuh-tech/vyuh/commit/e1b3a744e16d2c464ce8128a6782d47f85f8e5ed))

## 1.0.0-beta.1

- Initial release.
- Adds the ability to build apps using features. Each feature can be described
  with the `FeatureDescriptor`
- Initial support for core plugins: Dependency Injection (DI), Content,
  Analytics, Logger
- Core runtime support to bootstrap an app out of its features
