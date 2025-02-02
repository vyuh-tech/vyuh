<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Content Widget</h1>
  <p align="center">Build Content-driven UIs with Vyuh and Sanity.io</p>
  <p align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </p>
</p>

[![vyuh_content_widget](https://img.shields.io/pub/v/vyuh_content_widget.svg?label=vyuh_content_widget&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_content_widget)

# Vyuh Content Widget

A powerful Flutter widget for building content-driven UIs with Vyuh and a CMS
provider like Sanity.io. By default, we support Sanity.io as a CMS. However, you
are free to extend this package to support other CMS providers.

## Features

- Easy content fetching with GROQ queries (or queries as per your CMS provider)
- Support for single document and document list views
- Type-safe content models
- Customizable layouts
- Built-in loading and error states

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  vyuh_content_widget: ^latest_version
```

## Getting Started

1. Initialize the content binding in your app:

```dart
void main() {
  VyuhContentBinding.init(
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(provider: sanityProvider),
    ),
  );

  runApp(const MyApp());
}
```

2. Use the widget to display content:

```dart
// Fetch a single document by identifier
VyuhContentWidget.fromDocument(
  identifier: 'document-id',
)

// Fetch content using a GROQ query
VyuhContentWidget<Conference>(
  query: '*[_type == "conference"][0]',
  fromJson: Conference.fromJson,
  builder: (context, content) {
    return Text(content.title);
  },
)

// Fetch a list of documents
VyuhContentWidget<Conference>(
  query: '*[_type == "conference"]',
  fromJson: Conference.fromJson,
  listBuilder: (context, items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.description),
        );
      },
    );
  },
)
```

## Usage Examples

### Single Document View

```dart
VyuhContentWidget<Article>(
  query: '*[_type == "article" && slug.current == $slug][0]',
  queryParams: {'slug': 'my-article'},
  fromJson: Article.fromJson,
  builder: (context, article) {
    return Column(
      children: [
        Text(article.title, style: Theme.of(context).textTheme.headlineMedium),
        Text(article.content),
      ],
    );
  },
)
```

### Document List View

```dart
VyuhContentWidget<Product>(
  query: '*[_type == "product"] | order(price asc)',
  fromJson: Product.fromJson,
  listBuilder: (context, products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  },
)
```

## API Reference

### VyuhContentWidget

The main widget for displaying content from your CMS.

#### Constructor Parameters

- `query` (required): GROQ query string
- `fromJson` (required): JSON converter function for your content type
- `queryParams`: Map of parameters for the GROQ query
- `builder`: Builder function for single document view
- `listBuilder`: Builder function for document list view

Note: You must provide exactly one of `builder` or `listBuilder`.

#### Static Methods

- `fromDocument`: Convenience constructor for fetching a single document by ID

### VyuhContentBinding

Used to initialize the content widget system.

#### Methods

- `init`: Initialize the content binding with required plugins and
  configurations

## Best Practices

1. **Type Safety**

   - Always use strongly-typed content models
   - Implement proper `fromJson` converters
   - Use nullable types appropriately

2. **Error Handling**

   - The widget handles loading and error states automatically
   - Customize error views through `PlatformWidgetBuilder`

3. **Performance**
   - Use appropriate GROQ queries to fetch only needed fields
   - Implement pagination for large lists
   - Cache content when appropriate

## Contributing

Contributions are welcome! Please read our contributing guidelines before
submitting pull requests.

## License

This package is licensed under the MIT License. See the LICENSE file for
details.

## Additional Information

### 📚 Documentation

For detailed documentation and guides, visit:

- [Vyuh Documentation](https://docs.vyuh.tech)
- [API Reference](https://pub.dev/documentation/vyuh_content_widget/latest/)

### 🔗 Links

- [Website](https://vyuh.tech)
- [Documentation](https://docs.vyuh.tech)

---

<p align="center">
  Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a>
</p>
