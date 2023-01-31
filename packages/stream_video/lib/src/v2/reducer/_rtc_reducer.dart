import '../../logger/stream_logger.dart';
import '../action/rtc_action.dart';
import '../call_state.dart';
import '../model/call_track_state.dart';

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
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType:
                  participant.publishedTracks[action.trackType]?.copyWith(
                        subscribed: true,
                        received: true,
                      ) ??
                      const CallTrackState(
                        subscribed: true,
                        received: true,
                      )
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
