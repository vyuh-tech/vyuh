import 'package:flutter/material.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class FloatingAppBar extends StatefulWidget {
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final double toolbarHeight;
  final Widget title;
  final Widget? leading;
  final double? expandedHeight;
  final Widget backgroundWidget;
  final bool? centerTitle;
  final Widget body;

  const FloatingAppBar({
    super.key,
    this.surfaceTintColor,
    this.backgroundColor,
    required this.toolbarHeight,
    required this.title,
    this.leading,
    this.expandedHeight = 320,
    required this.backgroundWidget,
    this.centerTitle = false,
    required this.body,
  });

  @override
  State<FloatingAppBar> createState() => _FloatingAppBarState();
}

class _FloatingAppBarState extends State<FloatingAppBar> {
  late ScrollController _scrollController;
  bool isShowTitle = false;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded
            ? setState(() => isShowTitle = true)
            : setState(() => isShowTitle = false),
      );
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (320 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor:
              widget.surfaceTintColor ?? theme.colorScheme.surfaceBright,
          backgroundColor:
              widget.backgroundColor ?? theme.colorScheme.surfaceBright,
          toolbarHeight: widget.toolbarHeight,
          titleSpacing: 0,
          leading: widget.leading ?? empty,
          leadingWidth: 0,
          title: isShowTitle ? widget.title : empty,
          centerTitle: widget.centerTitle,
          floating: true,
          stretch: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            centerTitle: false,
            background: widget.backgroundWidget,
          ),
          expandedHeight: widget.expandedHeight,
        ),
        SliverToBoxAdapter(child: widget.body),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
