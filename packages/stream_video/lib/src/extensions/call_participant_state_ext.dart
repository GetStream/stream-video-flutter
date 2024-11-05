import '../models/call_participant_state.dart';
import '../models/call_track_state.dart';
import '../sfu/data/models/sfu_subscription_details.dart';
import '../sfu/data/models/sfu_track_type.dart';

extension CallParticipantStateListEx on List<CallParticipantState> {
  Map<String, SfuSubscriptionDetails> getSubscriptions({
    Set<SfuTrackType> exclude = const {},
  }) {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final participant in this) {
      // We only care about remote participants.
      if (participant.isLocal) continue;

      subscriptions.addAll(
        participant.getSubscriptions(exclude: exclude),
      );
    }

    return subscriptions;
  }
}

extension CallParticipantStateEx on CallParticipantState {
  Map<String, SfuSubscriptionDetails> getSubscriptions({
    Set<SfuTrackType> exclude = const {},
  }) {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final trackType in publishedTracks.keys) {
      final trackState = publishedTracks[trackType];

      // We only care about remote tracks.
      if (trackState is! RemoteTrackState) continue;

      // Continue if we should exclude this trackType.
      final shouldExclude = exclude.contains(trackType);
      if (shouldExclude) continue;

      // We only care about tracks that are subscribed.
      if (!trackState.subscribed) continue;

      final detail = SfuSubscriptionDetails(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        dimension: trackState.videoDimension,
      );

      subscriptions[detail.trackId] = detail;
    }

    return subscriptions;
  }
}
