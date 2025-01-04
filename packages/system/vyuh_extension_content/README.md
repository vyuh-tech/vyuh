# Vyuh Extension for Content

An extension for integrating CMS. This package provides the core building blocks
that can be leveraged by specific CMS integrations. Works in conjunction with the
`ContentPlugin` from the `vyuh_core` package to enable content management features
in your application.

## Features

### Content Types

- **ContentItem**: Base class for all content types
  - Schema type identification
  - JSON serialization support
  - Content builder registration

- **ImageReference**: Reference to CMS-managed images
  - URL and dimensions
  - Asset metadata
  - Hot spot and crop information

- **PortableText**: Rich text content format
  - Custom mark definitions
  - Block styling
  - Embedded content

### Content Building

- **ContentBuilder**: Factory for creating content instances
  - Type-safe content creation
  - Layout configuration
  - Content validation

- **ContentDescriptor**: Content type registration
  - Schema type definitions
  - Content builders
  - Layout descriptors

### Layout System

- **LayoutConfiguration**: Base class for content layouts
  - Custom layout implementations
  - Content-specific rendering
  - Layout type descriptors

### Content Extensions

- **ContentExtension**: Framework for extending content functionality
  - Custom content types
  - Layout registration
  - Content modifiers

- **ContentModifier**: Transform content before rendering
  - Theme-based modifications
  - Platform-specific changes
  - Conditional content

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_extension_content: any
```

## Usage

### Defining Content Types

Create a content type that extends `ContentItem`:

```dart
@JsonSerializable()
final class Article extends ContentItem {
  static const schemaName = 'article';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Article',
    fromJson: Article.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: ArticleLayout(),
    defaultLayoutDescriptor: ArticleLayout.typeDescriptor,
  );

  final String title;
  final String body;
  final ImageReference? image;

  Article({
    required super.id,
    required this.title,
    required this.body,
    this.image,
  }) : super(schemaType: schemaName);

  factory Article.fromJson(Map<String, dynamic> json) => 
    _$ArticleFromJson(json);
}
```

### Implementing Layouts

Create custom layouts by extending `LayoutConfiguration`:

```dart
final class ArticleLayout extends LayoutConfiguration<Article> {
  static const schemaName = '${Article.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Article Layout',
  );

  @override
  Widget build(BuildContext context, Article content) {
    return Column(
      children: [
        if (content.image != null)
          ContentImage(ref: content.image!),
        Text(content.title),
        PortableTextWidget(content.body),
      ],
    );
  }
}
```

### Registering Content Extensions

Register content types and layouts in your feature:

```dart
final feature = FeatureDescriptor(
  name: 'blog',
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        Article.typeDescriptor,
      ],
      contentBuilders: [
        Article.contentBuilder,
      ],
    ),
  ],
);
```

## Learn More

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License

This project is licensed under the terms specified in the LICENSE file.
