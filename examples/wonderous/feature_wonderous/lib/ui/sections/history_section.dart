import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

final class WonderHistorySection extends StatelessWidget {
  final String? title;
  final Wonder wonder;

  const WonderHistorySection({super.key, this.title, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WonderSection(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.s16),
        child: Column(
          children: [
            SectionTitle(title: title ?? 'History'),
            QuoteBlock(
              text: wonder.primaryQuote.text,
              author: wonder.primaryQuote.author,
              color: wonder.color,
              textColor: wonder.textColor,
              backdropImage: wonder.backdropImage,
            ),
            if (wonder.history.blocks != null)
              PortableText(blocks: wonder.history.blocks!),
          ],
        ),
      ),
    );
  }
}
