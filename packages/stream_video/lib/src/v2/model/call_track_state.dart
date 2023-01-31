import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../webrtc/model/rtc_video_dimension.dart';

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
