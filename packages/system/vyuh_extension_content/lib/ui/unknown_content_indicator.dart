import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/action.dart' as vyuh_action;
import 'package:vyuh_extension_content/content/condition.dart';
import 'package:vyuh_extension_content/plugin/unknown_placeholders.dart';

/// Utility functions for detecting unknown placeholders in content items.
class UnknownContentDetector {
  /// Checks if an Action contains any unknown action configurations.
  static bool hasUnknownActions(vyuh_action.Action? action) {
    if (action?.configurations == null) return false;

    return action!.configurations!.any((config) =>
        config is UnknownActionConfiguration);
  }

  /// Checks if a list of actions contains any unknown action configurations.
  static bool hasUnknownActionsInList(List<vyuh_action.Action?> actions) {
    return actions.any((action) => hasUnknownActions(action));
  }

  /// Checks if a Condition contains any unknown condition configurations.
  static bool hasUnknownConditions(Condition? condition) {
    return condition?.configuration is UnknownConditionConfiguration;
  }

  /// Checks if a content item has any unknown modifiers.
  static bool hasUnknownModifiers(ContentItem contentItem) {
    final modifiers = contentItem.getModifiers();
    if (modifiers == null) return false;

    return modifiers.any((modifier) =>
        modifier is UnknownContentModifierConfiguration);
  }

  /// Checks if a content item has an unknown layout.
  static bool hasUnknownLayout(LayoutConfiguration? layout) {
    return layout is UnknownLayoutConfiguration;
  }

  /// Comprehensive check for any unknown content in a content item.
  /// This can be extended by subclasses to check specific action/condition fields.
  static bool hasAnyUnknownContent(
    ContentItem contentItem, {
    List<vyuh_action.Action?> additionalActions = const [],
    List<Condition?> additionalConditions = const [],
    LayoutConfiguration? layout,
  }) {
    return hasUnknownModifiers(contentItem) ||
           hasUnknownLayout(layout ?? contentItem.layout) ||
           hasUnknownActionsInList(additionalActions) ||
           additionalConditions.any((condition) => hasUnknownConditions(condition));
  }
}

/// A widget that wraps content items to provide visual feedback when they
/// contain unknown actions, conditions, layouts, or modifiers.
///
/// In debug mode, this shows a visual indicator (red border + icon) to help
/// developers identify content items with missing type registrations.
///
/// Usage:
/// ```dart
/// return UnknownContentIndicator(
///   contentItem: card,
///   actions: [card.action, card.secondaryAction, card.tertiaryAction],
///   child: CardLayout(card: card),
/// );
/// ```
class UnknownContentIndicator extends StatelessWidget {
  /// The content item being checked for unknown content.
  final ContentItem contentItem;

  /// Additional actions to check for unknown configurations.
  final List<vyuh_action.Action?> actions;

  /// Additional conditions to check for unknown configurations.
  final List<Condition?> conditions;

  /// The layout to check (defaults to contentItem.layout).
  final LayoutConfiguration? layout;

  /// The child widget to wrap with the indicator.
  final Widget child;

  /// Whether to show a detailed overlay on tap (debug mode only).
  final bool showDetailOnTap;

  const UnknownContentIndicator({
    super.key,
    required this.contentItem,
    required this.child,
    this.actions = const [],
    this.conditions = const [],
    this.layout,
    this.showDetailOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    // Only show indicator in debug mode
    if (!kDebugMode) {
      return child;
    }

    final hasUnknown = UnknownContentDetector.hasAnyUnknownContent(
      contentItem,
      additionalActions: actions,
      additionalConditions: conditions,
      layout: layout,
    );

    if (!hasUnknown) {
      return child;
    }

    return _UnknownContentWrapper(
      contentItem: contentItem,
      actions: actions,
      conditions: conditions,
      layout: layout,
      showDetailOnTap: showDetailOnTap,
      child: child,
    );
  }
}

/// Internal wrapper widget that provides the visual indicator.
class _UnknownContentWrapper extends StatelessWidget {
  final ContentItem contentItem;
  final List<vyuh_action.Action?> actions;
  final List<Condition?> conditions;
  final LayoutConfiguration? layout;
  final bool showDetailOnTap;
  final Widget child;

  const _UnknownContentWrapper({
    required this.contentItem,
    required this.actions,
    required this.conditions,
    required this.layout,
    required this.showDetailOnTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget wrappedChild = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red.shade600,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          child,
          // Warning icon in top-right corner
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );

    if (showDetailOnTap) {
      wrappedChild = GestureDetector(
        onTap: () => _showDetailDialog(context),
        child: wrappedChild,
      );
    }

    return wrappedChild;
  }

  void _showDetailDialog(BuildContext context) {
    final issues = _collectIssues();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        icon: Icon(Icons.warning_amber_rounded,
                  color: Colors.red.shade700, size: 48),
        title: Text(
          'Unknown Content Detected',
          style: TextStyle(color: Colors.red.shade900),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This ${contentItem.schemaType} contains unknown type registrations:',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...issues.map((issue) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      issue.icon,
                      color: Colors.red.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.type,
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Text(
                              issue.schemaType,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: Colors.red.shade900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 12),
              Text(
                'Register TypeDescriptors for these schema types to fix.',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<_UnknownIssue> _collectIssues() {
    final issues = <_UnknownIssue>[];

    // Check actions
    for (final action in actions.where((a) => a != null)) {
      if (action!.configurations != null) {
        for (final config in action.configurations!) {
          if (config is UnknownActionConfiguration) {
            issues.add(_UnknownIssue(
              type: 'Unknown Action',
              schemaType: config.missingSchemaType,
              icon: Icons.play_arrow_outlined,
            ));
          }
        }
      }
    }

    // Check conditions
    for (final condition in conditions.where((c) => c != null)) {
      if (condition!.configuration is UnknownConditionConfiguration) {
        final unknown = condition.configuration as UnknownConditionConfiguration;
        issues.add(_UnknownIssue(
          type: 'Unknown Condition',
          schemaType: unknown.missingSchemaType,
          icon: Icons.rule_outlined,
        ));
      }
    }

    // Check layout
    final layoutToCheck = layout ?? contentItem.layout;
    if (layoutToCheck is UnknownLayoutConfiguration) {
      issues.add(_UnknownIssue(
        type: 'Unknown Layout',
        schemaType: layoutToCheck.missingSchemaType,
        icon: Icons.view_quilt_outlined,
      ));
    }

    // Check modifiers
    final modifiers = contentItem.getModifiers();
    if (modifiers != null) {
      for (final modifier in modifiers) {
        if (modifier is UnknownContentModifierConfiguration) {
          issues.add(_UnknownIssue(
            type: 'Unknown Modifier',
            schemaType: modifier.missingSchemaType,
            icon: Icons.tune_outlined,
          ));
        }
      }
    }

    return issues;
  }
}

class _UnknownIssue {
  final String type;
  final String schemaType;
  final IconData icon;

  _UnknownIssue({
    required this.type,
    required this.schemaType,
    required this.icon,
  });
}