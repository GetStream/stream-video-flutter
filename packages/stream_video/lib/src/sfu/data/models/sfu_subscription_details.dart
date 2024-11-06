import 'package:equatable/equatable.dart';

import '../../../../stream_video.dart';

class SfuSubscriptionDetails with EquatableMixin {
  const SfuSubscriptionDetails({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackType,
    this.dimension,
  }) : trackId = '$trackIdPrefix:$trackType';

  final String userId;
  final String sessionId;
  final String trackIdPrefix;
  final SfuTrackType trackType;
  final RtcVideoDimension? dimension;

  final String trackId;

  SfuSubscriptionDetails copyWith({
    String? userId,
    String? sessionId,
    String? trackIdPrefix,
    SfuTrackType? trackType,
    RtcVideoDimension? dimension,
  }) {
    return SfuSubscriptionDetails(
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      dimension: dimension ?? this.dimension,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        userId,
        sessionId,
        trackIdPrefix,
        trackType,
        dimension,
      ];
}
