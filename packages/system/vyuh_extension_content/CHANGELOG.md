## 1.21.1

 - **FIX**: format fixes in readme.

## 1.21.0

 - **FEAT**: moving to a new package: vyuh_content_widget.
 - **FEAT**: adapted some features to be compatible with the VyuhContentWidget.

## 1.20.3

 - **FIX**: updating api docs.

## 1.20.2

 - **FIX**: readme updates.

## 1.20.1

 - **FIX**: readme updates to make it more consistent.

## 1.20.0

 - **FEAT**: adding support for previews of items ..

## 1.19.0

 - **FEAT**: added lineage of features for all typedescriptors and content builders, added the Content Playground for the developer tool and fixed a bunch of analysis issues.

## 1.18.0

 - **FEAT**: added lineage of features for all typedescriptors and content builders.

## 1.17.0

 - **FEAT**: tracking layouts per ContentBuilder.

## 1.16.6

 - **FIX**: typo fixes in api docs.

## 1.16.5

 - **FIX**: added a simpler way to create a ContentDescriptor for a ContentItem without the need to extend ContentDescriptor.

## 1.16.4

 - **FIX**: simplified the use of `isRegistered<T>` method.

## 1.16.3

 - **FIX**: more readme updates to include emojis...added readme for vyuh_cache as well.

## 1.16.2

 - **FIX**: readme updates to fix some apis which were incorrect.

## 1.16.1

 - **FIX**: readme updates to vyuh_extension_content.

## 1.16.0

 - **FEAT**: added the ability to supply a layout when calling buildContent() of the ContentPlugin.

## 1.15.2

 - **FIX**: updated the error message when a content builder is not found.

## 1.15.1

 - **FIX**: updating the method name for setting default layouts.

## 1.15.0

 - **FEAT**: added support to switch out the default layouts for any content item. This is useful when using your Design System that can have unique layouts for the default content items like Card, Group, Form, etc.

## 1.14.2

 - **FIX**: using a microtask inside dispose.

## 1.14.1

 - **FIX**: updated the navigation action to not invoke the lifecycleHandler for Route. Fixed the DI to reset DI on refresh and when loading the route.

## 1.14.0

 - **FEAT**: introduced Scoped DI at the Route level that allows configuring DI at the route level itself. This avoid polluting the global DI scope. Also cleaned up some types that are no longer necessary.

## 1.13.1

 - **FIX**: making the extensions async for init and dispose.

## 1.13.0

 - **FEAT**: adding a Client parameter to HttpNetworkPlugin, more robust init of ExtensionBuilder even when there are no ExtensionDescriptors, extension method to restart() the platform, simplified runApp, error checking when a modifier build breaks, a vyuh_test package, tentative tests for vyuh_core and vyuh_extension_content (WIP).

## 1.12.0

 - **FEAT**: Breaking change. Split up the AnalyticsPlugin into a focused TelemetryPlugin that only does telemetry operations like error reporting and tracing. Analytics is now focused only on User level analytics.

## 1.11.0

 - **FEAT**: first cut of the ability to specify modifiers for content and category.

## 1.10.0

 - **FEAT**: added support for content modifiers that are configurable from the CMS.

## 1.9.3

 - **FIX**: added an exception handler for cases when a layout can throw an exception. This shows an error_view with the exception.

## 1.9.2

 - **FIX**: analysis fixes.

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
