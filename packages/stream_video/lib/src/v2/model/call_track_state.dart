import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../webrtc/model/rtc_video_dimension.dart';

@immutable
abstract class TrackState with EquatableMixin {
  const TrackState({required this.muted});

  factory TrackState.local({
    bool muted = false,
  }) {
    return LocalTrackState._(muted: muted);
  }

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

  factory TrackState.base({
    required bool isLocal,
  }) {
    if (isLocal) {
      return TrackState.local();
    } else {
      return TrackState.remote();
    }
  }

  final bool muted;

  /// Returns a copy of this [TrackState] with the given fields
  /// replaced with the new values.
  TrackState copyWith({
    bool? muted,
  }) {
    if (this is LocalTrackState) {
      return (this as LocalTrackState).copyWith(muted: muted);
    } else if (this is RemoteTrackState) {
      return (this as RemoteTrackState).copyWith(muted: muted);
    }
    throw UnsupportedError('unexpected state: $runtimeType');
  }
}

class LocalTrackState extends TrackState {
  const LocalTrackState._({required super.muted});

  @override
  List<Object?> get props => [muted];

  @override
  String toString() {
    if (muted) {
      return 'muted';
    }
    return 'published';
  }

  /// Returns a copy of this [LocalTrackState] with the given fields
  /// replaced with the new values.
  @override
  LocalTrackState copyWith({
    bool? muted,
  }) {
    return LocalTrackState._(
      muted: muted ?? this.muted,
    );
  }
}

class RemoteTrackState extends TrackState {
  const RemoteTrackState._({
    required super.muted,
    this.subscribed = false,
    this.received = false,
    this.videoDimension,
  });

  final bool subscribed;
  final bool received;
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
    if (buffer.isEmpty) {
      return 'published';
    }
    return buffer.toString();
  }

  /// Returns a copy of this [RemoteTrackState] with the given fields
  /// replaced with the new values.
  @override
  RemoteTrackState copyWith({
    bool? subscribed,
    bool? received,
    bool? muted,
    RtcVideoDimension? videoDimension,
  }) {
    return RemoteTrackState._(
      subscribed: subscribed ?? this.subscribed,
      received: received ?? this.received,
      muted: muted ?? this.muted,
      videoDimension: videoDimension ?? this.videoDimension,
    );
  }
}
