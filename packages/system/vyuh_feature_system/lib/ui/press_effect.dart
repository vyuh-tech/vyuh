import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PressEffect extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context)? onTap;
  final double scale;

  const PressEffect({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
  });

  @override
  State<PressEffect> createState() => _PressEffectState();
}

class _PressEffectState extends State<PressEffect> {
  var _tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null
          ? () {
              setState(() {
                if (_tapped) {
                  return;
                }

                _tapped = true;
              });
            }
          : null,
      child: _tapped
          ? widget.child.animate(onComplete: (_) {
              setState(() {
                _tapped = false;

                Future.delayed(
                  const Duration(milliseconds: 50),
                  () {
                    if (!context.mounted) {
                      return;
                    }

                    return widget.onTap?.call(context);
                  },
                );
              });
            }).toggle(
              duration: 25.ms,
              delay: 50.ms,
              builder: (_, value, child) {
                return child.animate().scaleXY(end: value ? widget.scale : 1.0);
              })
          : widget.child,
    );
  }
}
