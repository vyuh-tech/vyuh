# Unknown Content Indicator Usage

The `UnknownContentIndicator` widget provides visual feedback for content items that contain unknown actions, conditions, layouts, or modifiers during development.

## Basic Usage

Wrap your content item's widget with `UnknownContentIndicator` and pass any actions/conditions that the content item uses:

```dart
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class CardBuilder extends ContentBuilder<Card> {
  @override
  Widget build(BuildContext context, Card content) {
    return UnknownContentIndicator(
      contentItem: content,
      actions: [
        content.action,
        content.secondaryAction,
        content.tertiaryAction,
      ],
      child: _buildCardLayout(context, content),
    );
  }

  Widget _buildCardLayout(BuildContext context, Card content) {
    // Your normal card layout implementation
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (content.title != null) Text(content.title!),
          if (content.description != null) Text(content.description!),
          if (content.action?.isNotEmpty == true)
            ElevatedButton(
              onPressed: () => content.action!.execute(context),
              child: Text('Primary Action'),
            ),
        ],
      ),
    );
  }
}
```

## What It Does

### In Debug Mode:
- Shows a **red border** around content items with unknown content
- Displays a **warning icon** in the top-right corner
- Shows a **detailed dialog** when tapped, listing all unknown schema types
- Helps developers quickly identify missing type registrations

### In Production Mode:
- **No visual changes** - the indicator is completely invisible
- No performance impact - wrapping is bypassed entirely

## Advanced Usage

### With Conditions
```dart
return UnknownContentIndicator(
  contentItem: content,
  actions: [content.action],
  conditions: [content.showCondition, content.hideCondition],
  child: MyContentWidget(content),
);
```

### With Custom Layout
```dart
return UnknownContentIndicator(
  contentItem: content,
  layout: customLayout, // Check a specific layout instead of content.layout
  actions: [content.submitAction],
  child: MyContentWidget(content),
);
```

### Disable Detail Dialog
```dart
return UnknownContentIndicator(
  contentItem: content,
  actions: [content.action],
  showDetailOnTap: false, // Only show border, no dialog
  child: MyContentWidget(content),
);
```

## Detection Logic

The indicator automatically detects:

1. **Unknown Actions**: Any `UnknownActionConfiguration` in action configurations
2. **Unknown Conditions**: Any `UnknownConditionConfiguration` in conditions
3. **Unknown Layouts**: Any `UnknownLayoutConfiguration`
4. **Unknown Modifiers**: Any `UnknownContentModifierConfiguration` in content modifiers

## Visual Design

- **Border**: 2px solid red
- **Icon**: Red warning icon with white background
- **Dialog**: Red-themed with schema type details and fix suggestions

## Best Practices

1. **Always Use in Content Builders**: Wrap the main widget in every content builder
2. **Pass All Actions**: Include primary, secondary, tertiary, and any custom actions
3. **Include Conditions**: Pass any condition fields your content item uses
4. **Keep Child Widget Clean**: Don't add the indicator logic inside your layout widgets

## Example Error States

When unknown content is detected, developers see:

```
┌─────────────────────────────┐ ⚠️
│  Card Title                 │
│  Card description text...   │
│  [Primary Action Button]    │
└─────────────────────────────┘
```

Clicking the warning icon shows:
- "Unknown Action: my.custom.action"
- "Unknown Condition: my.missing.condition"
- "Register TypeDescriptors for these schema types to fix."

This provides immediate visual feedback during development while keeping production builds clean.