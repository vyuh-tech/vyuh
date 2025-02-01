import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

class ContentItemsScrollView extends StatelessWidget {
  const ContentItemsScrollView({
    super.key,
    required this.items,
  });

  final List<ContentItem> items;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      cacheExtent: MediaQuery.sizeOf(context).height * 1.5,
      primary: true,
      slivers: [
        SliverList.builder(
          itemBuilder: (context, index) =>
              VyuhBinding.instance.content.buildContent(context, items[index]),
          itemCount: items.length,
        )
      ],
    );
  }
}
