import 'package:state_notifier/state_notifier.dart';

import '../../../action/internal/rtc_action.dart';
import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateRtcMixin on StateNotifier<CallState> {
  void rtcUpdateSubscriberTrack(
    UpdateSubscriberTrack action,
  ) {
    _logger.d(
      () => '[rtcUpdateSubscriberTrack] ${state.sessionId}; action: $action',
    );
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.trackIdPrefix == action.trackIdPrefix &&
            trackState is RemoteTrackState) {
          _logger.v(
            () => '[rtcUpdateSubscriberTrack] pFound: $participant',
          );
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType: trackState.copyWith(
                muted: false,
                subscribed: true,
                received: true,
              )
            },
          );
        } else {
          _logger.v(() => '[rtcUpdateSubscriberTrack] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }
}
