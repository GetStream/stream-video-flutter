import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';
import '../../../sfu/data/models/sfu_track_type.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateRtcMixin on StateNotifier<CallState> {
  void rtcUpdateSubscriberTrack({
    required String trackIdPrefix,
    required SfuTrackType trackType,
  }) {
    _logger.d(
      () =>
          '[rtcUpdateSubscriberTrack] ${state.sessionId}; trackIdPrefix: $trackIdPrefix; trackType: $trackType',
    );
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[trackType];
        if (participant.trackIdPrefix == trackIdPrefix &&
            trackState is RemoteTrackState) {
          _logger.v(
            () => '[rtcUpdateSubscriberTrack] pFound: $participant',
          );
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              trackType: trackState.copyWith(
                muted: false,
                subscribed: true,
                received: true,
              ),
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
