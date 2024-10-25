import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedHeadingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;

  const AnimatedHeadingText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: style ?? theme.textTheme.headlineSmall,
      maxLines: maxLines,
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          duration: 1200.ms,
          color: theme.colorScheme.primary.withOpacity(0.5),
        )
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(
          duration: 1200.ms,
          curve: Curves.easeOutQuad,
        )
        .slide();
  }
}
