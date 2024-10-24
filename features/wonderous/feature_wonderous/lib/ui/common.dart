import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/formatters.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart'
    hide Card, Divider;

final class WonderSection extends StatelessWidget {
  final Widget child;

  const WonderSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        child,
        const SectionDivider(),
      ],
    );
  }
}

final class WonderHeader extends StatelessWidget {
  final Wonder wonder;

  const WonderHeader({
    super.key,
    required this.wonder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: wonder.color,
      padding: EdgeInsets.all(theme.spacing.s16),
      child: Column(
        children: [
          ContentImage(
            ref: wonder.icon,
            height: 128,
            width: 128,
            fit: BoxFit.contain,
          ),
          Text(
            wonder.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
                theme.textTheme.displayMedium?.apply(color: wonder.textColor),
          ),
          const Divider(),
          Text(
            '${wonder.startYear.formattedYear} to ${wonder.endYear.formattedYear}',
            style: theme.textTheme.bodyMedium
                ?.apply(color: wonder.textColor, fontWeightDelta: 2),
          ),
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.surfaceDim)),
        Padding(
          padding: EdgeInsets.all(theme.spacing.s16),
          child: Icon(
            Icons.circle_outlined,
            color: theme.colorScheme.surfaceDim,
            size: theme.sizing.s4,
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.surfaceDim)),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(theme.spacing.s16),
      child: Text(
        title,
        style: theme.textTheme.titleLarge
            ?.apply(fontWeightDelta: 2, color: theme.colorScheme.primary),
      ),
    );
  }
}

class QuoteBlock extends StatelessWidget {
  final String text;
  final String? author;
  final Color color;
  final Color textColor;
  final ImageReference? backdropImage;

  const QuoteBlock({
    super.key,
    required this.text,
    this.author,
    required this.color,
    required this.textColor,
    this.backdropImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: theme.spacing.s16,
        bottom: backdropImage == null ? theme.spacing.s16 : theme.sizing.s32,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: color,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.s32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.apply(color: textColor),
                  ),
                  if (author != null)
                    Padding(
                      padding: EdgeInsets.only(top: theme.spacing.s16),
                      child: Text(
                        '- ${author!}',
                        style:
                            theme.textTheme.bodyMedium?.apply(color: textColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: theme.sizing.s2,
            top: -theme.sizing.s2,
            child: Text(
              '“',
              style: theme.textTheme.displayLarge?.apply(
                color: textColor,
                fontSizeDelta: 20,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          if (backdropImage != null)
            Positioned(
              bottom: -theme.sizing.s32 + theme.spacing.s32,
              right: theme.spacing.s32,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(theme.borderRadius.medium),
                  boxShadow: [
                    BoxShadow(
                      color: color,
                      blurRadius: theme.spacing.s4,
                    ),
                  ],
                ),
                child: ContentImage(
                  ref: backdropImage!,
                  height: theme.sizing.s32,
                  width: theme.sizing.s32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
