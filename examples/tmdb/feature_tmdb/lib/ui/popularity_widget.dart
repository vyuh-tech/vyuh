import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/ui/common_widgets/vote_percentage.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as f;

class ImageAndPopularityWidget extends StatelessWidget {
  final ShortInfo info;
  final ListRepresentation representation;
  final bool isRecommendation;

  const ImageAndPopularityWidget({
    super.key,
    required this.info,
    this.representation = ListRepresentation.short,
    this.isRecommendation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          f.ContentImage(
            url: info.posterImage,
            height: theme.sizing.s64,
            width: theme.sizing.width95(size.width),
            fit: BoxFit.cover,
          ),
          if (!isRecommendation)
            Positioned(
              right: theme.spacing.s8,
              top: theme.spacing.s8,
              child: VotePercentage(
                voteAverage: info.voteAverage,
              ),
            ),
        ],
      ),
    );
  }
}
