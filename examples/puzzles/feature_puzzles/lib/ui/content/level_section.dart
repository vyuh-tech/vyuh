import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/api/puzzles_client.dart';
import 'package:feature_puzzles/routes.dart';
import 'package:feature_puzzles/ui/loader/level_loader.dart';
import 'package:feature_puzzles/ui/river_level/river_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'level_section.g.dart';

@JsonSerializable(createToJson: false)
final class LevelSection extends ContentItem {
  static const schemaName = 'puzzles.level.section';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Puzzle Level Section',
    fromJson: LevelSection.fromJson,
  );

  final String title;

  LevelSection({
    required this.title,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory LevelSection.fromJson(Map<String, dynamic> json) =>
      _$LevelSectionFromJson(json);
}

@JsonSerializable(createToJson: false)
final class LevelSectionLayout extends LayoutConfiguration<LevelSection> {
  static const schemaName = '${LevelSection.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Level Section Layout',
    fromJson: LevelSectionLayout.fromJson,
  );

  LevelSectionLayout() : super(schemaType: schemaName);

  factory LevelSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$LevelSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, LevelSection content) {
    return LevelSectionBuilder(
      content: content,
      builder: (context, level) => RiverLevel(level: level),
    );
  }
}

typedef LevelBuilder = Widget Function(BuildContext, Level);

class LevelSectionBuilder extends StatefulWidget {
  final LevelBuilder builder;
  final LevelSection content;

  const LevelSectionBuilder({
    super.key,
    required this.builder,
    required this.content,
  });

  @override
  State<LevelSectionBuilder> createState() => _LevelSectionBuilderState();
}

class _LevelSectionBuilderState extends State<LevelSectionBuilder> {
  ObservableFuture<Level?> _future = ObservableFuture.value(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = GoRouterState.of(context).idFromPath();
    if (id != null) {
      _future = vyuh.di.get<PuzzleClient>().fetchLevel(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final status = _future.status;
        final content = _future.value;
        switch (status) {
          case FutureStatus.pending:
            return const LevelContentLoader();
          case FutureStatus.rejected:
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to fetch Level',
              error: _future.error,
              stackTrace: _future.error.stackTrace,
            );
          case FutureStatus.fulfilled:
            if (content == null) {
              return vyuh.widgetBuilder
                  .errorView(context, title: 'Failed to fetch Level');
            }

            return widget.builder(context, content);
        }
      },
    );
  }
}
