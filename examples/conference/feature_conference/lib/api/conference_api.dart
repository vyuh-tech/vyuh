import 'package:vyuh_core/vyuh_core.dart';

import '../content/conference.dart';
import '../content/edition.dart';
import '../content/session.dart';
import '../content/speaker.dart';
import '../content/track.dart';

class ConferenceApi {
  final ContentProvider _provider;

  ConferenceApi(this._provider);

  Future<List<Conference>?> getConferences() async {
    final conferences = await _provider.fetchMultiple(
      '*[_type == "${Conference.schemaName}"]',
      fromJson: Conference.fromJson,
    );

    return conferences;
  }

  Future<List<Edition>?> getEditions({required String conferenceId}) async {
    final editions = await _provider.fetchMultiple(
      '''
      *[_type == "${Edition.schemaName}" && conference._ref == \$conferenceId]
    ''',
      queryParams: {
        'conferenceId': conferenceId,
      },
      fromJson: Edition.fromJson,
    );

    return editions;
  }

  Future<List<Session>?> getSessions({required String editionId}) async {
    final sessions = await _provider.fetchMultiple(
      '''
      *[_type == "${Session.schemaName}" && edition._ref == \$editionId] {
        ...,
        "speakers": speakers[]->,
        "tracks": tracks[]->
      }
    ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Session.fromJson,
    );

    return sessions;
  }

  Future<List<Speaker>?> getSpeakers({required String editionId}) async {
    final speakers = await _provider.fetchMultiple(
      '''
*[_type == "conf.speaker" && _id in array::unique(
    *[_type == "conf.session" && edition._ref == \$editionId] {
      "speakers": speakers[]->{_id}._id,
    }.speakers[]
  )
]
    ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Speaker.fromJson,
    );

    return speakers;
  }

  Future<List<Track>?> getTracks({required String editionId}) async {
    final tracks = await _provider.fetchMultiple(
      '''
      *[_type == "${Track.schemaName}" && edition._ref == \$editionId]
    ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Track.fromJson,
    );

    return tracks;
  }

  Future<Conference?> getConference({required String id}) async {
    final conference = await _provider.fetchSingle('''
      *[_type == "${Conference.schemaName}" && _id == \$id][0]
    ''', queryParams: {
      'id': id,
    }, fromJson: Conference.fromJson);
    return conference;
  }

  Future<Edition?> getEdition({required String id}) async {
    final edition = await _provider.fetchSingle('''
      *[_type == "${Edition.schemaName}" && _id == \$id][0]
    ''', queryParams: {
      'id': id,
    }, fromJson: Edition.fromJson);
    return edition;
  }

  Future<Session?> getSession({required String id}) async {
    final session = await _provider.fetchSingle('''
      *[_type == "${Session.schemaName}" && _id == \$id][0] {
        ...,
        "speakers": speakers[]->,
        "tracks": tracks[]->
      }
    ''', queryParams: {
      'id': id,
    }, fromJson: Session.fromJson);
    return session;
  }

  Future<Speaker?> getSpeaker({required String id}) async {
    final speaker = await _provider.fetchSingle('''
      *[_type == "${Speaker.schemaName}" && _id == \$id][0]
    ''', queryParams: {
      'id': id,
    }, fromJson: Speaker.fromJson);
    return speaker;
  }

  Future<Track?> getTrack({required String id}) async {
    final track = await _provider.fetchSingle('''
      *[_type == "${Track.schemaName}" && _id == "\$id"][0]
    ''', queryParams: {
      'id': id,
    }, fromJson: Track.fromJson);
    return track;
  }
}
