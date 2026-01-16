import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';
import '../../../sfu/data/models/sfu_track_type.dart';
import 'state_pending_tracks_mixin.dart';

final _logger = taggedLogger(tag: 'SV:CallState:Rtc');

mixin StateRtcMixin on StateNotifier<CallState>, StatePendingTracksMixin {
  void rtcUpdateSubscriberTrack({
    required String trackIdPrefix,
    required SfuTrackType trackType,
  }) {
    _logger.d(
      () =>
          '[rtcUpdateSubscriberTrack] ${state.sessionId}; trackIdPrefix: $trackIdPrefix; trackType: $trackType',
    );

    final participant = state.callParticipants.firstWhereOrNull(
      (p) => p.trackIdPrefix == trackIdPrefix,
    );

    if (participant == null) {
      updatePendingSubscriberTrack(trackIdPrefix, trackType);
      return;
    }

    final trackState = participant.publishedTracks[trackType];
    if (trackState is RemoteTrackState) {
      state = state.copyWith(
        callParticipants: state.callParticipants.map((p) {
          if (p.trackIdPrefix == trackIdPrefix) {
            return p.copyWith(
              publishedTracks: {
                ...p.publishedTracks,
                trackType: trackState.copyWith(
                  muted: false,
                  subscribed: true,
                  received: true,
                ),
              },
            );
          } else {
            return p;
          }
        }).toList(),
      );
    } else {
      _logger.v(() => '[rtcUpdateSubscriberTrack] pSame: $participant');
    }
  }
}
