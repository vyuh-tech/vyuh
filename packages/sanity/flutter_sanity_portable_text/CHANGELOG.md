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
