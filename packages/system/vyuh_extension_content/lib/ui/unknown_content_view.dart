import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// The default view for a [ContentFailure]: a missing content type, layout,
/// modifier, action or condition. Styled like the framework's debug views.
class UnknownContentView extends StatelessWidget {
  /// The failure to describe.
  final ContentFailure failure;

  /// Creates the view for [failure].
  const UnknownContentView({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = VyuhThemeExtension.of(context);
    final foreground = tokens.debugForeground!;

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tokens.debugBackground,
        border: Border.all(color: tokens.debugBorder!),
        borderRadius: BorderRadius.circular(tokens.radius!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getFailureIcon(), color: foreground, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getFailureTitle(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Schema Type: ${failure.schemaType}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: foreground,
            ),
          ),
          if (failure.description != null) ...[
            const SizedBox(height: 4),
            Text(
              failure.description!,
              style: theme.textTheme.bodySmall?.copyWith(color: foreground),
            ),
          ],
          if (_getFailureDetails() != null) ...[
            const SizedBox(height: 8),
            Text(
              _getFailureDetails()!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (failure.suggestions?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              'Suggestions:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            ...failure.suggestions!.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                child: Text(
                  '• $suggestion',
                  style: theme.textTheme.bodySmall?.copyWith(color: foreground),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getFailureIcon() {
    return switch (failure) {
      ContentItemFailure() => Icons.extension_off,
      LayoutFailure() => Icons.view_compact_alt_outlined,
      ModifierFailure() => Icons.tune_outlined,
      ActionFailure() => Icons.play_disabled_outlined,
      ConditionFailure() => Icons.rule_outlined,
      _ => Icons.error_outline,
    };
  }

  String _getFailureTitle() {
    return switch (failure) {
      ContentItemFailure() => 'Unknown Content Type',
      LayoutFailure() => 'Missing Layout',
      ModifierFailure() => 'Missing Modifier',
      ActionFailure() => 'Missing Action',
      ConditionFailure() => 'Missing Condition',
      _ => 'Unknown Failure',
    };
  }

  String? _getFailureDetails() {
    return switch (failure) {
      LayoutFailure(:final contentSchemaType, :final requestedLayoutType) =>
        'Content: $contentSchemaType${requestedLayoutType != null ? ', Requested Layout: $requestedLayoutType' : ''}',
      ModifierFailure(:final modifierChain, :final failedIndex) =>
        'Chain: [${modifierChain.join(' → ')}], Failed at position $failedIndex',
      _ => null,
    };
  }
}
