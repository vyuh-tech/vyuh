## 1.8.3

 - **FIX**: refactoring the live connection code.

## 1.8.2

 - **FIX**: adding more tests and also removing the need to specify token for useCdn=true and perspective=published.

## 1.8.1

 - **FIX**: adding support for multiple event streams.

## 1.8.0

 - **FIX**: example update.
 - **FEAT**: adding support for live querying across the board, from the sanity_client to the ContentProvider.

## 1.7.7

 - **FIX**: readme fixed with correct API.

## 1.7.6

 - **FIX**: improve the query handling for live for include drafts. Also added assertions for the proper configurations. Adding a simple profile card to the Vyuh auth feature.

## 1.7.5

 - **FIX**: including live as a config, updated the vyuh_feature_auth to be a bit more comprehensive and includes correct icons for various OAuth providers.

## 1.7.4

 - **FIX**: fixed the stale responses in live query. It was because the lastEventId changes for every message and should be tracked.

## 1.7.3

 - **FIX**: added support for launch icons, launch images in "vyuh create project", lint fixes.
 - **FIX**: added lastLiveEventId in refetches.
 - **FIX**: added tracking for syncTags and using that for live requery.

## 1.7.2

 - **FIX**: improved listener for live events and some linting fixes.

## 1.7.1

 - **FIX**: tests in sanity client, adding readme for secure storage plugin.

## 1.7.0

 - **FIX**: trying a few things.
 - **FEAT**: draft approach to live content queries.

## 1.6.1

 - **FIX**: format fixes in readme.

## 1.6.0

 - **FEAT**: moving the navigation observers to analytics plugin, readme updates for packages,.

## 1.5.3

 - **FIX**: updated the url builder to auto-include the '$' prefix for query param names and also enclosing the values within double-quotes. This simplifies the usage from a developer's perspective.

## 1.5.2

 - **FIX**: fixed analysis issues.

## 1.5.1

 - **FIX**: adding more tests for url builder and query handling.

## 1.5.0

 - **REFACTOR**(sanity_client): remove postUri to not expose from url_builder.
 - **REFACTOR**(sanity_client): make SanityRequest private, do not export from library.
 - **FIX**: using the urlBuilder from client for the caching key.
 - **FEAT**(sanity_client): add test coverage for GET/POST url queries.
 - **FEAT**(sanity_client): add SanityRequest to handle GET vs POST.
 - **FEAT**(sanity_client): add ability to post request.

## 1.4.3

 - **FEAT**: sanity_client will determine whether to GET or POST requests with GROQ body and params based on query byte size (11kb limit).

## 1.4.2

 - **FIX**: fixed analysis errors when upgrading to flutter 3.27 and also fixing a few errors.

## 1.4.1

 - **FIX**: analysis fixes.

## 1.4.0

 - **FEAT**: updating the auth plugin to be more open-ended with OAuth. Removes additional methods for github/linkedin/twitter etc.

## 1.3.0

 - **FEAT**: using the vyuh.network plugin as a preloaded plugin and also setting it for Sanity Content Provider..now there is a single http client used across the board in the Vyuh Framework.

## 1.2.2

 - **FIX**: result type of sanity_client is now dynamic instead of Map<String, dynamic>.
 - **FIX**: adding API documentation..WIP.

## 1.2.1

 - **FIX**: adding API documentation..WIP.

## 1.2.0

 - **FEAT**: adding the FSL license at the top level.

## 1.1.0

 - **FEAT**: switching to the FSL license with future MIT license after 2 years.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.7

 - **FIX**: using the state.uri for the full path of the page.

## 1.0.0-beta.6

 - **FEAT**: refactor for deeper support of Sanity Images.

## 1.0.0-beta.5

- Refactored tests for 100% coverage
- Updated pubspec description and readme
- Added documentation for all the classes and methods

## 1.0.0-beta.4

- Moved the sanity packages under the vyuh repo

- **REFACTOR**: moving flutter_sanity_portable_text and sanity_client under
  vyuh.
  ([f1175fbd](https://github.com/vyuh-tech/vyuh/commit/f1175fbdb602588ef5f8d978a3d474f15a96e861))

## 1.0.0-beta.3

- Updated license to MIT

## 1.0.0-beta.2 - 1.0.0-beta.1

- Includes the ability to connect to a Sanity project with specific config
- Includes ability to construct image urls from `_ref`
