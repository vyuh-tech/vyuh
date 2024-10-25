import 'package:feature_puzzles/utils/constants.dart';
import 'package:flutter/material.dart';

class GroundWidget extends StatelessWidget {
  final int itemCount;
  final int? quarterTurns;
  final double aspectRatio;
  final NullableIndexedWidgetBuilder itemBuilder;

  const GroundWidget({
    super.key,
    required this.itemCount,
    this.quarterTurns,
    required this.aspectRatio,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final child = AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.background,
                  package: Assets.package,
                ),
                fit: BoxFit.fill,
                opacity: 0.8,
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: itemBuilder,
          ),
        ],
      ),
    );

    return quarterTurns == null
        ? child
        : RotatedBox(
            quarterTurns: quarterTurns!,
            child: child,
          );
  }
}
