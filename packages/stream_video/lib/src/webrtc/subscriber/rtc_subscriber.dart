import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../sfu/data/models/sfu_model_parser.dart';
import '../peer_connection.dart';
import '../rtc_audio_api/rtc_audio_api.dart' as rtc_audio;
import '../sdp/incoming_audio_sources.dart';
import '../traced_peer_connection.dart';

/// {@template OnRemoteTrackReceived}
/// Called when a subscriber track is received.
/// {@endtemplate}
typedef OnRemoteTrackReceived =
    void Function(StreamPeerConnection pc, RtcRemoteTrack track);

final _logger = taggedLogger(tag: 'SV:RtcSubscriber');

/// The receiving side of a call session: the subscriber peer connection and
/// the remote tracks it delivers.
///
/// It answers the SFU's offers and turns each incoming track into an
/// [RtcRemoteTrack]. Web audio playback is reached through the two swappable
/// seams [needsRemoteAudioReattach] and [reattachRemoteAudio], and the sink
/// switch of [setAudioSink].
@internal
class RtcSubscriber {
  RtcSubscriber({
    required this.pc,
    required this._attachDecryptor,
    this._onTrackAdded,
  }) {
    pc.onTrack = _onRemoteTrack;
  }

  /// The subscriber peer connection.
  final TracedStreamPeerConnection pc;

  final Future<void> Function(RtcRemoteTrack track) _attachDecryptor;
  final void Function(RtcRemoteTrack track)? _onTrackAdded;

  /// The remote tracks by track id.
  final tracks = </*trackId*/ String, RtcRemoteTrack>{};

  /// Called for every remote track that arrives.
  OnRemoteTrackReceived? onRemoteTrackReceived;

  /// The last subscriber offer applied and answered, so the next one can be compared
  /// against it. Null until the first offer: a brand-new subscriber is not a
  /// renegotiation. Only kept where [needsRemoteAudioReattach] holds.
  String? _appliedSubscriberOfferSdp;

  /// Whether subscriber offers have to be compared for new audio sources.
  /// WebKit only: everywhere else the offers are neither kept nor parsed.
  /// Swappable so a test on the VM can take the WebKit path.
  bool Function() needsRemoteAudioReattach = rtc_audio.needsRemoteAudioReattach;

  /// Re-attaches every remote audio element after a subscriber renegotiation
  /// brought in a new audio source. Swappable so a test can observe the
  /// trigger.
  Future<void> Function({required String reason}) reattachRemoteAudio =
      rtc_audio.reattachRemoteAudio;

  /// Applies the SFU's [offerSdp] and returns the answer, or null when either
  /// step failed. Re-attaches remote audio when a WebKit renegotiation brings
  /// in a new audio source.
  Future<String?> onOffer(String offerSdp) async {
    final previousOfferSdp = _appliedSubscriberOfferSdp;

    final result = await pc.setRemoteOffer(offerSdp);
    if (result.isFailure) return null;

    final rtcAnswer = await pc.createAnswer(offerSdp);
    final answerSdp = rtcAnswer.getDataOrNull()?.sdp;
    if (answerSdp == null) return null;

    // Recorded only once the answer exists: an offer that failed to answer
    // was never applied, so a retry of it must still count as new.
    if (needsRemoteAudioReattach()) _appliedSubscriberOfferSdp = offerSdp;

    if (previousOfferSdp != null) {
      // Best effort, and guarded: losing a re-attach is far cheaper than
      // losing the answer.
      try {
        if (offerAddsIncomingAudio(
          previous: previousOfferSdp,
          next: offerSdp,
        )) {
          unawaited(_reattachRemoteAudio(reason: 'subscriberOffer'));
        }
      } catch (e, stk) {
        _logger.w(
          () => '[onOffer] audio source check failed: $e\n$stk',
        );
      }
    }

    return answerSdp;
  }

  Future<void> _reattachRemoteAudio({required String reason}) async {
    try {
      await reattachRemoteAudio(reason: reason);
    } catch (e, stk) {
      _logger.w(() => '[reattachRemoteAudio] failed: $e\n$stk');
    }
  }

  /// Adds the SFU's ICE [candidate] to the subscriber.
  Future<Result<AddIceCandidateResult>> addIceCandidate(
    rtc.RTCIceCandidate candidate,
  ) {
    return pc.addIceCandidate(candidate);
  }

  void _onRemoteTrack(StreamPeerConnection pc, rtc.RTCTrackEvent event) {
    _logger.d(
      () => '[onRemoteTrack] event.streams.length: ${event.streams.length}',
    );

    final stream = event.streams.firstOrNull;
    if (stream == null) {
      _logger.w(() => '[onRemoteTrack] stream is null');
      return;
    }
    _logger.v(() => '[onRemoteTrack] stream.id: ${stream.id}');

    event.track.onEnded = () {
      _logger.w(() => '[onRemoteTrack] #onTrackEnded; no args');
    };
    stream.onRemoveTrack = (_) {
      _logger.w(() => '[onRemoteTrack] #onRemoveTrack; no args');
    };

    final track = event.track;
    final transceiver = event.transceiver;

    final idParts = stream.id.split(':');
    final trackId = idParts[0];
    final trackType = idParts[1];

    final remoteTrack = RtcRemoteTrack(
      trackIdPrefix: trackId,
      trackType: SfuTrackTypeParser.parseSfuName(trackType),
      mediaTrack: track,
      mediaStream: stream,
      transceiver: transceiver,
    );

    unawaited(_attachDecryptor(remoteTrack));

    onRemoteTrackReceived?.call(pc, remoteTrack);
    tracks[remoteTrack.trackId] = remoteTrack;
    _logger.v(() => '[onRemoteTrack] published: ${remoteTrack.trackId}');

    _onTrackAdded?.call(remoteTrack);
  }

  /// The subscriber receiver carrying [track].
  Future<rtc.RTCRtpReceiver?> receiverFor(RtcRemoteTrack track) async {
    final trackId = track.mediaTrack.id;

    try {
      final transceivers = await pc.pc.getTransceivers();
      final match = transceivers.firstWhereOrNull(
        (it) => it.receiver.track?.id == trackId,
      );
      if (match != null) return match.receiver;
    } catch (e) {
      _logger.w(() => '[receiverFor] getTransceivers failed: $e');
    }

    return track.transceiver?.receiver;
  }

  /// The remote audio tracks.
  List<RtcRemoteTrack> get audioTracks =>
      tracks.values.where((it) => it.trackType == SfuTrackType.audio).toList();

  /// Sets the sink id of every remote audio track to [device], as the web
  /// selects the audio output per element. A track that rejects it keeps its
  /// sink; the call fails only when every track rejected it.
  Future<Result<None>> setAudioSink(RtcMediaDevice device) async {
    final audioTracks = this.audioTracks;

    if (!rtc_audio.checkIfAudioOutputChangeSupported()) {
      _logger.w(
        () =>
            '[setAudioSink] rejected: Audio Output device change is not supported on this browser.',
      );
      return failureWithError(
        'Audio Output device change is not supported on this browser.',
      );
    }

    // Try every track instead of aborting on the first rejection: stopping
    // half way leaves the switched tracks on the new device and the rest on
    // the old one, with no way to record both.
    final applied = <RtcRemoteTrack>[];
    final failures = <(String, Object, StackTrace)>[];

    await Future.wait(
      audioTracks.map((audioTrack) async {
        if (audioTrack.audioSinkId == device.id) {
          applied.add(audioTrack);
          return;
        }

        try {
          applied.add(await audioTrack.setSinkId(device.id));
        } catch (e, stk) {
          failures.add((audioTrack.trackId, e, stk));
        }
      }),
    );

    applied.forEach(_keepIfHeld);

    for (final (trackId, error, _) in failures) {
      _logger.w(
        () => '[setAudioSink] track $trackId rejected: $error',
      );
    }

    if (applied.isEmpty && failures.isNotEmpty) {
      final (_, error, stk) = failures.first;
      _logger.e(() => '[setAudioSink] rejected: $error');
      return Result.failure(StreamVideoExceptions.compose(error, stk), stk);
    }

    return const Result.success(none);
  }

  /// Records [device] as the audio sink of [audioTracks], after the platform
  /// switched the audio output to it.
  ///
  /// A track removed in the meantime is not brought back.
  void useAudioOutput(RtcMediaDevice device, List<RtcRemoteTrack> audioTracks) {
    for (final audioTrack in audioTracks) {
      _keepIfHeld(audioTrack.copyWith(audioSinkId: device.id));
    }
  }

  /// Keeps [track] in place of the remote track with its id, unless that one
  /// was removed, or replaced by another, while [track] was being made.
  void _keepIfHeld(RtcRemoteTrack track) {
    if (!identical(tracks[track.trackId]?.mediaTrack, track.mediaTrack)) {
      _logger.d(() => '[keepIfHeld] ${track.trackId} is no longer held');
      return;
    }
    tracks[track.trackId] = track;
  }

  /// Stops and drops the remote track [trackId], and reports whether there
  /// was one. A remote track's receiver belongs to this peer connection, so
  /// there is no sender to remove.
  Future<bool> removeTrack(String trackId) async {
    final track = tracks.remove(trackId);
    if (track == null) return false;

    await track.stop();
    return true;
  }

  /// Drops every remote track without stopping it.
  void clearTracks() => tracks.clear();

  /// Disposes the subscriber peer connection.
  Future<void> dispose() => pc.dispose();
}
