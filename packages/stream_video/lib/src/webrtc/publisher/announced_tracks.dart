import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../codecs_helper.dart';
import '../model/rtc_tracks_info.dart';
import '../model/rtc_video_encoding.dart';
import '../transceiver_cache.dart';
import 'publish_quality.dart';

final _logger = taggedLogger(tag: 'SV:AnnouncedTracks');

/// Returns the negotiated mid for the track attached to [transceiver] from
/// [liveTransceivers] or, if absent, from the offer [sdp], falling back to
/// [lastKnownMid] once the publisher is no longer reachable. Returns null if
/// unresolved.
@internal
@visibleForTesting
String? resolveTrackMid({
  required rtc.RTCRtpTransceiver transceiver,
  required List<rtc.RTCRtpTransceiver> liveTransceivers,
  required String? sdp,
  String? lastKnownMid,
}) {
  final sentTrack = transceiver.sender.track;
  final trackId = sentTrack?.id;
  final kind = sentTrack?.kind;

  if (trackId == null) return null;

  // 1. Authoritative: the current transceiver's mid, matched by track id.
  final live = liveTransceivers.firstWhereOrNull(
    (t) => t.sender.track?.id == trackId,
  );
  if (live != null) {
    final liveMid = _midOf(live);
    if (liveMid != null) return liveMid;
  }

  // 2. Fallback: the m-section for this track in the current offer SDP.
  //    Covers a live list that is unavailable, or a live transceiver whose
  //    mid cannot be read yet.
  //    Searched in reverse so a recycled m-line (the same track re-attached to
  //    a later m-section) wins over the stale one it replaced.
  if (sdp != null) {
    try {
      final media = (parse(sdp)['media'] as List?)
          ?.cast<Map<String, dynamic>>()
          .reversed
          .firstWhereOrNull(
            (m) =>
                (kind == null || m['type'] == kind) &&
                ((m['msid'] as String?)?.contains(trackId) ?? false),
          );

      final mid = media?['mid'];
      if (mid != null) return mid.toString();
    } catch (_) {
      // Malformed SDP — treat as unresolved.
    }
  }

  // 3. The mid carried by the transceiver we were handed. Live on web; on the
  //    native implementations it is a snapshot taken at `addTransceiver` time —
  //    before a mid was assigned — and never updated, so it is empty there.
  final cachedMid = _midOf(transceiver);
  if (cachedMid != null) return cachedMid;

  // 4. Last resort: the mid of the last announce the SFU acknowledged. This is
  //    all that is left once the publisher is closed, which is the normal state
  //    when a rejoin builds `ReconnectDetails` from the previous session.
  if (lastKnownMid != null && lastKnownMid.isNotEmpty) return lastKnownMid;

  // 5. Unresolved — do NOT fall back to a positional/canonical index.
  return null;
}

/// The mid of [transceiver], or null when it has none yet.
///
/// Reading `mid` is not safe on every platform: on web it null-asserts through
/// to the JS transceiver, so it throws for one that has never been negotiated
/// rather than reporting an empty mid the way the native implementations do.
///
/// A plugin workaround: it goes once `mid` is safe to read on every platform.
String? _midOf(rtc.RTCRtpTransceiver transceiver) {
  try {
    final mid = transceiver.mid;
    return mid.isEmpty ? null : mid;
  } catch (_) {
    return null;
  }
}

/// True when [sdp] carries no m-line for [transceiverCache] — a publish that
/// landed after the offer was created.
///
/// Absence is proven against every id the transceiver has ever sent, not just
/// the current one. An m-line is named by whichever id its sender held at
/// `createOffer` time, so a `replaceTrack` that landed afterwards leaves the
/// offer naming an older id while the m-line is very much part of it. Matching
/// only the current id would read that as a late publish and quietly drop a
/// track the announce is contractually required to fail on instead.
@internal
bool isMidFlightPublish(TransceiverCache transceiverCache, String? sdp) {
  if (sdp == null) return false;
  if (transceiverCache.negotiated) return false;

  final currentTrackId = transceiverCache.transceiver.sender.track?.id;
  final candidateIds = <String>{
    ...transceiverCache.sentTrackIds,
    if (currentTrackId != null) currentTrackId,
  };

  // Unknown track ids — cannot prove absence, stay conservative.
  if (candidateIds.isEmpty) return false;

  return !candidateIds.any(sdp.contains);
}

/// Whether the track behind [transceiverCache] should be announced to the SFU
/// as muted.
///
/// Reads [heldTrack], the SDK's own track that muting and unmuting act on and
/// report through `UpdateMuteStates`, so the announce agrees with the last
/// mute state sent. It falls back to [TransceiverCache.track] when there is
/// none. Neither track reachable from the transceiver is reliable on native:
/// - `sender.track` is a snapshot built by `addTransceiver`, so its `enabled`
///   keeps the value from publish time until a `replaceTrack` swaps it.
/// - [TransceiverCache.track] is not updated when an unmute recaptures a
///   released track, so after a mute and unmute it still holds the stopped,
///   disabled original.
bool _isAnnouncedMuted(
  TransceiverCache transceiverCache,
  RtcLocalTrack? heldTrack,
) {
  if (transceiverCache.transceiver.sender.track == null) return true;

  final track = heldTrack ?? transceiverCache.track;
  return !track.mediaTrack.enabled;
}

/// The [RtcTrackInfo] to announce for [transceiverCache], or null when its
/// mid cannot be resolved.
///
/// [audioSettings] decide stereo, DTX and RED for audio, and [dimensionOf]
/// gives the capture size the video layers are worked out from. [heldTrack]
/// is the SDK's current track for the transceiver, which decides whether it
/// is announced as muted. A track that is part of the offer but has no mid is
/// reported to [onMidUnresolved] before null is returned; a publish that is
/// not part of the offer yet is not.
@internal
RtcTrackInfo? transceiverToTrackInfo(
  TransceiverCache transceiverCache, {
  required List<rtc.RTCRtpTransceiver> liveTransceivers,
  required StreamAudioSettings audioSettings,
  required RtcVideoDimension Function(RtcLocalVideoTrack) dimensionOf,
  RtcLocalTrack? heldTrack,
  String? sdp,
  void Function(Map<String, Object?> data)? onMidUnresolved,
}) {
  final track = transceiverCache.track;

  // The track actually attached to the sender — the one named in the SDP.
  final sentTrackId =
      transceiverCache.transceiver.sender.track?.id ?? track.mediaTrack.id;

  final mid = resolveTrackMid(
    transceiver: transceiverCache.transceiver,
    liveTransceivers: liveTransceivers,
    sdp: sdp,
    lastKnownMid: transceiverCache.negotiatedMid,
  );

  if (mid == null) {
    if (isMidFlightPublish(transceiverCache, sdp)) {
      _logger.v(
        () =>
            '[transceiverToTrackInfo] track $sentTrackId '
            '(${track.trackType}) is not part of the current offer yet; '
            'deferring to its own negotiation',
      );
      return null;
    }

    _logger.w(
      () =>
          '[transceiverToTrackInfo] could not resolve mid for track '
          '$sentTrackId (${track.trackType}); skipping announce',
    );

    onMidUnresolved?.call({
      'trackId': sentTrackId,
      'cachedTrackId': track.mediaTrack.id,
      'trackType': track.trackType.toString(),
      'publishOptionId': transceiverCache.publishOption.id,
      'liveTransceiverCount': liveTransceivers.length,
      'hasSdp': sdp != null,
      'negotiated': transceiverCache.negotiated,
    });

    return null;
  }

  if (track is RtcLocalAudioTrack) {
    final stereo =
        track.trackType == SfuTrackType.screenShareAudio ||
        audioSettings.hifiAudioEnabled;

    return RtcTrackInfo(
      trackId: sentTrackId,
      trackType: track.trackType,
      publishOptionId: transceiverCache.publishOption.id,
      mid: mid,
      layers: [],
      codec: transceiverCache.publishOption.codec,
      muted: _isAnnouncedMuted(transceiverCache, heldTrack),
      stereo: stereo,
      dtx: audioSettings.opusDtxEnabled,
      red: audioSettings.redundantCodingEnabled,
    );
  } else if (track is RtcLocalVideoTrack) {
    final encodings = findOptimalVideoLayers(
      dimensions: dimensionOf(track),
      publishOptions: transceiverCache.publishOption,
    );

    return RtcTrackInfo(
      trackId: sentTrackId,
      trackType: track.trackType,
      publishOptionId: transceiverCache.publishOption.id,
      mid: mid,
      dtx: false,
      red: false,
      stereo: false,
      codec: transceiverCache.publishOption.codec,
      muted: _isAnnouncedMuted(transceiverCache, heldTrack),
      layers: encodings.map((it) {
        return RtcVideoLayer(
          rid: it.rid ?? '',
          parameters: RtcVideoParameters(
            encoding: RtcVideoEncoding(
              maxBitrate: it.maxBitrate ?? 0,
              maxFramerate: it.maxFramerate ?? 0,
              quality: ridToVideoQuality(it.rid ?? ''),
            ),
            dimension: RtcVideoDimension(
              width: it.width.floor(),
              height: it.height.floor(),
            ),
          ),
        );
      }).toList(),
    );
  }

  throw UnimplementedError('Unsupported track type: ${track.runtimeType}');
}
