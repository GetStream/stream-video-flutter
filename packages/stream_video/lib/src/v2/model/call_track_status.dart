import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../stream_video.dart';

@immutable
abstract class CallTrackStatus {
  const CallTrackStatus();
  factory CallTrackStatus.published() => _TrackStatusPublished();
  factory CallTrackStatus.subscribed() => _TrackStatusSubscribedImpl();
  factory CallTrackStatus.subscribedVideo(RtcVideoDimension dimension) =>
      _TrackStatusSubscribedVideo(
        dimension,
      );
  factory CallTrackStatus.received() => _TrackStatusReceivedImpl();
  factory CallTrackStatus.receivedVideo(RtcVideoDimension dimension) =>
      _TrackStatusReceivedVideo(
        dimension,
      );
}

abstract class _HasDimension extends CallTrackStatus {
  const _HasDimension(this.dimension);

  final RtcVideoDimension dimension;
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
}

abstract class _TrackStatusSubscribed extends CallTrackStatus {
  const _TrackStatusSubscribed();
}

class _TrackStatusSubscribedImpl extends _TrackStatusSubscribed {
  factory _TrackStatusSubscribedImpl() {
    return _instance;
  }
  const _TrackStatusSubscribedImpl._internal();
  static const _TrackStatusSubscribedImpl _instance =
      _TrackStatusSubscribedImpl._internal();
  @override
  String toString() {
    return 'subscribed';
  }
}

class _TrackStatusSubscribedVideo extends _TrackStatusSubscribed
    with EquatableMixin
    implements _HasDimension {
  const _TrackStatusSubscribedVideo(this.dimension);

  @override
  final RtcVideoDimension dimension;

  @override
  String toString() {
    return 'subscribed(${dimension.width}-${dimension.height})';
  }

  @override
  List<Object?> get props => [dimension];
}

abstract class _TrackStatusReceived extends CallTrackStatus {
  const _TrackStatusReceived();
}

class _TrackStatusReceivedImpl extends _TrackStatusReceived {
  factory _TrackStatusReceivedImpl() {
    return _instance;
  }
  const _TrackStatusReceivedImpl._internal();
  static const _TrackStatusReceivedImpl _instance =
      _TrackStatusReceivedImpl._internal();
  @override
  String toString() {
    return 'received';
  }
}

class _TrackStatusReceivedVideo extends _TrackStatusReceived
    with EquatableMixin
    implements _HasDimension {
  const _TrackStatusReceivedVideo(this.dimension);

  @override
  final RtcVideoDimension dimension;

  @override
  String toString() {
    return 'received(${dimension.width}-${dimension.height})';
  }

  @override
  List<Object?> get props => [dimension];
}

extension DimensionExtension on CallTrackStatus {
  RtcVideoDimension? get dimensionOrNull {
    if (this is _HasDimension) {
      return (this as _HasDimension).dimension;
    }
    return null;
  }
}
