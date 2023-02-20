import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/src/webrtc/media/constraints/camera_position.dart';

import '../webrtc/model/rtc_video_dimension.dart';

@immutable
abstract class TrackState with EquatableMixin {
  const TrackState({required this.muted});

  factory TrackState.local({
    bool muted = false,
    String? deviceId,
    CameraPosition? cameraPosition,
  }) {
    return LocalTrackState._(
      muted: muted,
      deviceId: deviceId,
      cameraPosition: cameraPosition,
    );
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
  const LocalTrackState._({
    required super.muted,
    this.deviceId,
    this.cameraPosition,
  });

  /// The deviceId of the capture device to use.
  final String? deviceId;

  /// The camera position of the track in case it is a video track.
  final CameraPosition? cameraPosition;

  @override
  List<Object?> get props => [muted, deviceId, cameraPosition];

  @override
  String toString() {
    final fields = [
      if (muted) 'muted',
      if (deviceId != null) 'deviceId($deviceId)',
      if (cameraPosition != null) 'camera($cameraPosition)',
    ];
    if (fields.isEmpty) {
      return 'published';
    }
    return fields.join(', ');
  }

  /// Returns a copy of this [LocalTrackState] with the given fields
  /// replaced with the new values.
  @override
  LocalTrackState copyWith({
    bool? muted,
    String? deviceId,
    CameraPosition? cameraPosition,
  }) {
    return LocalTrackState._(
      muted: muted ?? this.muted,
      deviceId: deviceId ?? this.deviceId,
      cameraPosition: cameraPosition ?? this.cameraPosition,
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
    final fields = [
      if (subscribed) 'subscribed',
      if (received) 'received',
      if (muted) 'muted',
      if (videoDimension != null)
        'videoDimension(width: ${videoDimension!.width}, height: ${videoDimension!.height})',
    ];

    if (fields.isEmpty) {
      return 'published';
    }

    return fields.join(', ');
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
