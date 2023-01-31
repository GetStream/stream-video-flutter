import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../webrtc/model/rtc_video_dimension.dart';

@immutable
abstract class CallTrackStatus implements Comparable<CallTrackStatus> {
  const CallTrackStatus();
  factory CallTrackStatus.published() => _TrackStatusPublished();
  factory CallTrackStatus.subscribed([RtcVideoDimension? dimension]) =>
      _TrackStatusSubscribed(dimension);
  factory CallTrackStatus.received([RtcVideoDimension? dimension]) =>
      _TrackStatusReceived(dimension);

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
  factory _TrackStatusPublished() {
    return _instance;
  }
  const _TrackStatusPublished._internal();
  static const _TrackStatusPublished _instance =
      _TrackStatusPublished._internal();
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
  const _TrackStatusSubscribed(this.dimension);

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
  const _TrackStatusReceived(this.dimension);

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
