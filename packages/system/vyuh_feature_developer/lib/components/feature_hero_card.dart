import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

class FeatureHeroCard extends StatelessWidget {
  const FeatureHeroCard({
    super.key,
    required this.feature,
  });

  final FeatureDescriptor feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Hero(
              tag: feature.name,
              transitionOnUserGestures: true,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  feature.icon ?? Icons.question_mark_rounded,
                  size: 64,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    feature.name,
                    style: theme.textTheme.bodySmall
                        ?.apply(color: theme.disabledColor),
                  ),
                  if (feature.description != null)
                    Flexible(child: Text(feature.description!)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
