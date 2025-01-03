import 'package:vyuh_core/vyuh_core.dart';

import '../content/conference.dart';
import '../content/edition.dart';
import '../content/room.dart';
import '../content/session.dart';
import '../content/speaker.dart';
import '../content/sponsor.dart';
import '../content/track.dart';
import '../content/venue.dart';

class ConferenceApi {
  final ContentProvider _provider;

  ConferenceApi(this._provider);

  Future<List<Conference>> conferences() async {
    final conferences = await _provider.fetchMultiple(
      '''
*[_type == "${Conference.schemaName}"]{
  ...,
  "slug": slug.current
}
''',
      fromJson: Conference.fromJson,
    );

    return conferences ?? [];
  }

  Future<Conference?> conference({required String conferenceId}) async {
    final conference = await _provider.fetchSingle(
      '''
      *[_type == "${Conference.schemaName}" && _id == \$conferenceId]{
        ...,
        "slug": slug.current
      }[0]
      ''',
      queryParams: {
        'conferenceId': conferenceId,
      },
      fromJson: Conference.fromJson,
    );

    return conference;
  }

  Future<List<Edition>> editions({required String conferenceId}) async {
    final editions = await _provider.fetchMultiple(
      '''
      *[_type == "${Edition.schemaName}" && references(\$conferenceId)]{
        ...,
        "slug": slug.current,
        "sponsors": null,
        "venue": venue->{
          _id,
          title,
          "slug": slug.current,
        },
      } | order(startDate desc)
    ''',
      queryParams: {
        'conferenceId': conferenceId,
      },
      fromJson: Edition.fromJson,
    );

    return editions ?? [];
  }

  Future<Edition?> edition({required String id}) async {
    final edition = await _provider.fetchSingle('''
      *[_type == "${Edition.schemaName}" && _id == \$id][0] {
        ...,
        "slug": slug.current,
        "venue": venue->{
          ...,
          "slug": slug.current,
          "rooms": rooms[]{
            ...,
            "slug": slug.current,
          }
        },
        "sponsors": sponsors[]{
          ...,
          "sponsor": sponsor->{
            ...,
            "slug": slug.current
          },
        }
      }
    ''', queryParams: {
      'id': id,
    }, fromJson: Edition.fromJson);
    return edition;
  }

  Future<List<Session>> sessions({
    required String editionId,
    String? trackId,
    String? speakerId,
  }) async {
    final sessions = await _provider.fetchMultiple(
      '''
      *[
        _type == "${Session.schemaName}" 
        && references(\$editionId)
        ${trackId != null ? '&& references(\$trackId)' : ''}
        ${speakerId != null ? '&& references(\$speakerId)' : ''}
      ]{
        ...,
        "slug": slug.current,
        "speakers": speakers[]->{
          ...,
          "slug": slug.current,
        },
        "tracks": tracks[]->{
          ...,
          "slug": slug.current,
        }
      } | order(startDate desc)
      ''',
      queryParams: {
        'editionId': editionId,
        if (trackId != null) 'trackId': trackId,
        if (speakerId != null) 'speakerId': speakerId,
      },
      fromJson: Session.fromJson,
    );

    return sessions ?? [];
  }

  Future<Session?> session({required String id}) async {
    final session = await _provider.fetchSingle('''
      *[_type == "${Session.schemaName}" && _id == \$id][0] {
        ...,
        "slug": slug.current,
        "slug": slug.current,
        "speakers": speakers[]->{
          ...,
          "slug": slug.current,
        },
        "tracks": tracks[]->{
          ...,
          "slug": slug.current,
        }
      }
    ''', queryParams: {
      'id': id,
    }, fromJson: Session.fromJson);

    return session;
  }

  Future<List<Speaker>> speakers({required String editionId}) async {
    final speakers = await _provider.fetchMultiple(
      '''
*[_type == "${Speaker.schemaName}" && _id in array::unique(
    *[_type == "${Session.schemaName}" && references(\$editionId)] {
      "speakers": speakers[]->{_id}._id,
    }.speakers[]
  )
]{
  ...,
  "slug": slug.current
}
    ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Speaker.fromJson,
    );

    return speakers ?? [];
  }

  Future<Speaker?> speaker({required String id}) async {
    final speaker = await _provider.fetchSingle(
      '''
      *[_type == "${Speaker.schemaName}" && _id == \$id][0] {
        ...,
        "slug": slug.current,
      }
      ''',
      queryParams: {'id': id},
      fromJson: Speaker.fromJson,
    );

    return speaker;
  }

  Future<List<Track>> tracks({required String editionId}) async {
    final tracks = await _provider.fetchMultiple(
      '''
*[_type == "${Track.schemaName}" && _id in array::unique(
    *[_type == "${Session.schemaName}" && references(\$editionId)] {
      "tracks": tracks[]->{_id}._id,
    }.tracks[]
  )
]{
  ...,
  "slug": slug.current,
}
    ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Track.fromJson,
    );

    return tracks ?? [];
  }

  Future<Track?> track({required String id}) async {
    final track = await _provider.fetchSingle(
      '''
      *[_type == "${Track.schemaName}" && _id == \$id][0] {
        ...,
        "slug": slug.current,
      }
      ''',
      queryParams: {'id': id},
      fromJson: Track.fromJson,
    );

    return track;
  }

  Future<List<Sponsor>>? sponsors({required String editionId}) async {
    final sponsors = await _provider.fetchMultiple(
      '''
      *[_type == "${Sponsor.schemaName}" && references(\$editionId)]{
        ...,
        "slug": slug.current
      }
      ''',
      queryParams: {
        'editionId': editionId,
      },
      fromJson: Sponsor.fromJson,
    );

    return sponsors ?? [];
  }

  Future<List<Room>> rooms({required String venueId}) async {
    final rooms = await _provider.fetchMultiple(
      '''
      *[_type == "${Venue.schemaName}" && _id == \$venueId]{
        rooms
      }
      ''',
      queryParams: {
        'venueId': venueId,
      },
      fromJson: Room.fromJson,
    );

    return rooms ?? [];
  }
}
