---
title: Tutorial
description: Build a complete Vyuh feature from scratch
---

# Tutorial

In this hands-on tutorial you will build a **Bookmarks** feature -- a reading
list where users can save, view, and remove favorite links. Along the way you
will use `FeatureDescriptor`,
routing with `GoRoute`, reactive state management with MobX, and the built-in
dependency injection system.

## Prerequisites

Before you begin, make sure you have:

- **Flutter** installed and working (`flutter doctor` passes)
- Basic **Dart** knowledge (classes, async/await, generics)
- Familiarity with the [Concepts](/concepts/) section, especially
  [Features & Plugins](/concepts/features-and-plugins)

## What You'll Build

A self-contained Bookmarks feature that lets users save and manage a reading
list. The tutorial covers:

1. Creating a `FeatureDescriptor`
2. Setting up client-side routes with `GoRoute`
3. Managing reactive state with MobX
4. Using Vyuh's DI system to share a store across widgets
5. Registering the feature in a Vyuh application

The result is a single-feature app you can run on any device or simulator.

---

## Step 1: Create the Project

Start by creating a new Flutter project and adding the required Vyuh packages.

```shell
flutter create bookmarks_app
cd bookmarks_app
```

Add the framework packages:

```shell
flutter pub add vyuh_core go_router mobx flutter_mobx
```

| Package | Purpose |
|---|---|
| `vyuh_core` | Core framework APIs (`FeatureDescriptor`, `runApp`, DI) |
| `go_router` | Declarative routing |
| `mobx` | Reactive state management |
| `flutter_mobx` | `Observer` widget that rebuilds on state changes |

---

## Step 2: Define the Data Model

Create a file `lib/bookmark.dart` with a simple data class to represent a saved
link.

```dart
// lib/bookmark.dart

class Bookmark {
  final String id;
  final String title;
  final String url;
  final DateTime addedAt;

  Bookmark({
    required this.id,
    required this.title,
    required this.url,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}
```

Nothing Vyuh-specific here -- just a plain Dart class. The `id` field will be
used to identify bookmarks when removing them.

---

## Step 3: Create the Store

Create `lib/bookmark_store.dart`. This is where the application state lives,
managed with MobX observables.

```dart
// lib/bookmark_store.dart

import 'package:mobx/mobx.dart';
import 'bookmark.dart';

class BookmarkStore {
  int _nextId = 0;
  /// The list of saved bookmarks. Because it is an [ObservableList],
  /// any [Observer] widget reading it will rebuild automatically
  /// when items are added or removed.
  final bookmarks = ObservableList<Bookmark>();

  /// A computed value that derives the count from the list length.
  /// Computed values are recalculated only when their dependencies change.
  late final bookmarkCount = Computed(() => bookmarks.length);

  /// Adds a new bookmark. Wrapping the mutation in [runInAction]
  /// ensures MobX batches the change and notifies observers once.
  void addBookmark(String title, String url) {
    runInAction(() {
      bookmarks.add(Bookmark(
        id: (++_nextId).toString(),
        title: title,
        url: url,
      ));
    });
  }

  /// Removes the bookmark with the given [id].
  void removeBookmark(String id) {
    runInAction(() {
      bookmarks.removeWhere((b) => b.id == id);
    });
  }
}
```

### Key MobX concepts used here

- **`ObservableList`** -- a reactive list. When its contents change, any
  `Observer` widget that reads it rebuilds automatically.
- **`Computed`** -- a derived value that recalculates only when its upstream
  observables change. Declared with `late final` so it is initialized once.
- **`runInAction`** -- wraps state mutations so MobX can batch changes and fire
  reactions after the action completes.

::: info Want to learn more about MobX?
See the full [State Management with MobX](/guides/mobx-state-management)
guide for advanced patterns like `Action`, async actions, and error handling.
:::

---

## Step 4: Build the UI

Create `lib/bookmark_list_screen.dart`. This is the main screen of the feature.

```dart
// lib/bookmark_list_screen.dart

import 'package:material_ui/material_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'bookmark_store.dart';

class BookmarkListScreen extends StatefulWidget {
  const BookmarkListScreen({super.key});

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  /// Retrieve the store from the global DI container.
  /// It was registered during feature init (see Step 5).
  late final store = vyuh.di.get<BookmarkStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          // Show the bookmark count in the app bar
          Observer(
            builder: (_) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${store.bookmarkCount.value} saved'),
              ),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.bookmarks.isEmpty) {
            return const Center(
              child: Text(
                'No bookmarks yet.\nTap + to add one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: store.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = store.bookmarks[index];

              return ListTile(
                leading: const Icon(Icons.bookmark),
                title: Text(bookmark.title),
                subtitle: Text(bookmark.url),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => store.removeBookmark(bookmark.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AddBookmarkDialog(
        onAdd: (title, url) => store.addBookmark(title, url),
      ),
    );
  }
}
```

### The Add Bookmark Dialog

Add the following dialog widget in the same file (or in its own file if you
prefer).

```dart
// (continued in lib/bookmark_list_screen.dart)

class _AddBookmarkDialog extends StatefulWidget {
  final void Function(String title, String url) onAdd;

  const _AddBookmarkDialog({required this.onAdd});

  @override
  State<_AddBookmarkDialog> createState() => _AddBookmarkDialogState();
}

class _AddBookmarkDialogState extends State<_AddBookmarkDialog> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Bookmark'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: 'URL'),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final url = _urlController.text.trim();

            if (title.isNotEmpty && url.isNotEmpty) {
              widget.onAdd(title, url);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

::: tip
The `Observer` widget is the only part of the widget tree that rebuilds when
observables change. The `Scaffold`, `AppBar`, and `FloatingActionButton` are
**not** re-built -- only the list and the count badge react to state changes.
This is one of the key advantages of MobX's granular reactivity.
:::

---

## Step 5: Define the Feature

Create `lib/feature.dart`. The `FeatureDescriptor` ties the store, routes, and
metadata together into a self-contained unit.

```dart
// lib/feature.dart

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'bookmark_list_screen.dart';
import 'bookmark_store.dart';

final feature = FeatureDescriptor(
  name: 'bookmarks',
  title: 'Bookmarks',
  description: 'A reading list feature for saving favorite links',
  icon: Icons.bookmark,
  init: () async {
    // Register the store on the global DI container so any widget
    // in the app can retrieve it with vyuh.di.get<BookmarkStore>().
    vyuh.di.register(BookmarkStore());
  },
  dispose: () async {
    vyuh.di.unregister<BookmarkStore>();
  },
  routes: () async => [
    GoRoute(
      path: '/bookmarks',
      builder: (_, _) => const BookmarkListScreen(),
    ),
  ],
);
```

Two things happen here:

1. **`init`** registers the `BookmarkStore` on Vyuh's DI container. This runs
   once during the framework's bootstrap phase, before any route is rendered.
2. **`routes`** exposes a single `/bookmarks` route that renders the list
   screen. This route renders an ordinary Flutter screen.


---

## Step 6: Wire It Into the App

Replace the contents of `lib/main.dart` with the following:

```dart
// lib/main.dart

import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;

import 'feature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  vc.runApp(
    initialLocation: '/bookmarks',
    platformWidgetBuilder: vc.PlatformWidgetBuilder.system.copyWith(
      appBuilder: (_, platform) => MaterialApp.router(
        routerConfig: platform.router.instance,
      ),
    ),
    features: () => [
      feature,
    ],
  );
}
```

- **`initialLocation`** tells the router which route to display at startup.
- **`features`** returns the app's selected descriptors. This app includes the
  Bookmarks feature; additional features contribute their own routes and behavior.

::: warning
Make sure `initialLocation` matches a path declared in one of your features.
If no feature owns that path, you will see a routing error at launch.
:::

---

## Step 7: Run the App

Run the app on your preferred device or simulator:

```shell
flutter run
```

After the framework finishes initializing, you should see:

1. An **app bar** with the title "Bookmarks" and a count badge showing "0 saved".
2. An **empty state** message in the center of the screen.
3. A **floating action button** (+) in the bottom-right corner.

Tap the FAB to open the add dialog. Enter a title and URL, then tap **Add**.
The bookmark appears in the list instantly -- no manual refresh needed, thanks
to MobX reactivity. Tap the delete icon on any bookmark to remove it.

You now have a fully functional Vyuh feature running as a standalone app.

---

## Recap

Here is a summary of the files you created and what each one does:

| File | Purpose |
|---|---|
| `lib/bookmark.dart` | Data model |
| `lib/bookmark_store.dart` | Reactive state (MobX store) |
| `lib/bookmark_list_screen.dart` | UI (list screen + add dialog) |
| `lib/feature.dart` | `FeatureDescriptor` (DI setup + routes) |
| `lib/main.dart` | App entry point (`vc.runApp`) |

The flow is: `main.dart` boots the framework with your feature list. Each
feature's `init` runs (registering the store on DI), then `routes` are
collected and handed to GoRouter. When the user navigates to `/bookmarks`, the
`BookmarkListScreen` retrieves the store from DI and renders the list
reactively.

---

## What's Next

Now that you have a working feature, here are several directions to take it
further:

- **Compose another feature** -- Follow [Compose features](/intro/compose-features)
  to share one capability between two ordinary Flutter features.

- **Manage service lifetime** -- This store lives for the feature lifecycle and
  unregisters during feature disposal. For state that belongs to a screen,
  create and dispose it with the widget lifecycle. See [Dependency injection](/guides/scoped-di).

- **Explore more examples** -- Browse complete sample apps in the
  [Examples](/examples/) section.
