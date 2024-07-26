## 1.18.0

 - **FEAT**: renaming PageRouteScaffold to RouteScaffold. Added a SingleItemRouteScaffold for showing only the first item in a body region, a common use case.

## 1.17.1

 - **FIX**: back to appBar instead of using SliverAppBar.

## 1.17.0

 - **FEAT**: adding delay action.

## 1.16.0

 - **FEAT**: adding button layout.

## 1.15.7

 - **FIX**: making the title optional.

## 1.15.6

 - Update a dependency to the latest release.

## 1.15.5

 - Update a dependency to the latest release.

## 1.15.4

 - **FIX**: padding fixes and changing hte way certain actions work.

## 1.15.3

 - **REFACTOR**: visual tweaks to increase padding.

## 1.15.2

 - **FIX**: removing the pagestorage key as it was interfering in proper disposal of some widget and causing unintended scroll effects in other widgets.

## 1.15.1

 - **REFACTOR**: deps upgrade.

## 1.15.0

 - **REFACTOR**: using typeDescriptor and contentBuilder to hide details for all content items.
 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.
 - **FEAT**: adding support for safeArea in default layout and extracting the core route builder as a scaffold.

## 1.14.0

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.
 - **FEAT**: adding support for safeArea in default layout and extracting the core route builder as a scaffold.

## 1.13.6

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.

## 1.13.5

 - **FIX**: adding cacheExtent, layout tweaks for Card, PortableText and Route.

## 1.13.4

 - **FIX**: better handling of keys in pages.

## 1.13.3

 - **FIX**: better handling of keys in pages.
 - **FIX**: using UniqueKey for pages.
 - **FIX**: adding keys for route type pages.

## 1.13.2

 - **FIX**: using UniqueKey for pages.
 - **FIX**: adding keys for route type pages.

## 1.13.1

 - **FIX**: adding keys for route type pages.

## 1.13.0

 - **FIX**: making sure the navigation happens correctly with a ValueKey for the MaterialPage.
 - **FEAT**: adding repaint boundaries and fixing grid and single item layouts.
 - **FEAT**: merging the sliver route layout with default.

## 1.12.0

 - **FEAT**: adding repaint boundaries and fixing grid and single item layouts.
 - **FEAT**: merging the sliver route layout with default.

## 1.11.0

 - **FEAT**: merging the sliver route layout with default.

## 1.10.0

 - **FEAT**: ContentBuilder is no longer abstract, Card layout adjustments, AppBar can be toggled in default route layout, grid layout can now have single column, minor fixes in navigation action.
 - **FEAT**: adding the FSL license at the top level.

## 1.9.0

 - **FEAT**: switching to the FSL license with future MIT license after 2 years.

## 1.8.1

 - **FIX**: using the default layout for conditional route only in debug mode.

## 1.8.0

 - **FEAT**: adding ability to resolve a CMS path from a local path. It's currently one-directional...local->CMS.

## 1.7.1

 - **REFACTOR**: version upgrades.

## 1.7.0

 - **FEAT**: added the alert action.

## 1.6.0

 - **FEAT**: added the alert action.

## 1.5.0

 - **FEAT**: adding rest of the actions such drawer, open in dialog.
 - **FEAT**: expanding the set of actions to include navigation, theme switch, opening dialogs, show/hide snackbars.

## 1.4.1

 - **FIX**(content-image): use CachedNetworkImageProvider for all images.

## 1.4.0

 - **FEAT**: adding cache extent for smoother scrolling.

## 1.3.0

 - **FEAT**: adding cache extent for smoother scrolling.

## 1.2.0

 - **FEAT**: refactoring services and introducing some new conditions for screen-size, theme-mode, platform, user-auth.

## 1.1.2

 - **FIX**: update schema names.

## 1.1.1

 - **FIX**: including the ThemeService in system init.

## 1.1.0

 - **FEAT**: adding restart and toggleTheme actions.

## 1.0.1

 - **REFACTOR**: version updates of packages.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.38

 - **FEAT**: conditional shows the pending indicator based on a boolean setting on the conditional.

## 1.0.0-beta.37

 - **FEAT**: added a feature flag condition and included featureFlag has a field of the Vyuh platform instance.

## 1.0.0-beta.36

 - **FEAT**: clipping content image placeholder for overflows.

## 1.0.0-beta.35

 - **FEAT**: adding more parameters to ContentImage.

## 1.0.0-beta.34

 - **FEAT**: adopting the navigation plugin in features and packages.

## 1.0.0-beta.33

 - **FEAT**: adopting the navigation plugin in features and packages.

## 1.0.0-beta.32

 - **FEAT**: the router is now part of the Navigation Plugin.

## 1.0.0-beta.31

 - **FIX**: analysis errors.

## 1.0.0-beta.30

 - **FIX**: ensuring the list item index is set correctly for multiple levels of the numbered list.

## 1.0.0-beta.29

 - **FIX**: proper use of width and height and handling null ref and url at the same time.

## 1.0.0-beta.28

 - **FEAT**: added a route refresh action.

## 1.0.0-beta.27

 - **REFACTOR**: renamed rest of handlers to configs.
 - **REFACTOR**: renamed APIHandler => ApiConfiguration to be in sync with rest of the naming.
 - **REFACTOR**: The RouteTypeConfiguration class is removed from the vyuh_extension_content and moved to the vyuh_core content.
 - **REFACTOR**: renamed buildData => build for ApiHandler.
 - **REFACTOR**: navigation and default route layout.
 - **REFACTOR**: action now is a list of configurations instead of a single item.
 - **FIX**: adjusting the layout of the schemaType.
 - **FIX**: reverting to previous state of default route handling.
 - **FIX**: using the state.uri for the full path of the page.
 - **FIX**: analysis errors.
 - **FIX**: ensuring errors are properly shown in API Content handler.
 - **FIX**: analysis issues.
 - **FIX**: analysis issues.
 - **FEAT**: adding support for optional App Bar in the single item layout.
 - **FEAT**: adding AppBar to the Single Item Layout.
 - **FEAT**: refactor for deeper support of Sanity Images.
 - **FEAT**: adding conditional layouts for card, group and route. Rest can be added as needed.
 - **FEAT**: first cut of conditional layouts.
 - **FEAT**: adding delay to the boolean condition for simulated delays during testing.
 - **FEAT**: adding delay to the boolean condition for simulated delays during testing.
 - **FEAT**: showing details of the conditional route in an intermediate layout.
 - **FEAT**: added single item layout.
 - **FEAT**: added a new layout for route for a single item.
 - **FEAT**: changed the interface of MarkDefDescriptor to become more flexible with generating InlineSpan instead of just a TextSpan. This allows greater decorations to be attached to an annotation.
 - **FEAT**: refactored portable text to be more resilient.
 - **FEAT**: added the dialog route behavior and also modified the message when a cms route fails to load.
 - **FEAT**: added conditional action.

## 1.0.0-beta.26

 - **FEAT**: adding support for optional App Bar in the single item layout.

## 1.0.0-beta.25

 - **FEAT**: adding AppBar to the Single Item Layout.

## 1.0.0-beta.24

 - **FIX**: adjusting the layout of the schemaType.

## 1.0.0-beta.23

 - **FIX**: reverting to previous state of default route handling.

## 1.0.0-beta.22

 - **FIX**: using the state.uri for the full path of the page.

## 1.0.0-beta.21

 - **FIX**: analysis errors.

## 1.0.0-beta.20

 - **FIX**: ensuring errors are properly shown in API Content handler.

## 1.0.0-beta.19

 - **FEAT**: refactor for deeper support of Sanity Images.

## 1.0.0-beta.18

 - package updates

## 1.0.0-beta.17

 - **FEAT**: adding conditional layouts for card, group and route. Rest can be added as needed.
 - **FEAT**: first cut of conditional layouts.

## 1.0.0-beta.16

 - **REFACTOR**: renamed rest of handlers to configs.

## 1.0.0-beta.15

 - **REFACTOR**: renamed APIHandler => ApiConfiguration to be in sync with rest of the naming.

## 1.0.0-beta.14

 - **REFACTOR**: The RouteTypeConfiguration class is removed from the vyuh_extension_content and moved to the vyuh_core content.

## 1.0.0-beta.13

 - **REFACTOR**: renamed buildData => build for ApiHandler.

## 1.0.0-beta.12

 - **REFACTOR**: navigation and default route layout.
 - **REFACTOR**: action now is a list of configurations instead of a single item.
 - **FIX**: analysis issues.
 - **FIX**: analysis issues.
 - **FEAT**: adding delay to the boolean condition for simulated delays during testing.
 - **FEAT**: adding delay to the boolean condition for simulated delays during testing.
 - **FEAT**: showing details of the conditional route in an intermediate layout.
 - **FEAT**: added single item layout.
 - **FEAT**: added a new layout for route for a single item.
 - **FEAT**: changed the interface of MarkDefDescriptor to become more flexible with generating InlineSpan instead of just a TextSpan. This allows greater decorations to be attached to an annotation.
 - **FEAT**: refactored portable text to be more resilient.
 - **FEAT**: added the dialog route behavior and also modified the message when a cms route fails to load.
 - **FEAT**: added conditional action.

## 1.0.0-beta.11

 - **FEAT**: adding delay to the boolean condition for simulated delays during testing.

## 1.0.0-beta.10

 - **FEAT**: showing details of the conditional route in an intermediate layout.

## 1.0.0-beta.9

 - **REFACTOR**: navigation and default route layout.
 - **REFACTOR**: action now is a list of configurations instead of a single item.
 - **FIX**: analysis issues.
 - **FIX**: analysis issues.
 - **FEAT**: added single item layout.
 - **FEAT**: added a new layout for route for a single item.
 - **FEAT**: changed the interface of MarkDefDescriptor to become more flexible with generating InlineSpan instead of just a TextSpan. This allows greater decorations to be attached to an annotation.
 - **FEAT**: refactored portable text to be more resilient.
 - **FEAT**: added the dialog route behavior and also modified the message when a cms route fails to load.
 - **FEAT**: added conditional action.

## 1.0.0-beta.8

 - **FIX**: analysis issues.

## 1.0.0-beta.7

- **FEAT**: added single item layout.
  ([4b8aad2f](https://github.com/vyuh-tech/vyuh/commit/4b8aad2ff743511e9496b91015e8b1b850a4965c))

## 1.0.0-beta.6

- Updated interfaces for portable text

- **FEAT**: changed the interface of MarkDefDescriptor to become more flexible
  with generating InlineSpan instead of just a TextSpan. This allows greater
  decorations to be attached to an annotation.

## 1.0.0-beta.5

- Updating signatures based on changes to flutter_sanity_portable_text

- **FEAT**: refactored portable text to be more resilient.
  ([39db715f](https://github.com/vyuh-tech/vyuh/commit/39db715ff85032721b94c82176d7b8ebda384151))

## 1.0.0-beta.4

- **REFACTOR**: navigation and default route layout.
  ([7719a8c0](https://github.com/vyuh-tech/vyuh/commit/7719a8c029b9f346e6cf5ccaa343c8cdc8732666))
- **REFACTOR**: action now is a list of configurations instead of a single item.
  ([7cfb6a82](https://github.com/vyuh-tech/vyuh/commit/7cfb6a82d357716acfa92a6a57f5e6eff71172e0))
- **FEAT**: added the dialog route behavior and also modified the message when a
  cms route fails to load.
  ([4a5b705e](https://github.com/vyuh-tech/vyuh/commit/4a5b705e88992aadbec1b0cb629695b991163b2e))
- **FEAT**: added conditional action.
  ([546c5d3c](https://github.com/vyuh-tech/vyuh/commit/546c5d3c9b05dee08f628496b8b2420a66e94a48))

## 1.0.0-beta.3

- Updated description in pubspec

## 1.0.0-beta.1 - 1.0.0-beta.2

- Initial release.
- Contains the essential building blocks of any CMS-driven UI such as
  - Card
  - Group
  - Route
  - Conditional Route
  - Portable Text
  - Web View
  - Unknown
  - Divider
  - Actions such as navigation
- Has example for adding more widgets such as `Accordion`
