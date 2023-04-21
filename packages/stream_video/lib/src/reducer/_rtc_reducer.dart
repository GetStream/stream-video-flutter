import '../action/internal/rtc_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_track_state.dart';
import '../store/store.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-RTC');

class RtcReducer extends Reducer<CallState, RtcAction> {
  const RtcReducer();

  @override
  CallState reduce(
    CallState state,
    RtcAction action,
  ) {
    if (action is UpdateSubscriberTrack) {
      return _reduceSubscriberTrack(state, action);
    }
    return state;
  }

  CallState _reduceSubscriberTrack(
    CallState state,
    UpdateSubscriberTrack action,
  ) {
    _logger.d(
      () => '[reduceSubTrackReceived] ${state.sessionId}; action: $action',
    );
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.trackIdPrefix == action.trackIdPrefix &&
            trackState is RemoteTrackState) {
          _logger.v(
            () => '[reduceSubTrackReceived] pFound: $participant',
          );
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType: trackState.copyWith(
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
