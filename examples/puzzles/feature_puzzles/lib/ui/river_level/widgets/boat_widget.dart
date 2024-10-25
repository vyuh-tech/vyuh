import 'package:feature_puzzles/utils/constants.dart';
import 'package:flutter/material.dart';

class BoatWidget extends StatelessWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final BoxConstraints constraints;

  const BoatWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.constraints,
  });

  @override
  Widget build(final BuildContext context) => Container(
        constraints: constraints,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.boat,
              package: Assets.package,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: itemBuilder,
        ),
      );
}
