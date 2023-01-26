import '../../logger/stream_logger.dart';
import '../action/rtc_action.dart';
import '../action/sfu_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../sfu/data/events/sfu_events.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-RTC');

class RtcReducer {
  const RtcReducer();

  CallStateV2 reduce(
    CallStateV2 state,
    RtcAction action,
  ) {
    if (action is RtcRemoteTrackPublishedAction) {
      return _reduceRtcTrackPublished(state, action);
    }
    return state;
  }

  CallStateV2 _reduceRtcTrackPublished(
    CallStateV2 state,
    RtcRemoteTrackPublishedAction action,
  ) {
    _logger.d(
      () => '[reduceRtcTrackPublished] ${state.sessionId}; action: $action',
    );
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          if (participant.trackId == action.trackId) {
            _logger.v(
              () => '[reduceRtcTrackPublished] pFound: $participant',
            );
            return participant.copyWith(
              publishedTrackTypes: {
                ...participant.publishedTrackTypes,
                action.trackType,
              },
            );
          } else {
            _logger.v(() => '[reduceRtcTrackPublished] pSame: $participant');
            return participant;
          }
        }),
    );
  }
}
