import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../webrtc/model/rtc_video_dimension.dart';

abstract class TrackState {
  const TrackState({required this.muted});

  const factory TrackState.local({required bool muted}) = LocalTrackState._;

  factory TrackState.remote({
    bool muted = false,
    bool subscribed = false,
    bool received = false,
    RtcVideoDimension? videoDimension,
  }) {
    return RemoteTrackState._(
      muted: muted,
      subscribed: subscribed,
      received: received,
      videoDimension: videoDimension,
    );
  }

  final bool muted;
}

class LocalTrackState extends TrackState {
  const LocalTrackState._({required super.muted});
}

class RemoteTrackState extends TrackState {
  RemoteTrackState._({
    required super.muted,
    this.subscribed = false,
    this.received = false,
    this.videoDimension,
  });

  final bool subscribed;
  final bool received;
  final RtcVideoDimension? videoDimension;
}

@immutable
class CallTrackState with EquatableMixin {
  const CallTrackState({
    this.subscribed = false,
    this.received = false,
    this.muted = false,
    this.videoDimension,
  });

  final bool subscribed;
  final bool received;
  final bool muted;
  final RtcVideoDimension? videoDimension;

  @override
  List<Object?> get props => [subscribed, received, muted, videoDimension];

  @override
  String toString() {
    final buffer = StringBuffer();
    if (subscribed) buffer.write('subscribed');
    if (received) buffer.write(', received');
    if (muted) buffer.write(', muted');
    final dimension = videoDimension;
    if (dimension != null) {
      buffer.write(', size(');
      buffer.write(dimension.width);
      buffer.write('-');
      buffer.write(dimension.height);
      buffer.write(')');
    }
    return buffer.toString();
  }

  /// Returns a copy of this [CallTrackState] with the given fields
  /// replaced with the new values.
  CallTrackState copyWith({
    bool? subscribed,
    bool? received,
    bool? muted,
    RtcVideoDimension? videoDimension,
  }) {
    return CallTrackState(
      subscribed: subscribed ?? this.subscribed,
      received: received ?? this.received,
      muted: muted ?? this.muted,
      videoDimension: videoDimension ?? this.videoDimension,
    );
  }
}
