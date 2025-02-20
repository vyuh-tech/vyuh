import 'package:json_annotation/json_annotation.dart';

part 'response_types.g.dart';

/// A class to represent a Sanity dataset.
@JsonSerializable(createToJson: false)
class SanityDataset {
  /// The name of the dataset.
  final String name;

  /// The ACL mode of the dataset.
  final String aclMode;

  /// Creates a new Sanity dataset with the given name and ACL mode.
  SanityDataset({required this.name, required this.aclMode});

  /// Creates a new Sanity dataset from a JSON map.
  factory SanityDataset.fromJson(final Map<String, dynamic> json) =>
      _$SanityDatasetFromJson(json);

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is SanityDataset && aclMode == other.aclMode && name == other.name;

  @override
  int get hashCode => (name + aclMode).hashCode;
}

/// A class to represent a Sanity response to a query.
@JsonSerializable()
class ServerResponse {
  /// The result of the query, which can be a null, object or array.
  final dynamic result;

  /// The time it took for the server to respond to the query.
  final int ms;

  /// The query that was sent to the server.
  final String query;

  final List<String> syncTags;

  /// Creates a new server response with the given result, time and query.
  ServerResponse({
    required this.result,
    required this.ms,
    required this.query,
    this.syncTags = const [],
  });

  /// Creates a new server response from a JSON map.
  factory ServerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerResponseFromJson(json);
}

/// A class that extracts various performance information from a Sanity response.
final class PerformanceInfo {
  /// The query that was sent to the server.
  final String query;

  /// The time it took for the server to respond to the query.
  final int serverTimeMs;

  /// The time it took for the client to process the response. This is the
  /// complete round-trip time.
  final int clientTimeMs;

  /// The shard that the query was sent to.
  final String shard;

  /// The age of the data that was returned in the response.
  final int age;

  /// Creates a new performance information object with the given query, server timing,
  /// client timing, shard and age.
  PerformanceInfo({
    required this.query,
    required this.serverTimeMs,
    required this.clientTimeMs,
    required this.shard,
    required this.age,
  });
}

/// A class that represents a Sanity query response.
final class SanityQueryResponse {
  /// The result of the query, which can be a null, object or array.
  final dynamic result;

  /// Sync Tags of the query, which will be used in case of a Live Fetch Query
  final List<String> syncTags;

  /// The performance information of the query.
  final PerformanceInfo info;

  /// Creates a new Sanity query response with the given result and performance information.
  SanityQueryResponse({
    required this.result,
    required this.info,
    this.syncTags = const [],
  });
}
