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

  const SubtitleText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Text(
      text: text,
      style: theme.textTheme.bodySmall,
      textAlign: textAlign,
    );
  }
}

final class _Text extends StatelessWidget {
  final String text;

  final TextAlign? textAlign;

  final TextStyle? style;

  const _Text({
    required this.text,
    this.textAlign = TextAlign.start,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
