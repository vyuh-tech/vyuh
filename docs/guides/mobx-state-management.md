---
title: State Management with MobX
description: Reactive state management patterns for Vyuh features
---

# State Management with MobX

[MobX](https://pub.dev/packages/mobx) is a transparent reactive state management
library that makes it straightforward to connect your application state to the
UI. The Vyuh Framework uses MobX internally (via `vyuh_core`'s dependency on
`mobx`) and recommends it as the default approach for managing state within
features.

::: info Not mandatory
While MobX is the recommended default, Vyuh does not enforce a specific state
management choice for your features. You are free to use Riverpod, Bloc,
Provider, or any other approach that fits your needs. MobX is simply what the
framework itself uses and what integrates most naturally.
:::

## Core Concepts

MobX is built around three core concepts that work together to create a reactive
data flow:

1. **Observables** -- the reactive state that drives your UI
2. **Actions** -- methods that mutate the observable state
3. **Reactions** -- side effects that run automatically when observables change
   (the `Observer` widget is the most common reaction in Flutter)

The data flow is unidirectional: **Actions** modify **Observables**, which
automatically notify **Reactions** (including UI rebuilds via `Observer`).

## Observables

Observables are the reactive state values that MobX tracks. When an observable
changes, any `Observer` widget reading it rebuilds automatically.

```dart
import 'package:mobx/mobx.dart';

// Simple observable using the .obs() extension
final counter = 0.obs();

// Observable class with a store
class ShopStore {
  final products = ObservableList<Product>();
  final isLoading = false.obs();
  final selectedCategory = ''.obs();
}
```

You can also define **computed values** that derive from other observables. These
are recalculated automatically when their dependencies change:

```dart
class CartStore {
  final items = ObservableList<CartItem>();

  late final itemCount = Computed(() => items.length);
  late final totalPrice = Computed(
    () => items.fold(0.0, (sum, item) => sum + item.price * item.quantity),
  );
}
```

## Actions

Actions are the only way to modify observable state in MobX. Wrapping mutations
in actions ensures that all changes are batched and reactions fire only once
after the action completes.

```dart
// Inline action
runInAction(() {
  counter.value++;
});

// In a store class
class ShopStore {
  final products = ObservableList<Product>();
  final isLoading = false.obs();

  late final fetchProducts = Action(_fetchProducts);

  Future<void> _fetchProducts() async {
    isLoading.value = true;
    try {
      final result = await api.getProducts();
      products.clear();
      products.addAll(result);
    } finally {
      isLoading.value = false;
    }
  }
}
```

::: tip
For simple mutations like incrementing a counter or toggling a boolean,
`runInAction` is convenient. For more complex operations, defining named actions
in your store keeps the code organized and testable.
:::

## Observer Widget

The `Observer` widget from `flutter_mobx` is a reaction that rebuilds whenever
any observable read inside its `builder` changes. There is no need to call
`setState` or manually subscribe to streams.

```dart
import 'package:flutter_mobx/flutter_mobx.dart';

// Simple observation
Observer(
  builder: (_) => Text('Count: ${counter.value}'),
),

// Conditional rendering
Observer(
  builder: (_) {
    if (store.isLoading.value) {
      return const CircularProgressIndicator();
    }
    return ProductList(products: store.products);
  },
),
```

Only the widgets wrapped in `Observer` rebuild when the observables they read
change. The rest of the widget tree remains untouched. This granular
reactivity is one of the key advantages of MobX.

## Registering a Store with Vyuh's DI

In a Vyuh application, you typically create a store class for each feature and
register it on the DI container during feature initialization. This makes the
store accessible anywhere in the feature's widget tree.

```dart
final feature = FeatureDescriptor(
  name: 'shop',
  title: 'Shopping',
  init: () async {
    vyuh.di.register(ShopStore());
  },
  dispose: () async {
    // Clean up if needed
  },
  // ...
);
```

From any widget within the feature, retrieve the store via `vyuh.di`:

```dart
final store = vyuh.di.get<ShopStore>();
```

::: tip Scoped DI
For state that should only live as long as a specific route, consider using
[Scoped DI](/guides/scoped-di) instead of the global container. This ties
the store's lifetime to the route, ensuring automatic cleanup when the user
navigates away.
:::

## Complete Feature Store Example

Here is a complete example of a feature store that manages a list of products
with loading, filtering, and a computed value:

```dart
import 'package:mobx/mobx.dart';

class ProductStore {
  final _api = vyuh.di.get<ProductApiClient>();

  // Observables
  final products = ObservableList<Product>();
  final isLoading = false.obs();
  final errorMessage = Observable<String?>(null);
  final selectedCategory = Observable<String?>(null);

  // Computed values
  late final filteredProducts = Computed(() {
    final category = selectedCategory.value;
    if (category == null || category.isEmpty) {
      return products.toList();
    }
    return products.where((p) => p.category == category).toList();
  });

  late final productCount = Computed(() => filteredProducts.value.length);

  // Actions
  late final loadProducts = Action(_loadProducts);
  late final selectCategory = Action(_selectCategory);

  Future<void> _loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _api.fetchProducts();
      products.clear();
      products.addAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to load products.';
    } finally {
      isLoading.value = false;
    }
  }

  void _selectCategory(List<dynamic> args) {
    selectedCategory.value = args.first as String?;
  }
}
```

Register it in the feature descriptor:

```dart
final feature = FeatureDescriptor(
  name: 'shop',
  title: 'Shopping',
  icon: Icons.shopping_cart,
  init: () async {
    vyuh.di.register(ProductApiClient());
    vyuh.di.register(ProductStore());
  },
  routes: () => [
    GoRoute(
      path: '/shop',
      builder: (_, _) => const ProductListView(),
    ),
  ],
);
```

And use it in a widget:

```dart
class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late final store = vyuh.di.get<ProductStore>();

  @override
  void initState() {
    super.initState();
    store.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = store.errorMessage.value;
        if (error != null) {
          return Center(child: Text(error));
        }

        final items = store.filteredProducts.value;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ProductTile(product: items[index]);
          },
        );
      },
    );
  }
}
```

## When MobX Works Well

MobX is a strong fit for the following scenarios within Vyuh features:

- **Reactive UI updates** -- Observables and `Observer` widgets handle UI
  rebuilds automatically, without manual `setState` or stream subscriptions.
- **Complex interdependent state** -- When multiple pieces of state depend on
  each other, MobX's transparent tracking keeps everything in sync.
- **Computed values** -- Derived state (like filtered lists, totals, or
  validation results) is expressed declaratively and updated automatically.
- **Feature-scoped state via DI** -- Stores registered on `vyuh.di` (or scoped
  via `context.di`) provide clean, testable state management at the feature or
  route level.

## Alternatives

If MobX is not the right fit for your team or feature, other state management
solutions work with Vyuh:

- **Riverpod** -- works well for features that prefer a provider-based approach.
- **Bloc** -- a solid choice if you want explicit event-driven state transitions.
- **Provider** -- the simplest option for lightweight state needs.

Vyuh does not enforce a state management choice for features. The framework's
own internals use MobX, but your feature code can use whatever approach you
prefer. Stores registered on the DI container are plain Dart objects, so they
can use any state management library internally.

## Summary

MobX provides transparent reactive state management that integrates naturally
with the Vyuh Framework. By combining observables, actions, and the `Observer`
widget, you get automatic UI updates driven by state changes. Registering stores
on Vyuh's DI container keeps state organized at the feature level, and scoped DI
lets you tie store lifetimes to specific routes when needed.
