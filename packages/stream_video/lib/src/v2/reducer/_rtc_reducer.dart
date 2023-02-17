import '../../logger/impl/tagged_logger.dart';
import '../action/rtc_action.dart';
import '../call_state.dart';
import '../model/call_track_state.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-RTC');

class RtcReducer {
  const RtcReducer();

  CallState reduce(
    CallState state,
    RtcAction action,
  ) {
    if (action is SubscriberTrackReceivedAction) {
      return _reduceSubscriberTrackReceived(state, action);
    }
    return state;
  }

  CallState _reduceSubscriberTrackReceived(
    CallState state,
    SubscriberTrackReceivedAction action,
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
