import {
  BuiltContentSchemaBuilder,
  DefaultFieldsModifier,
  FeatureDescriptor,
} from '@vyuh/sanity-schema-core';
import { DocumentDescriptor } from '@vyuh/sanity-schema-system';
import { conference as docConference } from './documents/conference.ts';
import { edition } from './documents/edition.ts';
import { session } from './documents/session.ts';
import { speaker } from './documents/speaker.ts';
import { track } from './documents/track.ts';
import { confBreak, schedule, scheduleDay } from './documents/schedule.ts';
import { sponsor } from './documents/sponsor.ts';
import { venue } from './documents/venue.ts';
import { room } from './documents/room.ts';

export const schemaTypes = [
  docConference,
  edition,
  session,
  speaker,
  sponsor,
  track,
  venue,
  room,
];

export const conference = new FeatureDescriptor({
  name: 'conf',
  title: 'Conferences',
  description: 'The Conferences feature to manage conference data',
  contents: [
    new DocumentDescriptor({
      documentTypes: [
        { type: docConference.name },
        { type: edition.name },
        { type: session.name },
        { type: speaker.name },
        { type: track.name },
        { type: schedule.name },
        { type: sponsor.name },
        { type: venue.name },
        { type: room.name },
      ],
    }),
  ],
  contentSchemaBuilders: [
    new BuiltContentSchemaBuilder(docConference),
    new BuiltContentSchemaBuilder(edition),
    new BuiltContentSchemaBuilder(session),
    new BuiltContentSchemaBuilder(speaker),
    new BuiltContentSchemaBuilder(track),
    new BuiltContentSchemaBuilder(schedule),
    new BuiltContentSchemaBuilder(scheduleDay),
    new BuiltContentSchemaBuilder(confBreak),
    new BuiltContentSchemaBuilder(sponsor),
    new BuiltContentSchemaBuilder(venue),
    new BuiltContentSchemaBuilder(room),
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [
        { type: docConference.name },
        { type: edition.name },
        { type: session.name },
        { type: speaker.name },
        { type: track.name },
        { type: schedule.name },
        { type: scheduleDay.name },
        { type: confBreak.name },
        { type: sponsor.name },
        { type: venue.name },
        { type: room.name },
      ],
    }),
  ],
});
