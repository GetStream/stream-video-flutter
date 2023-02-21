import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_credentials.dart';
import '../../models/call_metadata.dart';

@immutable
abstract class CoordinatorModelV2 with EquatableMixin {
  const CoordinatorModelV2();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

class CoordinatorJoined extends CoordinatorModelV2 {
  const CoordinatorJoined({
    required this.wasCreated,
    required this.metadata,
    required this.edges,
  });

  final bool wasCreated;
  final CallMetadata metadata;
  final List<SfuEdge> edges;

  @override
  List<Object?> get props => [wasCreated, metadata, edges];
}

class SfuServerSelected extends CoordinatorModelV2 {
  const SfuServerSelected({
    required this.metadata,
    required this.credentials,
  });

  final CallMetadata metadata;
  final CallCredentials credentials;

  @override
  List<Object?> get props => [credentials, metadata];
}

class SfuEdge extends CoordinatorModelV2 {
  const SfuEdge({
    required this.name,
    required this.latencyUrl,
    this.coordinates,
  });

  final String name;
  final String latencyUrl;
  final SfuCoordinates? coordinates;

  @override
  List<Object?> get props => [name, latencyUrl, coordinates];
}

class SfuCoordinates extends CoordinatorModelV2 {
  const SfuCoordinates({
    this.lat,
    this.lng,
  });

  final double? lat;
  final double? lng;

  @override
  List<Object?> get props => [lat, lng];
}

class SfuLatency extends CoordinatorModelV2 {
  const SfuLatency({
    required this.measurementsSeconds,
  });

  final List<double> measurementsSeconds;

  @override
  List<Object?> get props => [measurementsSeconds];
}
