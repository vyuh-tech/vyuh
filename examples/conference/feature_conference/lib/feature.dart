import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/speaker.dart';
import 'package:feature_conference/content/sponsor.dart';
import 'package:feature_conference/content/track.dart';
import 'package:feature_conference/content/venue.dart';
import 'package:feature_conference/routes.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';

import 'content/conference.dart';

final feature = FeatureDescriptor(
  name: 'feature_conference',
  title: 'Feature Conference',
  description: 'Describe your feature in more detail here.',
  icon: Icons.add_circle_outlined,
  init: () async {
    vyuh.di.register(ConferenceApi(vyuh.content.provider));
  },
  extensions: [
    ContentExtensionDescriptor(contentBuilders: [
      Conference.contentBuilder,
      Edition.contentBuilder,
      Session.contentBuilder,
      Speaker.contentBuilder,
      Track.contentBuilder,
      Venue.contentBuilder,
      Sponsor.contentBuilder,
    ]),
  ],
  routes: routes,
);
