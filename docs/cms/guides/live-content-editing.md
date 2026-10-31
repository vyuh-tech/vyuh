---
title: Live Content Editing
description: Enable real-time content updates from Sanity in your Vyuh app
---

# Live Content Editing

One of the most powerful features of Vyuh is the ability to see content changes
in real-time without having to restart your app or manually refresh. This
feature, called Live Content Editing, significantly improves your development
workflow.

## How to Enable Live Routes

Enabling Live Content Editing is as simple as setting the `useLiveRoute` flag to
`true` on the `DefaultContentPlugin`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  vc.runApp(
    initialLocation: '/blog',
    features: () => [
      system.feature,
      developer.feature,
      blog.feature,
    ],
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(
        useLiveRoute: true,
        provider: SanityContentProvider(
          SanityClient(
            SanityConfig(
              dataset: 'your_dataset',
              projectId: 'your_project_id',
              token: 'your_token',
              perspective: Perspective.previewDrafts,
              useCdn: false,
            ),
          ),
        ),
      ),
    ),
  );
}
```

## Important Configuration Notes

For Live Content Editing to work properly, make sure to:

1. Set `useLiveRoute: true` on the `DefaultContentPlugin`
2. Set `perspective: Perspective.previewDrafts` to see draft content before
   publishing
3. Set `useCdn: false` as we want to work with draft content
4. Provide a valid Sanity token with appropriate permissions. Without a valid
   token this will fail.

## How It Works

Behind the scenes, Vyuh leverages Sanity's Live Content API to establish a
real-time connection between your app and the CMS. When content changes are made
in the Sanity Studio, the API sends those changes to your app, which then
updates the UI accordingly.

This works in both development and production environments. In production, you
would typically need to publish your content before it appears on customer
devices, unless you specifically configure your app to show draft content.

::: tip Development vs. Production
In development, it is useful to see draft content immediately using
`Perspective.previewDrafts`.

For production apps, you might want to switch to `Perspective.published` to
ensure only published content is visible to users.
:::

## Manual Route Refreshing

In addition to live updates, Vyuh also provides a way to manually refresh routes
through the `allowRouteRefresh` parameter. This is useful when you want to give
users the ability to pull-to-refresh content or when you need a refresh button
in your UI.

```dart
plugins: PluginDescriptor(
  content: DefaultContentPlugin(
    useLiveRoute: true,
    allowRouteRefresh: true,
    provider: SanityContentProvider(
      SanityClient(
        SanityConfig(
          dataset: 'your_dataset',
          projectId: 'your_project_id',
          token: 'your_token',
          perspective: Perspective.previewDrafts,
          useCdn: false,
        ),
      ),
    ),
  ),
),
```

This parameter works with both live routes and static routes, giving you
flexibility in how content updates are handled in your application.

::: info
Even when `useLiveRoute` is enabled, manual refreshing can still be useful in
certain scenarios, such as when you want to force an immediate refresh rather
than waiting for the next live update.
:::

## Summary

Live Content Editing in Vyuh enables real-time synchronization between your
Sanity CMS and Flutter app. By configuring the `SanityContentProvider` with
draft perspective and the `DefaultContentPlugin` with live routes, you get an
instant feedback loop that dramatically improves the content authoring
experience. Combined with manual route refreshing, you have full control over
how and when content updates appear in your application.
