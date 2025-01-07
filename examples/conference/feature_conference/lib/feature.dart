import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'api/conference_api.dart';
import 'content/conference.dart';
import 'content/edition.dart';
import 'content/session.dart';
import 'content/speaker.dart';
import 'content/sponsor.dart';
import 'content/track.dart';
import 'content/venue.dart';
import 'layouts/conference_card_layout.dart';
import 'layouts/conference_layout.dart';
import 'layouts/edition_layout.dart';
import 'layouts/edition_summary_layout.dart';
import 'layouts/session_layout.dart';
import 'layouts/session_summary_layout.dart';
import 'layouts/speaker_chip_layout.dart';
import 'layouts/speaker_layout.dart';
import 'layouts/sponsor_layout.dart';
import 'layouts/track_chip_layout.dart';
import 'layouts/track_layout.dart';
import 'layouts/venue_layout.dart';
import 'routes.dart';

final feature = FeatureDescriptor(
  name: 'feature_conference',
  title: 'Feature Conference',
  description: 'Describe your feature in more detail here.',
  icon: Icons.add_circle_outlined,
  init: () async {
    vyuh.di.register(ConferenceApi(vyuh.content.provider));
  },
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        Conference.descriptor(
          layouts: [
            ConferenceLayout.typeDescriptor,
            ConferenceCardLayout.typeDescriptor,
          ],
        ),
        Edition.descriptor(
          layouts: [
            EditionLayout.typeDescriptor,
            EditionSummaryLayout.typeDescriptor,
          ],
        ),
        Session.descriptor(
          layouts: [
            SessionLayout.typeDescriptor,
            SessionSummaryLayout.typeDescriptor,
          ],
        ),
        Speaker.descriptor(
          layouts: [
            SpeakerLayout.typeDescriptor,
            SpeakerChipLayout.typeDescriptor,
          ],
        ),
        Track.descriptor(
          layouts: [
            TrackLayout.typeDescriptor,
            TrackChipLayout.typeDescriptor,
          ],
        ),
        Venue.descriptor(
          layouts: [
            VenueLayout.typeDescriptor,
          ],
        ),
        Sponsor.descriptor(
          layouts: [
            SponsorLayout.typeDescriptor,
          ],
        ),
      ],
      contentBuilders: [
        Conference.contentBuilder,
        Edition.contentBuilder,
        Session.contentBuilder,
        Speaker.contentBuilder,
        Track.contentBuilder,
        Venue.contentBuilder,
        Sponsor.contentBuilder,
      ],
    ),
  ],
  routes: routes,
);
