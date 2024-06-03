## 1.2.0

 - **REFACTOR**: version updates of packages.
 - **REFACTOR**: moving content types into the plugin.
 - **REFACTOR**: The RouteTypeConfiguration class is removed from the vyuh_extension_content and moved to the vyuh_core content.
 - **REFACTOR**: moving packages into the system folder.
 - **FIX**: adding the missing TUser generic value.
 - **FIX**: ensured the extension builders are also disposed and init-ed correctly.
 - **FIX**: adding error when using content plugin without configuring it.
 - **FIX**: removed class modifier "base" to allow external inheritance.
 - **FIX**: adding missing export.
 - **FEAT**: refactoring services and introducing some new conditions for screen-size, theme-mode, platform, user-auth.
 - **FEAT**: moving more of the routing logic into the navigation plugin. Also added the ability to do dynamic route changes.
 - **FEAT**: adding a toggle theme method.
 - **FEAT**: adding storage related plugins.
 - **FEAT**: added a feature flag condition and included featureFlag has a field of the Vyuh platform instance.
 - **FEAT**: removed the base modifier from all plugin classes.
 - **FEAT**: making the AuthPlugin have a generic User parameter.
 - **FEAT**: the router is now part of the Navigation Plugin.
 - **FEAT**: refactor for deeper support of Sanity Images.
 - **FEAT**: first cut of conditional layouts.
 - **FEAT**: adding better handling of auth with the use of an Unknown User.
 - **FEAT**: added exception to the auth plugin.

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
