# Flutter Widget for rendering Sanity's Portable Text 📄

[![flutter_sanity_portable_text](https://img.shields.io/pub/v/flutter_sanity_portable_text.svg?label=flutter_sanity_portable_text&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/flutter_sanity_portable_text)

A Flutter widget for rendering
[Portable Text format](https://github.com/portabletext/portabletext) content
from Sanity.io. This package is part of the Vyuh framework but can be used
independently in any Flutter application.

<img
src="https://raw.githubusercontent.com/vyuh-tech/vyuh/main/packages/sanity/flutter_sanity_portable_text/example/screenshot.png"
width="300"
alt="Screenshot of the rendered Portable Text" />

## Features ✨

- **Complete Portable Text Support** 📝: Renders all standard styles and marks
- **Block Rendering** 🧱: Support for multiple blocks with different styles
- **Customization** 🎨:
  - Custom blocks and block containers
  - Custom styles and marks including complex annotations
  - Customize all default styles, blocks and containers
- **Developer Experience** 🛠️:
  - Shows inline errors for unregistered blocks, marks and styles
  - Helpful error messages during debugging
  - Type-safe API

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_sanity_portable_text: ^1.0.0
```

## Usage 💡

The below samples show the various ways of using the `PortableText` widget:

- [With a simple TextBlockItem](#with-a-simple-textblockitem)
- [Rendered directly from JSON](#rendered-directly-from-json)
- [With multiple blocks and different styles](#with-multiple-blocks-and-different-styles)
- [With a custom block](#with-a-custom-block)
- [Using an unregistered block shows an error](#using-an-unregistered-block-shows-an-error)
- [With a custom mark](#with-a-custom-mark)
- [When a custom mark is not registered, an error will be shown](#when-a-custom-mark-is-not-registered-an-error-will-be-shown)

### With a simple TextBlockItem

```dart

import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortableText(
              blocks: [
                TextBlockItem(
                  children: [
                    Span(
                      text: 'Sanity Portable Text',
                    ),
                  ],
                  style: 'h1',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Rendered directly from JSON

```dart

final text = PortableText(
  blocks: [
    TextBlockItem.fromJson(jsonDecode('''
{
  "_type": "block",
  "style": "h3",
  "children": [
    {
      "_type": "span",
      "text": "Rendered in "
    },
    {
      "_type": "span",
      "text": "Flutter",
      "marks": ["em", "strong", "underline"]
    }
  ]
}
''')),
  ],
);


```

### With multiple blocks and different styles

```dart

final text = PortableText(
  blocks: [
    TextBlockItem(
      children: [
        Span(
          text: 'Sanity Portable Text',
        ),
      ],
      style: 'h1',
    ),

    // Let's try a blockquote now
    TextBlockItem(
      children: [
        Span(
          text:
          '"The best way to predict the future is to invent it."',
        ),
        Span(
          text: '\n- Steve Jobs',
        ),
      ],
      style: 'blockquote',
    ),

    TextBlockItem(
      children: [
        Span(
          text:
          'Supports all standard marks and styles, including support for:',
        ),
      ],
    ),

    _listItem('Bulleted text', ListItemType.bullet),
    _listItem('Numbered text', ListItemType.number),
    _listItem('Square bullet text', ListItemType.square),
    TextBlockItem(
      children: [
        Span(text: 'Strong text, ', marks: ['strong']),
        Span(text: 'Emphasized text, ', marks: ['em']),
        Span(text: 'Underlined text, ', marks: ['underline']),
        Span(
            text: 'Strike through text, ',
            marks: ['strike-through']),
        Span(
            text: 'All combined',
            marks: ['strong', 'em', 'underline', 'strike-through']),
        Span(text: '.'),
      ],
    ),
    _textBlock('And not to forget...the unsung'),
    for (final index in [1, 2, 3, 4, 5, 6])
      _textBlock('H$index', style: 'h$index'),
  ],
);

TextBlockItem _textBlock(String text, {String? style}) {
  return TextBlockItem(
    children: [
      Span(text: text),
    ],
    style: style ?? 'normal',
  );
}

TextBlockItem _listItem(String text, ListItemType type) {
  return TextBlockItem(
    children: [
      Span(text: text),
    ],
    listItem: type,
  );
}

```

### With a custom block

```dart
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

// A custom block item that will be registered for rendering
final class CustomBlockItem implements PortableBlockItem {
  CustomBlockItem({
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  String get blockType => 'custom';

  final String text;
  final Color foregroundColor;
  final Color backgroundColor;
}

void main() {
  // Registering a custom block
  PortableTextConfig.shared.blocks['custom'] = (context, item) {
    final theme = Theme.of(context);
    final custom = item as CustomBlockItem;
    final style =
    theme.textTheme.bodyMedium?.apply(color: custom.foregroundColor);

    return Container(
      decoration: BoxDecoration(
          color: custom.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent, width: 2),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 2,
              color: Colors.black26,
            )
          ]),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: Text(custom.text, style: style),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortableText(
              blocks: [
                TextBlockItem(
                  children: [
                    Span(
                      text: 'Sanity Portable Text',
                    ),
                  ],
                  style: 'h1',
                ),

                CustomBlockItem(
                    text: 'We can also do custom blocks!',
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.primaries[4]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

### Using an unregistered block shows an error

```dart
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

// A custom block item that will not be registered for rendering
final class UnregisteredBlockItem implements PortableBlockItem {
  @override
  String get blockType => 'unregistered';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortableText(
              blocks: [
                TextBlockItem(
                  children: [
                    Span(
                      text: 'Sanity Portable Text',
                    ),
                  ],
                  style: 'h1',
                ),

                // this will show an error on the PortableText Widget
                UnregisteredBlockItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

```

### With a custom mark

```dart
final class CustomMarkDef implements MarkDef {
  CustomMarkDef({
    required this.color,
    required this.key,
  });

  @override
  final String key;

  final Color color;

  @override
  String get type => 'custom-mark';
}

void main() {
  // Registering a custom mark
  _registerCustomMark();

  runApp(const MyApp());
}

void _registerCustomMark() {
  PortableTextConfig.shared.markDefs['custom-mark'] = MarkDefDescriptor(
    schemaType: 'custom-mark',
    styleBuilder: (context, markDef, textStyle) {
      final mark = markDef as CustomMarkDef;

      final style = textStyle.apply(
        decoration: TextDecoration.underline,
        decorationColor: mark.color,
      );

      return style;
    },
    fromJson: (json) => CustomMarkDef(color: json['color'], key: json['key']),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortableText(
              blocks: [
                TextBlockItem(
                  children: [
                    Span(
                      text: 'Sanity Portable Text',
                    ),
                  ],
                  style: 'h1',
                ),

                TextBlockItem(
                  children: [
                    Span(
                      text: 'We can also do ',
                    ),
                    Span(text: 'custom marks!', marks: ['custom-key']),
                  ],
                  markDefs: [
                    CustomMarkDef(color: Colors.red, key: 'custom-key'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### When a custom mark is not registered, an error will be shown

```dart
final class UnregisteredMarkDef implements MarkDef {
  UnregisteredMarkDef({
    required this.key,
  });

  @override
  final String key;

  @override
  String get type => 'unregistered-mark';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PortableText(
              blocks: [
                TextBlockItem(
                  children: [
                    Span(
                      text: 'Sanity Portable Text',
                    ),
                  ],
                  style: 'h1',
                ),

                TextBlockItem(
                  children: [
                    Span(
                        text:
                        ' and report when a custom mark is not registered, such as:'),
                    Span(text: ' this.', marks: ['missing-key']),
                  ],
                  markDefs: [
                    UnregisteredMarkDef(key: 'missing-key')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

### Using a custom List Builder to render the PortableText

```dart
Widget columnBuilder(BuildContext context, List<PortableBlockItem> blocks) {
  return Column(
    children: blocks
        .map(
            (block) => PortableTextConfig.shared.buildBlock(context, block))
        .toList(),
  );
}

final text = PortableText(blocks: [...], listBuilder: columnBuilder);

```

## Exploring further

There are several other features which have been excluded from the examples
above, such as:

- Custom block styles
- Custom Block containers
- Item padding inside a `PortableText` widget
- Indents for list items
- Changing the base style
- Changing the default block and mark styles

You can look at the properties of `PortableConfig` for more customization
opportunities.

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. For major
changes, please open an issue first to discuss what you would like to change.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
