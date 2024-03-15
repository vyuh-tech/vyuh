import 'package:json_annotation/json_annotation.dart';

part 'response_types.g.dart';

@JsonSerializable(createToJson: false)
class SanityDataset {
  final String name;
  final String aclMode;

  SanityDataset({required this.name, required this.aclMode});

  factory SanityDataset.fromJson(final Map<String, dynamic> json) =>
      _$SanityDatasetFromJson(json);

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is SanityDataset && aclMode == other.aclMode && name == other.name;

  @override
  int get hashCode => (name + aclMode).hashCode;
}

@JsonSerializable()
class ServerResponse {
  final Map<String, dynamic>? result;
  final int ms;
  final String query;

  ServerResponse({
    required this.result,
    required this.ms,
    required this.query,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerResponseFromJson(json);
}

final class PerformanceInfo {
  final String query;
  final int serverTimeMs;
  final int clientTimeMs;
  final String shard;
  final int age;

  PerformanceInfo({
    required this.query,
    required this.serverTimeMs,
    required this.clientTimeMs,
    required this.shard,
    required this.age,
  });
}

final class SanityQueryResponse {
  final dynamic result;
  final PerformanceInfo info;

  SanityQueryResponse({required this.result, required this.info});
}
