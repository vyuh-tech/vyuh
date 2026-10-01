import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;

void main() {
  vc.runApp(
    initialLocation: '/bookmarks',
    plugins: vc.PluginDescriptor(others: [MemoryBookmarksPlugin()]),
    platformWidgetBuilder: platformWidgets,
    features: () => [
      bookmarksFeature(insightsPath: '/insights'),
      insightsFeature(bookmarksPath: '/bookmarks'),
    ],
  );
}

// The app customizes the Material UI root used by these feature widgets.
final platformWidgets = vc.PlatformWidgetBuilder.system.copyWith(
  appBuilder: (_, platform) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: platform.router.instance,
  ),
);

// Shared contract: features depend on this, while the app selects an adapter.
abstract class BookmarksPlugin extends vc.Plugin {
  BookmarksPlugin()
    : super(name: 'example.bookmarks', title: 'Shared bookmarks');

  ValueListenable<List<String>> get entries;
  void add(String title);
  void remove(String title);
}

// This adapter retains data only for the active platform lifecycle.
final class MemoryBookmarksPlugin extends BookmarksPlugin
    with vc.InitOncePlugin {
  late ValueNotifier<List<String>> _entries;

  @override
  ValueListenable<List<String>> get entries => _entries;

  @override
  Future<void> initOnce() async {
    _entries = ValueNotifier(const []);
  }

  @override
  void add(String title) {
    final value = title.trim();
    if (value.isEmpty || _entries.value.contains(value)) return;
    _entries.value = List.unmodifiable([..._entries.value, value]);
  }

  @override
  void remove(String title) {
    _entries.value = List.unmodifiable(
      _entries.value.where((entry) => entry != title),
    );
  }

  @override
  Future<void> disposeOnce() async {
    _entries.dispose();
  }
}

vc.FeatureDescriptor bookmarksFeature({String? insightsPath}) =>
    vc.FeatureDescriptor(
      name: 'bookmarks',
      title: 'Bookmarks',
      routes: () => [
        GoRoute(
          path: '/bookmarks',
          builder: (_, _) => BookmarksScreen(insightsPath: insightsPath),
        ),
      ],
    );

vc.FeatureDescriptor insightsFeature({String? bookmarksPath}) =>
    vc.FeatureDescriptor(
      name: 'insights',
      title: 'Reading insights',
      routes: () => [
        GoRoute(
          path: '/insights',
          builder: (_, _) => InsightsScreen(bookmarksPath: bookmarksPath),
        ),
      ],
    );

class BookmarksScreen extends StatefulWidget {
  final String? insightsPath;
  const BookmarksScreen({super.key, this.insightsPath});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final _title = TextEditingController();
  late final BookmarksPlugin _bookmarks = vc.vyuh.getPlugin<BookmarksPlugin>()!;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Bookmarks'),
      actions: [
        if (widget.insightsPath != null)
          TextButton(
            onPressed: () => context.go(widget.insightsPath!),
            child: const Text('Insights'),
          ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Bookmark title'),
          ),
          FilledButton(
            onPressed: () {
              _bookmarks.add(_title.text);
              _title.clear();
            },
            child: const Text('Save bookmark'),
          ),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _bookmarks.entries,
              builder: (_, entries, _) => entries.isEmpty
                  ? const Center(child: Text('Save your first bookmark.'))
                  : ListView(
                      children: entries
                          .map(
                            (title) => ListTile(
                              title: Text(title),
                              trailing: IconButton(
                                tooltip: 'Remove bookmark',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _bookmarks.remove(title),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}

class InsightsScreen extends StatelessWidget {
  final String? bookmarksPath;
  const InsightsScreen({super.key, this.bookmarksPath});

  @override
  Widget build(BuildContext context) {
    final bookmarks = vc.vyuh.getPlugin<BookmarksPlugin>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading insights'),
        actions: [
          if (bookmarksPath != null)
            TextButton(
              onPressed: () => context.go(bookmarksPath!),
              child: const Text('Bookmarks'),
            ),
        ],
      ),
      body: Center(
        child: ValueListenableBuilder<List<String>>(
          valueListenable: bookmarks.entries,
          builder: (_, entries, _) => Text('${entries.length} saved bookmarks'),
        ),
      ),
    );
  }
}
