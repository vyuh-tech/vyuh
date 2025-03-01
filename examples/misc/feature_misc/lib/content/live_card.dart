import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'live_card.g.dart';

enum LiveCardSize {
  small,
  medium,
  large;

  double get height => switch (this) {
        LiveCardSize.small => 300,
        LiveCardSize.medium => 400,
        LiveCardSize.large => 600,
      };
}

@JsonSerializable()
final class LiveCard extends ContentItem {
  static const schemaName = 'misc.card.live';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Live Card',
    fromJson: LiveCard.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: LiveCardDefaultLayout(),
    defaultLayoutDescriptor: LiveCardDefaultLayout.typeDescriptor,
  );

  final ObjectReference? document;
  final bool includeDrafts;
  final LiveCardSize size = LiveCardSize.medium;

  LiveCard({
    this.document,
    this.includeDrafts = false,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory LiveCard.fromJson(Map<String, dynamic> json) =>
      _$LiveCardFromJson(json);
}

final class LiveCardDescriptor extends ContentDescriptor {
  LiveCardDescriptor({super.layouts = const []})
      : super(schemaType: LiveCard.schemaName, title: 'Live Card');
}

@JsonSerializable()
final class LiveCardDefaultLayout extends LayoutConfiguration<LiveCard> {
  static const schemaName = '${LiveCard.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: LiveCardDefaultLayout.fromJson,
    title: 'Live Card Default Layout',
  );

  LiveCardDefaultLayout() : super(schemaType: schemaName);

  factory LiveCardDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$LiveCardDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, LiveCard content) {
    return _LiveCardView(content: content);
  }
}

class _LiveCardView extends StatelessWidget {
  final LiveCard content;

  const _LiveCardView({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: vyuh.content.provider.live.fetchById(
        content.document!.ref,
        fromJson: Document.fromJson,
        includeDrafts: content.includeDrafts,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return vyuh.widgetBuilder.errorView(context,
              error: snapshot.error, title: 'Failed to load Document');
        }

        if (!snapshot.hasData) {
          return vyuh.widgetBuilder.contentLoader(context);
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: content.size.height),
            child: vyuh.content.buildContent(
              context,
              snapshot.data as Document,
            ),
          ),
        );
      },
    );
  }
}
