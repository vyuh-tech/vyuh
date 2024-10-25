import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'page_view_layout.g.dart';

@JsonSerializable()
final class PageViewLayout extends LayoutConfiguration<Group> {
  static const schemaName = 'vyuh.group.layout.pageView';
  static final typeDescriptor = TypeDescriptor(
    schemaType: 'vyuh.group.layout.pageView',
    fromJson: PageViewLayout.fromJson,
    title: 'Page View Layout',
  );

  final bool showIndicator;
  final double viewportFraction;

  PageViewLayout({required this.showIndicator, this.viewportFraction = 0.75})
      : super(schemaType: schemaName);

  factory PageViewLayout.fromJson(Map<String, dynamic> json) =>
      _$PageViewLayoutFromJson(json);

  @override
  Widget build(BuildContext context, Group content) {
    return _PageViewWidget(content: content, layout: this);
  }
}

class _PageViewWidget extends StatefulWidget {
  final Group content;
  final PageViewLayout layout;

  const _PageViewWidget({
    required this.content,
    required this.layout,
  });

  @override
  State<_PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<_PageViewWidget> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: widget.layout.viewportFraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LimitedBox(
      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.content.items.length,
              itemBuilder: (context, index) {
                return vyuh.content
                    .buildContent(context, widget.content.items[index]);
              },
              scrollDirection: Axis.horizontal,
              controller: _controller,
              pageSnapping: true,
              physics: const BouncingScrollPhysics(),
              allowImplicitScrolling: true,
            ),
          ),
          if (widget.layout.showIndicator)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: widget.content.items.length,
                effect: ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: theme.colorScheme.primary,
                ),
                onDotClicked: (index) {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
