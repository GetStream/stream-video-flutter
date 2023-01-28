import '../../logger/stream_logger.dart';
import '../action/rtc_action.dart';
import '../action/sfu_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';

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
        if (participant.trackIdPrefix == action.trackId) {
          _logger.v(
            () => '[reduceSubTrackReceived] pFound: $participant',
          );
          return participant.copyWith(
            published: {
              ...participant.published,
              action.trackType: CallTrackStatus.received
            },
          );
        } else {
          _logger.v(() => '[reduceSubTrackReceived] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }
}
