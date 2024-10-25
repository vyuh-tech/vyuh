import 'package:feature_puzzles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:water_fx/water_fx.dart';

class RiverWidget extends StatelessWidget {
  final double aspectRatio;
  final GestureTapCallback onTap;
  final Widget child;

  const RiverWidget({
    super.key,
    required this.aspectRatio,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(final BuildContext context) => AspectRatio(
        aspectRatio: aspectRatio,
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              WaterFXContainer.simpleWidgetInstanceForPointer(
                child: const Image(
                  height: double.infinity,
                  width: double.infinity,
                  image: AssetImage(
                    Assets.water,
                    package: Assets.package,
                  ),
                  fit: BoxFit.scaleDown,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child,
            ],
          ),
        ),
      );
}
