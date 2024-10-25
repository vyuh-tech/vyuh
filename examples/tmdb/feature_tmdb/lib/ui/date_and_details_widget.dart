import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';

class TitleAndDateWidget extends StatelessWidget {
  final ShortInfo browseTypeData;
  final ListRepresentation representation;
  final bool isRecommendation;

  const TitleAndDateWidget({
    super.key,
    required this.browseTypeData,
    this.representation = ListRepresentation.short,
    this.isRecommendation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: theme.spacing.s8,
        right: theme.spacing.s8,
        bottom: theme.spacing.s8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            browseTypeData.title,
            style: theme.tmdbTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: theme.spacing.s4),
          Text(
            !isRecommendation
                ? browseTypeData.releaseDate.formattedNumericDate
                : browseTypeData.releaseDate.formattedYear,
            style: theme.tmdbTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
