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
  ],
  contentSchemaModifiers: [
    new DefaultFieldsModifier({
      excludedSchemaTypes: [
        { type: docConference.name },
        { type: edition.name },
        { type: session.name },
        { type: track.name },
        { type: speaker.name },
        { type: schedule.name },
        { type: scheduleDay.name },
        { type: confBreak.name },
      ],
    }),
  ],
});
