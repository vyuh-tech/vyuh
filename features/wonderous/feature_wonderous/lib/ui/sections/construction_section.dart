import 'package:chakra_shared/ui/youtube_video_player.dart';
import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

final class WonderConstructionSection extends StatelessWidget {
  final String? title;
  final Wonder wonder;

  const WonderConstructionSection(
      {super.key, this.title, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WonderSection(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.s16),
        child: Column(
          children: [
            SectionTitle(title: title ?? 'Construction'),
            if (wonder.construction.blocks != null)
              PortableText(blocks: wonder.construction.blocks!),
            Padding(
              padding: EdgeInsets.only(top: theme.spacing.s32),
              child: YoutubeVideoPlayer(
                videoId: wonder.video.videoId,
                aspectRatio: theme.aspectRatio.fourToThree,
              ),
            ),
            if (wonder.video.caption.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: theme.spacing.s8),
                child: Text(
                  wonder.video.caption,
                  style: theme.textTheme.labelMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
