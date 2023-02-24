import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_credentials.dart';
import '../../models/call_metadata.dart';

@immutable
abstract class CoordinatorModel with EquatableMixin {
  const CoordinatorModel();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

class CoordinatorJoined extends CoordinatorModel {
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

class SfuServerSelected extends CoordinatorModel {
  const SfuServerSelected({
    required this.metadata,
    required this.credentials,
  });

  final CallMetadata metadata;
  final CallCredentials credentials;

  @override
  List<Object?> get props => [credentials, metadata];
}

class SfuEdge extends CoordinatorModel {
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

class SfuCoordinates extends CoordinatorModel {
  const SfuCoordinates({
    this.lat,
    this.lng,
  });

  final double? lat;
  final double? lng;

  @override
  List<Object?> get props => [lat, lng];
}

class SfuLatency extends CoordinatorModel {
  const SfuLatency({
    required this.measurementsSeconds,
  });

  final List<double> measurementsSeconds;

  @override
  List<Object?> get props => [measurementsSeconds];
}
