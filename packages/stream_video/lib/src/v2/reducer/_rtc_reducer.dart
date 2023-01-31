import '../../logger/stream_logger.dart';
import '../action/rtc_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../model/call_track_status.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../webrtc/model/rtc_video_dimension.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-RTC');

class RtcReducer {
  const RtcReducer();

  CallStateV2 reduce(
    CallStateV2 state,
    RtcAction action,
  ) {
    if (action is SubscriberTrackReceivedAction) {
      return _reduceSubscriberTrackReceived(state, action);
    }
    return state;
  }

  CallStateV2 _reduceSubscriberTrackReceived(
    CallStateV2 state,
    SubscriberTrackReceivedAction action,
  ) {
    _logger.d(
      () => '[reduceSubTrackReceived] ${state.sessionId}; action: $action',
    );
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.trackIdPrefix == action.trackIdPrefix) {
          _logger.v(
            () => '[reduceSubTrackReceived] pFound: $participant',
          );
          return participant.copyWith(
            published: {
              ...participant.published,
              action.trackType: asReceived(participant, action)
            },
          );
        } else {
          _logger.v(() => '[reduceSubTrackReceived] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }

  CallTrackStatus asReceived(
    CallParticipantStateV2 participant,
    SubscriberTrackReceivedAction action,
  ) {
    if (action.trackType == SfuTrackType.audio ||
        action.trackType == SfuTrackType.screenShareAudio ||
        action.trackType == SfuTrackType.unspecified) {
      return CallTrackStatus.received();
    }
    final userId = participant.userId;
    final published = participant.published;
    final trackStatus = participant.published[action.trackType];
    if (trackStatus == null) {
      _logger.w(() => '[asReceived] userId: $userId, published: $published');
    }
    final dimension =
        trackStatus?.dimensionOrNull ?? RtcVideoDimensionPresets.h720_169;
    return CallTrackStatus.received(dimension);
  }
}
