## 1.10.1

 - **FIX**: readme updates.

## 1.10.0

 - **FEAT**: moving the navigation observers to analytics plugin, readme updates for packages,.

## 1.9.3

 - **FIX**: ensuring the images are rendered without any errors on Web.

## 1.9.2

 - **FIX**: updated the url builder to auto-include the '$' prefix for query param names and also enclosing the values within double-quotes. This simplifies the usage from a developer's perspective.

## 1.9.1

 - **FIX**: using the urlBuilder from client for the caching key.

## 1.9.0

 - **FEAT**: Breaking change. Split up the AnalyticsPlugin into a focused TelemetryPlugin that only does telemetry operations like error reporting and tracing. Analytics is now focused only on User level analytics.

## 1.8.1

 - **FIX**: fixed analysis errors when upgrading to flutter 3.27 and also fixing a few errors.

## 1.8.0

 - **FEAT**: first cut of the ability to specify modifiers for content and category.

## 1.7.1

 - **FIX**: analysis fixes.

## 1.7.0

 - **FEAT**: added document list view.

## 1.6.0

 - **FEAT**: introducing a simpler way to load from a CMS document and rendering with various sections.

## 1.4.1

 - **FIX**: keeping the topics to 5.

## 1.4.0

 - **FEAT**: renaming the package.

## 1.3.1

 - **FIX**: updating license.

## 1.3.0

 - **FEAT**: adding sanity content provider to the OSS vyuh framework.

## 1.2.0

 - **FEAT**: adding support for FileReference, VideoPlayer supports  FileReference from Sanity.

## 1.1.0

 - **FEAT**: using the vyuh.network plugin as a preloaded plugin and also setting it for Sanity Content Provider..now there is a single http client used across the board in the Vyuh Framework.

## 1.0.4

 - Update a dependency to the latest release.

## 1.0.3

 - Update a dependency to the latest release.

## 1.0.2

 - **REFACTOR**: increasing the sdk version for sanity provider.

## 1.0.1

 - Update a dependency to the latest release.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.4

 - **FEAT**: adding support for setting an image prefix path for local sanity provider, version upgrades.

## 1.0.0-beta.3

 - **REFACTOR**: bringing cms packages back into vyuh_packages.
 - **FEAT**: adding full support for local sanity load of dataset.

## 1.0.0-beta.2

 - **FEAT**: added a simple constructor for SanityContentProvider.

## 1.0.0-beta.1

- Initial release
- Supports reading a single or multiple documents from Sanity.io
- Fetches Routes from Sanity.io which follow the schema in the Vyuh framework
