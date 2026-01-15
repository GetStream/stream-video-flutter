import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';
import '../../../sfu/data/models/sfu_track_type.dart';

final _logger = taggedLogger(tag: 'SV:CallState:PendingTracks');

/// Mixin to handle pending remote tracks that arrive before their participant
/// is added to the call state.
mixin StatePendingTracksMixin on StateNotifier<CallState> {
  final Map<String, Map<SfuTrackType, RemoteTrackState>> _pendingRemoteTracks =
      {};

  void addPendingTrack(
    String trackIdPrefix,
    SfuTrackType trackType, {
    bool muted = false,
  }) {
    _pendingRemoteTracks.putIfAbsent(
      trackIdPrefix,
      () => {},
    )[trackType] = TrackState.remote(
          muted: muted,
        )
        as RemoteTrackState;

    _logger.d(
      () =>
          '[addPendingTrack] Buffered: $trackIdPrefix:$trackType (muted: $muted)',
    );
  }

  void updatePendingSubscriberTrack(
    String trackIdPrefix,
    SfuTrackType trackType,
  ) {
    final pendingForPrefix = _pendingRemoteTracks.putIfAbsent(
      trackIdPrefix,
      () => {},
    );

    final existing = pendingForPrefix[trackType];
    if (existing != null) {
      pendingForPrefix[trackType] = existing.copyWith(
        subscribed: true,
        received: true,
        muted: false,
      );

      _logger.d(
        () =>
            '[updatePendingSubscriberTrack] Updated: $trackIdPrefix:$trackType',
      );
    } else {
      pendingForPrefix[trackType] =
          TrackState.remote(
                subscribed: true,
                received: true,
              )
              as RemoteTrackState;

      _logger.d(
        () => '[updatePendingSubscriberTrack] Added: $trackIdPrefix:$trackType',
      );
    }
  }

  Map<SfuTrackType, RemoteTrackState>? consumePendingTracks(
    String trackIdPrefix,
  ) {
    return _pendingRemoteTracks.remove(trackIdPrefix);
  }

  void clearPendingTracks(String trackIdPrefix) {
    _pendingRemoteTracks.remove(trackIdPrefix);
  }
}
