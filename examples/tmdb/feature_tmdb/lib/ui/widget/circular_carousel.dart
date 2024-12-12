import 'dart:async';

import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vyuh_feature_system/content/empty.dart';

enum CarouselIndicatorType { stacked, below, none }

class CircularCarousel extends StatefulWidget {
  final double aspectRatio;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final CarouselIndicatorType indicatorType;
  final double viewportFraction;

  const CircularCarousel({
    super.key,
    required this.aspectRatio,
    required this.itemCount,
    required this.itemBuilder,
    this.indicatorType = CarouselIndicatorType.none,
    this.viewportFraction = 1.0,
  });

  @override
  State<CircularCarousel> createState() => _CircularCarouselState();
}

class _CircularCarouselState extends State<CircularCarousel> {
  // A large initial page number to allow scrolling in both directions
  static const int _initialPage = 10000;
  late final PageController _controller;
  late final int _boundsThreshold;
  late final int _lowerBound;
  late final int _upperBound;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _boundsThreshold = _initialPage ~/ 2;
    _lowerBound = _initialPage - _boundsThreshold;
    _upperBound = _initialPage + _boundsThreshold;
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceJump(int index) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final adjustedIndex = _initialPage + (index % widget.itemCount);
      if (_controller.page != adjustedIndex) {
        _controller.jumpToPage(adjustedIndex);
      }
    });
  }

  void _handleCircularPageChange(int index) {
    // Check if we've scrolled beyond the defined bounds
    if (index <= _lowerBound || index >= _upperBound) {
      // If so, jump back to the middle of our virtual list
      // This jump is not noticeable to the user as it maintains
      // the current item and debounce the jump
      _debounceJump(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pageView = PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) => widget.itemBuilder(
        context,
        index % widget.itemCount,
      ),
      onPageChanged: _handleCircularPageChange,
    );

    final indicator = CarouselIndicator(
      controller: _controller,
      count: widget.itemCount,
      color: widget.indicatorType == CarouselIndicatorType.stacked
          ? theme.colorScheme.surface
          : theme.colorScheme.outlineVariant,
    );

    Widget carouselWidget = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: pageView,
    );

    if (widget.indicatorType == CarouselIndicatorType.stacked) {
      carouselWidget = Stack(
        children: [
          carouselWidget,
          Positioned(
            left: 0,
            right: 0,
            bottom: theme.spacing.s16,
            child: Center(child: indicator),
          ),
        ],
      );
    }

    if (widget.indicatorType == CarouselIndicatorType.below) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          carouselWidget,
          SizedBox(height: theme.spacing.s12),
          widget.itemCount == 1 ? empty : indicator,
        ],
      );
    }

    return carouselWidget;
  }
}

class CarouselIndicator extends StatelessWidget {
  final int count;
  final PageController controller;
  final Color color;

  const CarouselIndicator({
    super.key,
    required this.count,
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        expansionFactor: theme.sizing.s2 / 2,
        activeDotColor: color,
        dotColor: color.withValues(alpha: 0.5),
        dotHeight: theme.sizing.s2,
        dotWidth: theme.sizing.s4,
        spacing: theme.spacing.s8,
      ),
    );
  }
}
