## 1.8.1

 - **FIX**: cleaning up analysis issues.

## 1.8.0

 - **FEAT**: upgrading to melos 7.0.

## 1.7.0

 - **FEAT**: upgrading go_router to 16.0.0 across all packages and also upgrading other packages.

## 1.6.2

 - **FIX**: format fixes in readme.

## 1.6.1

 - **FIX**: readme updates.

## 1.6.0

 - **FEAT**: moving the navigation observers to analytics plugin, readme updates for packages,.

## 1.5.1

 - **FIX**: fixed analysis errors when upgrading to flutter 3.27 and also fixing a few errors.

## 1.5.0

 - **FEAT**: added support for content modifiers that are configurable from the CMS.

## 1.4.1

 - **FIX**: analysis fixes.

## 1.4.0

 - **FEAT**: add a custom list builder to render a PortableText. The default one uses a ListView.builder and opens up opportunity to render using other methods as well such as SliverList or a plain Column.

## 1.3.4

 - **REFACTOR**: deps upgrade.

## 1.3.3

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.

## 1.3.2

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.

## 1.3.1

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.

## 1.3.0

 - **FEAT**: added control for scrollPhysics in PortableText.
 - **FEAT**: adding the FSL license at the top level.

## 1.2.0

 - **FEAT**: switching to the FSL license with future MIT license after 2 years.
 - **FEAT**: adding the ability to customize the bullet renderer.

## 1.1.0

 - **FEAT**: adding the ability to customize the bullet renderer.

## 1.0.1

 - **REFACTOR**: version updates of packages.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.22

 - **FEAT**: added support for the "code" style markdef.

## 1.0.0-beta.21

- Updated readme

## 1.0.0-beta.20

- Bump "flutter_sanity_portable_text" to `1.0.0-beta.20`.

## 1.0.0-beta.19

- Updates to readme and example

## 1.0.0-beta.18

- Shorter pubspec description

## 1.0.0-beta.17

- 100% test coverage

## 1.0.0-beta.16

- **FIX**: using the right format for screenshots.
  ([ce78e1f9](https://github.com/vyuh-tech/vyuh/commit/ce78e1f9ee6baf497a177bec4a1b7547d1eac2e7))
- **FEAT**: changed the interface of MarkDefDescriptor to become more flexible
  with generating InlineSpan instead of just a TextSpan. This allows greater
  decorations to be attached to an annotation.
  ([2e9d4550](https://github.com/vyuh-tech/vyuh/commit/2e9d45503e149159a3cd982357c97e91ab26bdd1))
- **FEAT**: refactored portable text to be more resilient.
  ([39db715f](https://github.com/vyuh-tech/vyuh/commit/39db715ff85032721b94c82176d7b8ebda384151))
- Changed the interface of the builders to accept the `BuildContext` as the
  first parameter

## 1.0.0-beta.15

- **FEAT**: changed the interface of MarkDefDescriptor to become more flexible
  with generating InlineSpan instead of just a TextSpan. This allows greater
  decorations to be attached to an annotation.

## 1.0.0-beta.14

- Bump "flutter_sanity_portable_text" to `1.0.0-beta.14`.

## 1.0.0-beta.13

- Updated readme

- **REFACTOR**: moving flutter_sanity_portable_text and sanity_client under
  vyuh.
  ([f1175fbd](https://github.com/vyuh-tech/vyuh/commit/f1175fbdb602588ef5f8d978a3d474f15a96e861))
- **FIX**: using the right format for screenshots.
  ([ce78e1f9](https://github.com/vyuh-tech/vyuh/commit/ce78e1f9ee6baf497a177bec4a1b7547d1eac2e7))
- **FEAT**: refactored portable text to be more resilient.
  ([39db715f](https://github.com/vyuh-tech/vyuh/commit/39db715ff85032721b94c82176d7b8ebda384151))

## 1.0.0-beta.12

- Added support to report errors for missing annotations
- Changed signatures of the builders for mark, block and container
- Refactored the error view to be more universally useful

## 1.0.0-beta.10 - 1.0.0-beta.11

- Fixing the format for screenshots in pubspec.yaml
- Updated readme and example code

- **FIX**: using the right format for screenshots.
  ([ce78e1f9](https://github.com/vyuh-tech/vyuh/commit/ce78e1f9ee6baf497a177bec4a1b7547d1eac2e7))

## 1.0.0-beta.9

- Added screenshot and readme with example

## 1.0.0-beta.8

- Updated example to avoid analyzer issues and added better description for the
  package

## 1.0.0-beta.7

- Added example and simplified API for direct usage

## 1.0.0-beta.6

- Added more documentation

## 1.0.0-beta.5

- Refactored file structure
- Added documentation for all classes

## 1.0.0-beta.4

- Moved the sanity packages under the vyuh repo

- **REFACTOR**: moving flutter_sanity_portable_text and sanity_client under
  vyuh.
  ([f1175fbd](https://github.com/vyuh-tech/vyuh/commit/f1175fbdb602588ef5f8d978a3d474f15a96e861))

## 1.0.0-beta.3

- Updated license to MIT

## 1.0.0-beta.2 - 1.0.0-beta.1

- First release with a set of core features
- Supported features include:
  - All standard [portable-text](https://github.com/portabletext/portabletext)
    annotations and styles
  - Annotations can have interactions as well
  - Configuration to adjust styles, annotations, custom blocks and block
    containers
  - List with bullets and numbers
