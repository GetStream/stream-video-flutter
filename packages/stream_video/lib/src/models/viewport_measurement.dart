import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../sfu/data/models/sfu_track_type.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import 'viewport_visibility.dart';

/// The track a viewport measurement is about.
@immutable
class ViewportTrack extends Equatable {
  const ViewportTrack({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackType,
  });

  final String userId;
  final String sessionId;
  final String trackIdPrefix;
  final SfuTrackTypeVideo trackType;

  @override
  List<Object?> get props => [userId, sessionId, trackIdPrefix, trackType];

  @override
  String toString() => 'ViewportTrack{$sessionId, $trackType}';
}

/// What one viewport measures for the track it draws.
@immutable
class ViewportMeasurement extends Equatable {
  const ViewportMeasurement({
    required this.visibility,
    this.dimension = const RtcVideoDimension.zero(),
    this.persistWhenHidden = false,
  }) : assert(
         visibility != ViewportVisibility.unknown,
         'a viewport reports what it measures, not that it does not know',
       );

  /// Whether this viewport has the track on screen.
  final ViewportVisibility visibility;

  /// The size this viewport draws the track at, in device pixels. Empty while
  /// it draws none.
  final RtcVideoDimension dimension;

  /// Whether this viewport wants the track kept while hidden, as a screen
  /// share does.
  final bool persistWhenHidden;

  @override
  List<Object?> get props => [visibility, dimension, persistWhenHidden];

  @override
  String toString() {
    return 'ViewportMeasurement{$visibility, $dimension'
        '${persistWhenHidden ? ', persists' : ''}}';
  }
}

/// What every viewport measuring a track adds up to: what the call records
/// for it, and what it is subscribed at.
@immutable
class ViewportAggregate extends Equatable {
  const ViewportAggregate({
    required this.track,
    required this.visibility,
    required this.dimension,
    required this.persistWhenHidden,
  });

  final ViewportTrack track;

  /// Visible while any viewport has the track on screen. Never
  /// [ViewportVisibility.unknown].
  final ViewportVisibility visibility;

  /// The largest size any viewport showing the track draws it at, which is
  /// what has to be subscribed. Empty while none shows it.
  final RtcVideoDimension dimension;

  /// Whether any viewport wants the track kept while it is hidden.
  final bool persistWhenHidden;

  @override
  List<Object?> get props => [track, visibility, dimension, persistWhenHidden];

  @override
  String toString() {
    return 'ViewportAggregate{$track, $visibility, $dimension}';
  }
}
