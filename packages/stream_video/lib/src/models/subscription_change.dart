import '../../stream_video.dart';
import '../sfu/data/models/sfu_subscription_details.dart';

class SubscriptionChange {
  SubscriptionChange.set({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackTypes,
  }) : subscribed = true;

  SubscriptionChange.update({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackType,
    this.videoDimension,
  })  : trackId = '$trackIdPrefix:$trackType',
        subscribed = true;

  SubscriptionChange.remove({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackType,
  })  : trackId = '$trackIdPrefix:$trackType',
        subscribed = true;

  final String userId;
  final String sessionId;
  final String trackIdPrefix;
  final bool subscribed;

  SfuTrackTypeVideo? trackType;
  String? trackId;
  Map<SfuTrackTypeVideo, RtcVideoDimension>? trackTypes;
  RtcVideoDimension? videoDimension;

  SfuSubscriptionDetails toSubscription() {
    return SfuSubscriptionDetails(
      userId: userId,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      trackType: trackType!,
      dimension: videoDimension,
    );
  }

  Map<String, SfuSubscriptionDetails> getSubscriptions() {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final trackType in trackTypes!.keys) {
      final dimension = trackTypes![trackType];

      final detail = SfuSubscriptionDetails(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        dimension: dimension,
      );

      subscriptions[detail.trackId] = detail;
    }

    return subscriptions;
  }
}
