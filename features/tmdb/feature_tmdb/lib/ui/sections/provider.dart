import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class ProviderView extends StatelessWidget {
  const ProviderView({
    super.key,
    required this.provider,
  });

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (provider.logoImage != null)
          ContentImage(
            url: provider.logoImage,
            width: theme.sizing.s12,
            height: theme.sizing.s4,
            fit: BoxFit.contain,
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.name,
              style: theme.tmdbTheme.bodySmall,
            ),
            if (provider.originCountry != null)
              Padding(
                padding: EdgeInsets.only(left: theme.spacing.s2),
                child: Text(
                  '(${provider.originCountry!})',
                  style: theme.tmdbTheme.bodySmall,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
