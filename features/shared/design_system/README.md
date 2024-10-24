## Design System
Design System for a Flutter App using [material-theme-builder](https://material-foundation.github.io/material-theme-builder/) to generate the theme.



### Usage
```dart

    final textTheme = ds.createTextTheme(context, "Poppins", "Poppins");

    final theme = ds.MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );

```

### Features

Defines design tokens for core elements:
- Spacing
- Sizing
- Border Width
- Border Radius


### Accessing design tokens
```agsl
Theme.of(context).spacing.<token>
Theme.of(context).sizing.<token>
Theme.of(context).borderWidth.<token>
Theme.of(context).borderRadius.<token>
```
