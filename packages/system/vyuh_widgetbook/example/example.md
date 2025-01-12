# Vyuh Widgetbook Example

This example demonstrates how to use the `vyuh_widgetbook` package to preview your Vyuh content types.

## Setup

1. Create a new Flutter project for your widgetbook:

```bash
flutter create my_app_widgetbook
```

2. Add the required dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vyuh_widgetbook: ^1.1.0
  vyuh_feature_system: ^1.0.0  # Required for system features
  my_feature_one: ^1.0.0       # Your feature package
  my_feature_two: ^1.0.0       # Another feature package
```

## Basic Usage

Replace the contents of `lib/main.dart` with:

```dart
import 'package:flutter/widgets.dart';
import 'package:vyuh_widgetbook/vyuh_widgetbook.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:my_feature_one/my_feature_one.dart' as feature1;
import 'package:my_feature_two/my_feature_two.dart' as feature2;

void main() {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Run the widgetbook
  runWidgetBook(
    features: () => [
      system.feature,
      feature1.feature,
      feature2.feature,
    ],
    // Optional: Use your app's themes
    lightTheme: MyAppTheme.light,
    darkTheme: MyAppTheme.dark,
  );
}
```

## Running the App

For the best development experience, run the app using Chrome or MacOS:

```bash
# Run on Chrome
flutter run -d chrome

# Run on MacOS
flutter run -d macos
```

## Creating a Preview

When creating a content type, add a preview to its type descriptor:

```dart
@JsonSerializable()
class MyCard extends ContentItem {
  static const schemaName = 'myCard';
  
  static final typeDescriptor = TypeDescriptor<MyCard>(
    schemaType: schemaName,
    title: 'My Card',
    fromJson: MyCard.fromJson,
    // Add a preview
    preview: () => MyCard(
      id: 'preview',
      title: 'Preview Title',
      description: 'This is a preview of my card',
      image: ImageReference(
        url: 'https://example.com/image.jpg',
        dimensions: const ImageDimensions(width: 800, height: 600),
      ),
    ),
  );

  final String title;
  final String description;
  final ImageReference? image;

  MyCard({
    required super.id,
    required this.title,
    required this.description,
    this.image,
  }) : super(schemaType: schemaName);
}
```

## Tips

1. **Testing Themes**: Use the theme toggle in the widgetbook to test your content in both light and dark themes.

2. **Responsive Testing**: Resize the window to test how your content adapts to different screen sizes.

3. **Preview Data**: Use realistic data in your previews to better understand how your content will look in production.

## Learn More

For more details and advanced usage:
- Visit the [Vyuh Documentation](https://docs.vyuh.tech)
- Check out the [Content Explorer](https://github.com/vyuh-tech/vyuh/tree/main/apps/content_explorer) for a complete example
- Read the [Widgetbook Guide](https://docs.vyuh.tech/guides/cms/widgetbook)
