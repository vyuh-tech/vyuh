import 'package:design_system/utils/extensions.dart';
import 'package:feature_wonderous/api/wonder.dart';
import 'package:feature_wonderous/ui/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final class WonderLocationInfoSection extends StatelessWidget {
  final String? title;
  final Wonder wonder;

  const WonderLocationInfoSection(
      {super.key, this.title, required this.wonder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WonderSection(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.s16),
        child: Column(
          children: [
            SectionTitle(title: title ?? 'Location Info'),
            if (wonder.locationInfo.blocks != null)
              PortableText(blocks: wonder.locationInfo.blocks!),
            QuoteBlock(
              text: wonder.secondaryQuote.text,
              author: wonder.secondaryQuote.author,
              color: wonder.color,
              textColor: wonder.textColor,
              backdropImage: wonder.icon,
            ),
            SizedBox(
              height: 300,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    wonder.location.latitude,
                    wonder.location.longitude,
                  ),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('wonder'),
                    position: LatLng(
                      wonder.location.latitude,
                      wonder.location.longitude,
                    ),
                    infoWindow: InfoWindow(
                      title: wonder.title,
                      snippet: wonder.location.place,
                    ),
                  ),
                },
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
