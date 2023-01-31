import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../webrtc/model/rtc_video_dimension.dart';

@immutable
abstract class CallTrackStatus implements Comparable<CallTrackStatus> {
  const CallTrackStatus();
  const factory CallTrackStatus.published() = _TrackStatusPublished;
  const factory CallTrackStatus.subscribed([RtcVideoDimension? dimension]) =
      _TrackStatusSubscribed;
  const factory CallTrackStatus.received([RtcVideoDimension? dimension]) =
      _TrackStatusReceived;

  R when<R extends Object?>({
    required R Function() published,
    required R Function(RtcVideoDimension? dimension) subscribed,
    required R Function(RtcVideoDimension? dimension) received,
  }) {
    if (this is _TrackStatusPublished) {
      return published();
    } else if (this is _TrackStatusSubscribed) {
      return subscribed((this as _TrackStatusSubscribed).dimension);
    } else if (this is _TrackStatusReceived) {
      return received((this as _TrackStatusReceived).dimension);
    } else {
      throw StateError('Unknown CallTrackStatus');
    }
  }

  int get order;

  bool get isPublished => this is _TrackStatusPublished;
  bool get isSubscribed => this is _TrackStatusSubscribed;
  bool get isReceived => this is _TrackStatusReceived;

  bool atLeast(CallTrackStatus status) {
    return false;
  }

  @override
  int compareTo(CallTrackStatus other) {
    return order.compareTo(other.order);
  }
}

abstract class _HasDimension {
  const _HasDimension(this.dimension);

  final RtcVideoDimension? dimension;
}

class _TrackStatusPublished extends CallTrackStatus {
  const _TrackStatusPublished();
  @override
  String toString() {
    return 'published';
  }

  @override
  int get order => 1;
}

class _TrackStatusSubscribed extends CallTrackStatus
    with EquatableMixin
    implements _HasDimension {
  const _TrackStatusSubscribed([this.dimension]);

  @override
  final RtcVideoDimension? dimension;

  @override
  String toString() {
    final dimension = this.dimension;
    if (dimension != null) {
      return 'subscribed(${dimension.width}-${dimension.height})';
    }
    return 'subscribed';
  }

  @override
  List<Object?> get props => [dimension];

  @override
  int get order => 2;
}

class _TrackStatusReceived extends CallTrackStatus
    with EquatableMixin
    implements _HasDimension {
  const _TrackStatusReceived([this.dimension]);

  @override
  final RtcVideoDimension? dimension;

  @override
  String toString() {
    final dimension = this.dimension;
    if (dimension != null) {
      return 'received(${dimension.width}-${dimension.height})';
    }
    return 'received';
  }

  @override
  List<Object?> get props => [dimension];

  @override
  int get order => 3;
}

extension DimensionExtension on CallTrackStatus {
  RtcVideoDimension? get dimensionOrNull {
    if (this is _HasDimension) {
      return (this as _HasDimension).dimension;
    }
    return null;
  }
}
