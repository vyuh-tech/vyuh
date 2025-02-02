# VyuhContentWidget Examples

This demonstrates various ways to use the `VyuhContentWidget` to fetch and
display content from your CMS.

Before you start using it, you have to set up the `VyuhContentBinding`, which is
a singleton that enables various services for fetching and displaying content.

```dart
final sanityProvider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '<PROJECT_ID>',
    dataset: '<DATASET>',
    perspective: Perspective.previewDrafts,
    useCdn: false,
    token: '<SANITY_TOKEN>',
  ),
  cacheDuration: const Duration(seconds: 5),
);

VyuhContentBinding.init(
  plugins: PluginDescriptor(
      // Required Content Plugin
      content: DefaultContentPlugin(provider: sanityProvider),

      // Optional Telemetry setup
      telemetry: TelemetryPlugin(providers: [ConsoleLoggerTelemetryProvider()]),
  ),
);
```

## Basic Usage with Documents

The simplest way to use VyuhContentWidget is with a `Document`:

```dart
VyuhContentWidget.fromDocument(
  identifier: 'my-document',
  builder: (context, document) {
    return Column(
      children: [
        if (document.title != null)
          Text(
            document.title!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (document.description != null)
          Text(document.description!),
        if (document.item != null)
          Expanded(
            child: VyuhContentBinding.content.buildContent(
              context,
              document.item!,
            ),
          ),
      ],
    );
  },
);
```

## Working with Custom Content Types

For custom content types, use the generic constructor:

```dart
// Define your content model
@JsonSerializable()
final class Product extends ContentItem {
  static const schemaName = 'product';

  final String title;
  final String description;
  final double price;
  final String category;
  final ImageReference? image;

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.image,
    super.layout,
  }) : super(schemaType: schemaName);

  factory Product.fromJson(Map<String, dynamic> json) =>
    _$ProductFromJson(json);
}

// Use it with VyuhContentWidget
VyuhContentWidget<Product>(
  query: '*[_type == "product" && category == $category]',
  queryParams: {'category': 'electronics'},
  fromJson: Product.fromJson,
  builder: (context, product) {
    return Card(
      child: Column(
        children: [
          if (product.image != null)
            ContentImage(reference: product.image!),
          ListTile(
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  },
);
```

## Working with Lists

To display a list of items:

```dart
VyuhContentWidget<Product>(
  query: '*[_type == "product"]',
  fromJson: Product.fromJson,
  listBuilder: (context, products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: product.image != null
            ? ContentImage(
                reference: product.image!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )
            : null,
          title: Text(product.title),
          subtitle: Text(product.description),
          trailing: Text('\$${product.price.toStringAsFixed(2)}'),
        );
      },
    );
  },
);
```

## Using Query Parameters

You can use query parameters to make your queries dynamic:

```dart
VyuhContentWidget<Article>(
  query: '''*[_type == "article" &&
    publishDate >= $startDate &&
    publishDate <= $endDate
  ] | order(publishDate desc)''',
  queryParams: {
    'startDate': '2024-01-01',
    'endDate': '2024-12-31',
  },
  fromJson: Article.fromJson,
  listBuilder: (context, articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleCard(article: article);
      },
    );
  },
);
```

## Error Handling and Loading States

The widget automatically handles loading and error states, but you can customize
them with `VyuhContentBinding`:

```dart
void main() async {
  VyuhContentBinding.init(
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(provider: sanityProvider),
      telemetry: TelemetryPlugin(providers: [ConsoleLoggerTelemetryProvider()]),
    ),
    widgetBuilder: PlatformWidgetBuilder.system.copyWith(
      contentLoader: (_) => const CircularProgressIndicator(),
      errorView: (_, {required String title}) => ErrorView(title: title),
    ),
  );

  runApp(const MyApp());
}

```
