import 'package:flutter/material.dart';

final class TitleText extends StatelessWidget {
  final String text;

  final TextAlign textAlign;

  const TitleText(
      {super.key, required this.text, this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Text(
      text: text,
      style: theme.textTheme.titleMedium,
      textAlign: textAlign,
    );
  }
}

final class SubtitleText extends StatelessWidget {
  final String text;

  final TextAlign textAlign;

  final int maxLines;

  const SubtitleText({
    super.key,
    required this.text,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Text(
      text: text,
      style: theme.textTheme.bodySmall,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

final class _Text extends StatelessWidget {
  final String text;

  final TextAlign? textAlign;

  final TextStyle? style;

  final int maxLines;

  const _Text({
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
