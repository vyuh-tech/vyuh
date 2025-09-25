## 0.0.12

 - **FEAT**: upgrading to melos 7.0.

## 0.0.11

 - **FEAT**: upgrading go_router to 16.0.0 across all packages and also upgrading other packages.

## 0.0.10+5

 - **FIX**: package updates and removing dep on introduction_screen.

## 0.0.10+4

 - **FIX**: adding dash in the regex for identifier.

## 0.0.10+3

 - **FIX**: version upgrades and setting the invocation line consistenly across commands.

## 0.0.10+2

 - **FIX**: linting fixes.

## 0.0.10+1

 - **FIX**: refactoring to make the create commands more consistent.

## 0.0.10

 - **FEAT**: adding support for creating content items with vyuh_cli.

## 0.0.9

 - **FEAT**: introducing live route updates for enhanced developer experience when working with the Sanity CMS.

## 0.0.8+4

 - **FIX**: adding the missing .env file to project brick.

## 0.0.8+3

 - **FIX**: added support for launch icons, launch images in "vyuh create project", lint fixes.

## 0.0.8+2

 - **FIX**: format fixes in readme.

## 0.0.8+1

 - **FIX**: format fixes in readme.

## 0.0.8

 - Adding the doctor command to analyze system for proper usage

## 0.0.7

 - **FEAT**: LoggerPlugin has been removed and replaced with a Logger interface to the Telemetry Plugin instead.

## 0.0.6

 - **FEAT**: Breaking change. Split up the AnalyticsPlugin into a focused TelemetryPlugin that only does telemetry operations like error reporting and tracing. Analytics is now focused only on User level analytics.

## 0.0.5+3

 - **FIX**: fixed analysis errors when upgrading to flutter 3.27 and also fixing a few errors.

## 0.0.5+2

 - **FIX**: fixed an issue where the Sanity command was incorrectly treated as error.

## 0.0.5+1

 - **REFACTOR**: cleaning up some code, visual tweaks.

## 0.0.5

 - **FEAT**: adding feature examples, schemas and some core feature packages like auth and onboarding.

## 0.0.4+6

 - **FIX**: update bundles to remove the stray .DS_Store folders.

## 0.0.4+5

 - **FIX**: ensure we do checks for pnpm and sanity and print errors on failure.

## 0.0.4+4

 - **REFACTOR**: flattening the command hierarchy.

## 0.0.4+3

 - **REFACTOR**: tracking operations.
 - **FIX**: check for pnpm before running other commands.
 - **FIX**: moved update version script into vyuh_cli.

## 0.0.4+2

 - **REFACTOR**: tracking operations.

## 0.0.4+1

 - **FIX**: normalizing path strings for windows.

## 0.0.4

 - **FIX**: update path of feature in justfile.
 - **FEAT**: adding more commands to the justfile.

## 0.0.3+5

 - **FIX**: update the pubspec with correct repo info.

## 0.0.3+4

 - **FIX**: update descriptions of commands.

## 0.0.3+3

 - **FIX**: readme update.

## 0.0.3+2

 - **FIX**: updating readme and bundles.

## 0.0.3+1

 - **FIX**: updated readme with correct command.

## 0.0.3

 - **FIX**: made the version as a post hook as it need to run after the version command has completed.
 - **FEAT**: updated descriptions of some commands.

## 0.0.2+3

 - **FIX**(vyuh_cli): Added pre-version hook to correct `update` command messaging.
 - **DOCS**(vyuh_cli): Updated assets and README.md.

## 0.0.2+2

 - **FIX**: dart format, readme and pubspec updates.

## 0.0.2+1

 - **FIX**: updated readme to use hot-linked images.
 - **FIX**: updated pubspec.

## 0.0.2

 - **REFACTOR**(vyuh_cli): Renamed command to `schema` from ``feature-sanity-schema`.
 - **REFACTOR**(vyuh_cli): renamed command `flutter_app` to `project` and removed prefix from templates.
 - **REFACTOR**(vyuh_cli): Moved `_logSummary` in template to a common method in utils i.e. `templateSummary`.
 - **REFACTOR**(vyuh_cli): file name clean up.
 - **FEAT**: updated readme, using melos for workspace.
 - **FEAT**(vyuh_cli): Added vyuh_cli.
 - **DOCS**(vyuh_cli): Updated vyuh_cli.png.
 - **DOCS**(vyuh_cli): Updated comments.
 - **DOCS**(vyuh_cli): Updated README.md, added CHANGELOG.md,LICENSE & example.

## 0.0.1

- First release with a set of core commands
  - `vyuh create project`
  - `vyuh create feature`
  - `vyuh create schema`
