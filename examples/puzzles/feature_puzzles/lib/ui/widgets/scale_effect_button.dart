import 'package:flutter/material.dart';

class ScaleEffectButton extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;

  const ScaleEffectButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<ScaleEffectButton> createState() => _ScaleEffectButtonState();
}

class _ScaleEffectButtonState extends State<ScaleEffectButton>
    with TickerProviderStateMixin {
  double _scale = 1;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.85,
      value: _scale,
      duration: const Duration(milliseconds: 50),
    );
    _controller.addListener(() {
      setState(() => _scale = _controller.value);
    });

    super.initState();
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () async {
          await _controller.reverse();
          await _controller.fling();
          widget.onTap.call();
        },
        onTapCancel: () async {
          await _controller.fling();
        },
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
