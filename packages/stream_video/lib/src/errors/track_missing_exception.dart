import '../sfu/data/models/sfu_track_type.dart';

class TrackMissingException implements Exception {
  TrackMissingException({required this.trackType});
  final SfuTrackType trackType;

  @override
  String toString() {
    return 'TrackMissingException: Track with type "$trackType" is missing.';
  }
}
