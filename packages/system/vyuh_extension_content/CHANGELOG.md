## 1.9.1

 - **FIX**: simplifying the setup of extension builders removed the specialized logic that existed earlier for the Content Plugin.

## 1.9.0

 - **FEAT**: updated the refresh button for routes and adjusting for the change in the BuiltContentSchemaBuilder.

## 1.8.3

 - **FIX**: handle case when an ActionConfiguration is created manually instead of coming from the CMS.

## 1.8.2

 - **FIX**: make the isAwaiting flag work across actions.

## 1.8.1

 - **FIX**: add the layouts parameter to ContentDescriptor and the layout parameter to ContentItem as mandatory.

## 1.8.0

 - **FEAT**: added document list view.

## 1.6.0

 - **FEAT**: added a BuildContext parameter to all loaders and error views. This helps in using the Theme from the context.

## 1.5.0

 - **FEAT**: adding delay action.

## 1.4.3

 - Update a dependency to the latest release.

## 1.4.2

 - Update a dependency to the latest release.

## 1.4.1

 - **REFACTOR**: deps upgrade.

## 1.4.0

 - **FEAT**: ContentBuilder is no longer abstract, Card layout adjustments, AppBar can be toggled in default route layout, grid layout can now have single column, minor fixes in navigation action.
 - **FEAT**: adding the FSL license at the top level.

## 1.3.0

 - **FEAT**: switching to the FSL license with future MIT license after 2 years.

## 1.2.2

 - Update a dependency to the latest release.

## 1.2.1

 - Update a dependency to the latest release.

## 1.2.0

 - **FEAT**: expanding the set of actions to include navigation, theme switch, opening dialogs, show/hide snackbars.

## 1.1.0

 - **FEAT**: refactoring services and introducing some new conditions for screen-size, theme-mode, platform, user-auth.

## 1.0.1

 - **REFACTOR**: version updates of packages.

## 1.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 1.0.0-beta.6

 - **REFACTOR**: cleanups.

## 1.0.0-beta.5

 - **FEAT**: first cut of conditional layouts.

## 1.0.0-beta.4

 - **REFACTOR**: The RouteTypeConfiguration class is removed from the vyuh_extension_content and moved to the vyuh_core content.

## 1.0.0-beta.3

 - **FIX**: ensured the extension builders are also disposed and init-ed correctly.

## 1.0.0-beta.2

- **REFACTOR**: action now is a list of configurations instead of a single item.
  ([7cfb6a82](https://github.com/vyuh-tech/vyuh/commit/7cfb6a82d357716acfa92a6a57f5e6eff71172e0))
- **REFACTOR**: moving packages into the system folder.
  ([e1b3a744](https://github.com/vyuh-tech/vyuh/commit/e1b3a744e16d2c464ce8128a6782d47f85f8e5ed))
- **FEAT**: added the dialog route behavior and also modified the message when a
  cms route fails to load.
  ([4a5b705e](https://github.com/vyuh-tech/vyuh/commit/4a5b705e88992aadbec1b0cb629695b991163b2e))

## 1.0.0-beta.1

- Initial release.
- Exposes the extension for adding a CMS integration
