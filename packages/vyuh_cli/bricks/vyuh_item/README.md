# Vyuh Item Brick

A brick for generating Vyuh ContentItem classes and their corresponding layout classes.

## Usage

```bash
vyuh create item <item-name> --feature <feature-name>
```

This will generate:
1. A ContentItem class in the feature's content directory
2. A layout class in the feature's layouts directory
3. Placeholder files for generated code

## Features

- Follows Vyuh's guidelines for ContentItem and layout implementation
- Includes proper schema naming conventions
- Sets up the necessary boilerplate code for JSON serialization
- Creates a basic layout implementation
