import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:webrtc_interface/webrtc_interface.dart';

import '../../stream_video.dart';
import '../call/state/call_state_notifier.dart';
import '../call/stats/trace_tag.dart';
import '../errors/stream_video_exception_composer.dart';
import '../errors/track_missing_exception.dart';
import '../sfu/data/models/sfu_model_parser.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_video_sender.dart';
import '../telemetry/client_event_types.dart';
import '../telemetry/media_frame_reporter.dart';
import '../telemetry/peer_connection_connect_reporter.dart';
import 'apple_audio_route.dart';
import 'codecs_helper.dart' as codecs;
import 'codecs_helper.dart';
import 'e2ee/e2ee_mapping.dart';
import 'media/capture_dimension.dart';
import 'model/rtc_tracks_info.dart';
import 'peer_connection.dart';
import 'peer_connection_factory.dart';
import 'publisher/announced_tracks.dart';
import 'publisher/publish_quality.dart';
import 'rtc_audio_api/rtc_audio_api.dart' as rtc_audio;
import 'rtc_parser.dart';
import 'rtc_track/rtc_track_publish_options.dart';
import 'sdp/incoming_audio_sources.dart';
import 'traced_peer_connection.dart';
import 'transceiver_cache.dart';

export '../errors/track_missing_exception.dart';
export 'publisher/announced_tracks.dart' show resolveTrackMid;

part 'rtc_manager_media.dart';

/// {@template OnLocalTrackMuted}
/// Callback for when a local track is muted.
/// {@endtemplate}
typedef OnLocalTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnLocalTrackPublished}
/// Called when a local track is published.
/// {@endtemplate}
typedef OnLocalTrackPublished = void Function(RtcLocalTrack track);

/// {@template OnRemoteTrackPublished}
/// Called when a subscriber track is received.
/// {@endtemplate}
typedef OnRemoteTrackReceived =
    void Function(StreamPeerConnection pc, RtcRemoteTrack track);

const _tag = 'SV:RtcManager';

/// How long [PublisherRtcManager.getAnnouncedTracks] waits for in-flight
/// transceiver creations before giving up on the current negotiation.
const _pendingTransceiverSettleTimeout = Duration(seconds: 5);

/// The WebRTC side of one call session: its publisher and subscriber peer
/// connections and the tracks they carry.
///
/// One is made per `CallSession` by `RtcManagerFactory`. A rejoin or an SFU
/// migration makes a new one; [handOverLocalTracks] passes the live local
/// tracks to it, so the devices are not opened again.
///
/// It:
/// - publishes local tracks: it acquires the camera, microphone and screen
///   share, sends each track on a transceiver per publish option, and mutes,
///   unmutes and switches devices on them;
/// - follows the SFU: publish options (codecs), publish quality (layers), and
///   the tracks announced in `SetPublisher` and `ReconnectDetails`;
/// - receives remote tracks on the subscriber and answers its offers;
/// - attaches end-to-end encryption to senders and receivers when the call is
///   encrypted;
/// - selects the audio output and, on Apple platforms, applies the audio
///   session and the microphone mute of the audio device module.
///
/// It does not talk to the SFU: `CallSession` negotiates and calls into it.
/// The call layer reads tracks through [localTracks], [remoteTracks],
/// [getTrack] and [getTracks], and hears about changes through
/// [onLocalTrackPublished], [onLocalTrackMuted] and [onRemoteTrackReceived].
class RtcManager extends Disposable {
  RtcManager({
    required this.sessionId,
    required this.callCid,
    required this.publisherId,
    required this.publisher,
    required this.subscriber,
    required this.publishOptions,
    required this.stateManager,
    required CallHost host,
    required this.pcFactory,
    this.e2eeManager,
    this.sfuId,
    this.clientEventRetryCount = 0,
    this.captureDimensionResolver = const CaptureDimensionResolver(),
  }) : _host = host {
    subscriber.onTrack = _onRemoteTrack;
    _initClientEventReporting();
  }

  final _logger = taggedLogger(tag: _tag);

  final String sessionId;
  final StreamCallCid callCid;
  final String? publisherId;
  final CallStateNotifier stateManager;
  final TracedStreamPeerConnection? publisher;
  final TracedStreamPeerConnection subscriber;
  final CallHost _host;
  final String? sfuId;
  final int clientEventRetryCount;

  /// Works out the size a local video track is encoded at.
  final CaptureDimensionResolver captureDimensionResolver;

  PeerConnectionConnectReporter? _publisherConnectReporter;
  PeerConnectionConnectReporter? _subscriberConnectReporter;
  MediaFrameReporter? _mediaFrameReporter;

  final StreamPeerConnectionFactory pcFactory;

  /// End-to-end encryption for this session, or `null` when the call is
  /// unencrypted.
  ///
  /// Set before the peer connections carry any media: local transceivers get
  /// an encryptor as they are added, remote receivers get a decryptor as
  /// tracks arrive.
  final rtc.EncryptionManager? e2eeManager;

  /// Remote tracks that arrived before their participant was known.
  final _pendingDecryptors = <String, RtcRemoteTrack>{};

  final transceiversManager = TransceiverManager();

  bool _isDisposing = false;

  /// Publishes that have claimed a `(trackType, publishOptionId)` and are
  /// still creating their transceiver.
  final _pendingTransceivers = <TransceiverKey, Future<void>>{};

  /// Track creations (`getUserMedia` and the publish that follows) in flight
  /// per track type, so a double "enable" opens the camera once instead of
  /// twice.
  final _pendingTrackCreations =
      <SfuTrackType, Future<Result<RtcLocalTrack>>>{};

  /// Runs [create] as the single in-flight creation for [trackType], returning
  /// the already-running one when there is one.
  Future<Result<RtcLocalTrack>> _singleFlightCreate(
    SfuTrackType trackType,
    Future<Result<RtcLocalTrack>> Function() create,
  ) {
    final inFlight = _pendingTrackCreations[trackType];
    if (inFlight != null) {
      _logger.i(
        () =>
            '[createTrack] $trackType is already being created; '
            'joining the in-flight request instead of acquiring media again',
      );
      return inFlight;
    }

    final pending = create();
    _pendingTrackCreations[trackType] = pending;

    return pending.whenComplete(() => _pendingTrackCreations.remove(trackType));
  }

  List<SfuPublishOptions> publishOptions;
  AudioConstraints _defaultAudioConstraints = const AudioConstraints();

  final tracks = </*trackId*/ String, RtcTrack>{};

  /// The local tracks by track id, as an unmodifiable snapshot.
  Map<String, RtcLocalTrack> get localTracks => Map.unmodifiable({
    for (final MapEntry(:key, :value) in tracks.entries)
      if (value is RtcLocalTrack) key: value,
  });

  /// The remote tracks by track id, as an unmodifiable snapshot.
  Map<String, RtcRemoteTrack> get remoteTracks => Map.unmodifiable({
    for (final MapEntry(:key, :value) in tracks.entries)
      if (value is RtcRemoteTrack) key: value,
  });

  /// Marks the transceivers sending [announced] as acknowledged by the SFU.
  void markNegotiated(Iterable<RtcTrackInfo> announced) {
    transceiversManager.markNegotiated(announced);
  }

  /// The media tracks given to the next session's manager by
  /// [handOverLocalTracks], by track id. Unpublishing a track that still holds
  /// that media track stops only this manager's clones.
  final _handedOverMediaTracks = <String, rtc.MediaStreamTrack>{};

  set onPublisherIceCandidate(OnIceCandidate? cb) {
    publisher?.onIceCandidate = cb;
  }

  set onSubscriberIceCandidate(OnIceCandidate? cb) {
    subscriber.onIceCandidate = cb;
  }

  set onRenegotiationNeeded(OnRenegotiationNeeded? cb) {
    publisher?.onRenegotiationNeeded = cb;
  }

  set onReconnectionNeeded(OnReconnectionNeeded? cb) {
    subscriber.onReconnectionNeeded = cb;
    publisher?.onReconnectionNeeded = cb;
  }

  OnLocalTrackMuted? onLocalTrackMuted;
  OnLocalTrackPublished? onLocalTrackPublished;
  OnRemoteTrackReceived? onRemoteTrackReceived;

  void _initClientEventReporting() {
    if (!_host.options.clientEventsReportingEnabled) return;

    final reporter = _host.clientEventReporter;

    _mediaFrameReporter = MediaFrameReporter(
      reporter: reporter,
      callCid: callCid,
      sfuId: sfuId,
    );

    _subscriberConnectReporter = PeerConnectionConnectReporter(
      reporter: reporter,
      callCid: callCid,
      role: ClientEventPeerConnectionRole.subscribe,
      sfuId: sfuId,
      retryCount: clientEventRetryCount,
    );

    subscriber
      ..onIceConnectionStateUpdated =
          _subscriberConnectReporter!.onIceConnectionState
      ..onConnectionStateUpdated =
          _subscriberConnectReporter!.onConnectionState;

    final pub = publisher;
    if (pub != null) {
      _publisherConnectReporter = PeerConnectionConnectReporter(
        reporter: reporter,
        callCid: callCid,
        role: ClientEventPeerConnectionRole.publish,
        sfuId: sfuId,
        retryCount: clientEventRetryCount,
      );
      pub
        ..onIceConnectionStateUpdated =
            _publisherConnectReporter!.onIceConnectionState
        ..onConnectionStateUpdated =
            _publisherConnectReporter!.onConnectionState;
    }
  }

  /// Feeds the subscriber's periodic WebRTC [stats] to first-frame telemetry
  void onSubscriberStats(List<RtcStats> stats) {
    _mediaFrameReporter?.onSubscriberStats(stats);
  }

  StreamSubscription<ScreenSharingStartedEvent>?
  _screenSharingStartedSubscription;

  /// The last subscriber offer applied and answered, so the next one can be compared
  /// against it. Null until the first offer: a brand-new subscriber is not a
  /// renegotiation. Only kept where [needsRemoteAudioReattach] holds.
  String? _appliedSubscriberOfferSdp;

  /// Whether subscriber offers have to be compared for new audio sources.
  /// WebKit only: everywhere else the offers are neither kept nor parsed.
  /// Swappable so a test on the VM can take the WebKit path.
  @visibleForTesting
  bool Function() needsRemoteAudioReattach = rtc_audio.needsRemoteAudioReattach;

  /// Re-attaches every remote audio element after a subscriber renegotiation
  /// brought in a new audio source. Swappable so a test can observe the
  /// trigger.
  @visibleForTesting
  Future<void> Function({required String reason}) reattachRemoteAudio =
      rtc_audio.reattachRemoteAudio;

  Future<String?> onSubscriberOffer(String offerSdp) async {
    final previousOfferSdp = _appliedSubscriberOfferSdp;

    final result = await subscriber.setRemoteOffer(offerSdp);
    if (result.isFailure) return null;

    final rtcAnswer = await subscriber.createAnswer(offerSdp);
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
          () => '[onSubscriberOffer] audio source check failed: $e\n$stk',
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

  Future<Result<None>> onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) async {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    final Result<AddIceCandidateResult>? result;
    if (peerType == StreamPeerType.publisher) {
      result = await publisher?.addIceCandidate(candidate);
      if (result == null) return failureWithError('no publisher created');
    } else if (peerType == StreamPeerType.subscriber) {
      result = await subscriber.addIceCandidate(candidate);
    } else {
      return failureWithError('unexpected peerType: $peerType');
    }
    return result.map((_) => none);
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

    unawaited(attachDecryptor(remoteTrack));

    onRemoteTrackReceived?.call(pc, remoteTrack);
    tracks[remoteTrack.trackId] = remoteTrack;
    _logger.v(() => '[onRemoteTrack] published: ${remoteTrack.trackId}');

    // Telemetry: first-frame detection for remote media.
    final frameReporter = _mediaFrameReporter;
    if (frameReporter != null) {
      if (track.kind == 'audio') {
        frameReporter.onRemoteAudioTrack(trackId: remoteTrack.trackId);
      } else if (track.kind == 'video') {
        unawaited(
          frameReporter.onRemoteVideoTrack(
            stream: stream,
            trackId: remoteTrack.trackId,
          ),
        );
      }
    }
  }

  Future<void> changeDefaultAudioConstraints(
    AudioConstraints constraints,
  ) async {
    _defaultAudioConstraints = constraints;

    // Only live tracks are cycled. An already-muted track must stay muted —
    // unmuting it here would put the user back on air behind their back, and
    // on iOS/macOS also clear the ADM mute. It picks the new constraints up
    // from [_defaultAudioConstraints] when it is recreated on unmute.
    final liveTracks = tracks.values
        .whereType<RtcLocalAudioTrack>()
        .where((it) => it.mediaTrack.enabled)
        .toList();

    // The cycle has to stop and recreate the track for the new constraints to
    // take effect, so it forces [stopTrackOnMute] regardless of the track's
    // own setting.
    final stopTrackOnMuteByTrackId = {
      for (final track in liveTracks) track.trackId: track.stopTrackOnMute,
    };

    try {
      for (final track in liveTracks) {
        await muteTrack(trackId: track.trackId, stopTrackOnMute: true);
      }

      for (final track in liveTracks) {
        await unmuteTrack(trackId: track.trackId);
      }
    } finally {
      // Restored even if the cycle failed part-way: leaving the forced flag
      // behind would silently downgrade the mute strategy for the rest of the
      // call.
      for (final entry in stopTrackOnMuteByTrackId.entries) {
        final track = tracks[entry.key];
        if (track is! RtcLocalAudioTrack) continue;
        tracks[entry.key] = track.copyWith(stopTrackOnMute: entry.value);
      }
    }
  }

  /// Stops the track / clones / media stream for [trackId]. For a local
  /// track, also calls `pc.removeTrack` on every sender that referenced it.
  Future<void> unpublishTrack({
    required String trackId,
  }) async {
    final publishedTrack = tracks.remove(trackId);

    if (publishedTrack == null) {
      _logger.w(() => '[unpublishTrack] rejected (track not found): $trackId');
      return;
    }

    final handedOver = _handedOverMediaTracks.remove(trackId);
    if (publishedTrack is RtcLocalTrack &&
        identical(handedOver, publishedTrack.mediaTrack)) {
      await publishedTrack.stopClones();
    } else {
      await publishedTrack.stop();
    }

    // A remote track's transceiver belongs to the receive-only subscriber
    // PC, so there is no sender to remove. Passing it to the publisher PC
    // only failed with "sender is null". Stopping the track is enough.
    if (publishedTrack is RtcLocalTrack) {
      for (final publishOption in publishOptions) {
        if (publishOption.trackType != publishedTrack.trackType) continue;

        final transceiver = transceiversManager.get(publishOption)?.transceiver;

        try {
          if (transceiver != null) {
            await publisher?.pc.removeTrack(transceiver.sender);
          }
        } catch (e) {
          _logger.w(() => '[unpublishTrack] removeTrack failed: $e');
        }
      }
    }
  }

  /// Gives the live local tracks to the manager of the session that replaces
  /// this one, so the camera, microphone and screen share are not opened
  /// again.
  ///
  /// Each returned track carries the local prefix and no clones, ready to be
  /// published by the next manager. This manager keeps sending through its
  /// own clones until it is disposed, and then stops only those. Muted tracks
  /// stay here and are stopped on dispose. A second call returns nothing.
  List<RtcLocalTrack> handOverLocalTracks() {
    final handedOver = <RtcLocalTrack>[];
    for (final MapEntry(key: trackId, value: track) in tracks.entries) {
      if (track is! RtcLocalTrack) continue;
      if (!track.mediaTrack.enabled) continue;
      if (_handedOverMediaTracks.containsKey(trackId)) continue;
      _handedOverMediaTracks[trackId] = track.mediaTrack;

      handedOver.add(
        track.copyWith(
          trackIdPrefix: kLocalTrackIdPrefix,
          clonedTracks: const [],
        ),
      );
    }

    _logger.i(() => '[handOverLocalTracks] tracks: $handedOver');
    return handedOver;
  }

  bool isPublishing(SfuTrackType trackType) {
    for (final item in transceiversManager.items()) {
      if (item.publishOption.trackType != trackType) continue;

      final track = item.transceiver.sender.track;
      if (track == null) continue;

      if (track.enabled) return true;
    }

    return false;
  }

  Future<void> onPublishOptionsChanged(
    List<SfuPublishOptions> publishOptions,
  ) async {
    _logger.i(
      () => '[onPublishOptionsChanged] publishOptions: $publishOptions}',
    );

    _logger.v(
      () =>
          '[onPublishOptionsChanged] should publish in CODECS: ${publishOptions.map((e) => e.codec.name).join(', ')}',
    );

    this.publishOptions = publishOptions;

    for (final publishOption in publishOptions) {
      final trackType = publishOption.trackType;

      if (!isPublishing(trackType)) {
        _logger.v(
          () =>
              '[onPublishOptionsChanged] ignoring codec: ${publishOption.codec.name} for track type: $trackType - track is not publishing',
        );
        continue;
      }

      if (transceiversManager.has(publishOption)) {
        _logger.v(
          () =>
              '[onPublishOptionsChanged] already publishing in ${publishOption.codec.name} for $trackType',
        );
        continue;
      }

      final item = transceiversManager.find(
        (t) =>
            t.publishOption.trackType == trackType &&
            t.transceiver.sender.track != null,
      );

      if (item == null) {
        continue;
      }

      _logger.v(
        () =>
            '[onPublishOptionsChanged] adding transceiver for: $trackType with codec: ${publishOption.codec.name}',
      );

      // Take the track from the existing transceiver for the same track type,
      // clone it and publish it with the new publish options.
      final mediaTrackClone = await item.track.mediaTrack.clone();
      final trackToPublish = item.track.copyWith(mediaTrack: mediaTrackClone);

      // Cloning suspended; a publish may have taken this key in the meantime.
      var pending = _pendingTransceivers[publishOption.transceiverKey];
      while (pending != null) {
        await pending;
        pending = _pendingTransceivers[publishOption.transceiverKey];
      }

      if (transceiversManager.has(publishOption)) {
        _logger.v(
          () =>
              '[onPublishOptionsChanged] $trackType with codec: '
              '${publishOption.codec.name} was published while preparing',
        );
        await mediaTrackClone.stop();
        continue;
      }

      final result = await _addTransceiver(
        trackToPublish,
        publishOption,
        item.trackPublishOptions,
      );

      if (result is Success) {
        final localTrack = tracks[item.track.trackId] as RtcLocalTrack?;
        if (localTrack != null) {
          tracks[item.track.trackId] = localTrack.copyWith(
            clonedTracks: [...localTrack.clonedTracks, mediaTrackClone],
          );
        }
      } else {
        await mediaTrackClone.stop();
      }
    }

    for (final item in transceiversManager.items().toList()) {
      final publishOption = item.publishOption;
      final hasPublishOption = publishOptions.any(
        (option) =>
            option.id == publishOption.id &&
            option.trackType == publishOption.trackType,
      );

      if (hasPublishOption) continue;

      _logger.v(
        () =>
            '[onPublishOptionsChanged] stop publishing and remove transceiver for: ${item.track.trackType} with codec: ${publishOption.codec.name}',
      );

      // it is safe to stop the track here, it is a clone
      await item.transceiver.sender.track?.stop();
      await _updateTransceiver(item.transceiver, null, publishOption.trackType);

      // Stopping the transceiver releases its m-line for reuse. Dropping the
      // cache entry without it leaves the m-line on the peer connection with
      // nobody owning it.
      await _stopTransceiver(item.transceiver);
      transceiversManager.remove(publishOption);
    }
  }

  Future<void> onPublishQualityChanged(
    SfuVideoSender videoSender,
    String? codecInUse,
  ) async {
    final enabledLayers = videoSender.layers.where((e) => e.active).toList();

    _logger.i(
      () =>
          '[onPublishQualityChanged] Update publish quality, requested layers by SFU: $enabledLayers',
    );

    final sender = transceiversManager
        .getWith(videoSender.trackType, videoSender.publishOptionId)
        ?.sender;

    if (sender == null) {
      _logger.w(() => '[onPublishQualityChanged] no video sender found.');
      return;
    }

    final params = sender.parameters;
    if (params.encodings?.isEmpty ?? true) {
      _logger.w(
        () =>
            '[onPublishQualityChanged] No suitable video encoding quality found',
      );
      return;
    }

    final usesSvcCodec = codecInUse != null && codecs.isSvcCodec(codecInUse);

    _logger.i(
      () =>
          '[onPublishQualityChanged] Codec in use: $codecInUse, uses SVC: $usesSvcCodec',
    );

    final changed = applyPublishQuality(
      params,
      videoSender,
      usesSvcCodec: usesSvcCodec,
    );

    final activeLayers = params.encodings!.where((e) => e.active).toList();

    if (!changed) {
      _logger.i(
        () =>
            '[onPublishQualityChanged] Update publish quality, no change: '
            '${activeLayers.map(describeEncoding).join(', ')}',
      );
      return;
    }

    await sender.setParameters(params);
    _logger.i(
      () =>
          '[onPublishQualityChanged] Update publish quality, enabled: '
          '${activeLayers.map(describeEncoding).join(', ')}',
    );
  }

  /// The user id that owns the remote track under [trackIdPrefix].
  String? _userIdForTrackPrefix(String trackIdPrefix) {
    return stateManager.callState.callParticipants
        .firstWhereOrNull((it) => it.trackIdPrefix == trackIdPrefix)
        ?.userId;
  }

  /// Decrypts everything [track]'s receiver delivers, or queues the track
  /// until its participant is known.
  Future<void> attachDecryptor(RtcRemoteTrack track) async {
    final manager = e2eeManager;
    if (manager == null) return;

    final userId = _userIdForTrackPrefix(track.trackIdPrefix);
    if (userId == null) {
      _logger.d(
        () =>
            '[attachDecryptor] no participant yet for '
            '${track.trackIdPrefix}; queueing ${track.trackId}',
      );
      _pendingDecryptors[track.trackId] = track;
      return;
    }

    final receiver = await _receiverForTrack(track);
    if (receiver == null) {
      _logger.w(
        () =>
            '[attachDecryptor] no RTP receiver for ${track.trackId}; '
            'frames from $userId stay encrypted',
      );
      return;
    }

    try {
      await manager.decrypt(
        receiver,
        userId: userId,
        trackType: track.trackType.e2eeTrackType,
      );

      _logger.d(
        () =>
            '[attachDecryptor] attached for userId: $userId, '
            'trackType: ${track.trackType}',
      );
    } catch (e, stk) {
      _logger.e(
        () => '[attachDecryptor] failed for userId: $userId: $e',
      );
      _logger.v(() => '[attachDecryptor] $stk');
    }
  }

  /// Retries decryptors that were waiting on a participant.
  Future<void> flushPendingDecryptors() async {
    if (e2eeManager == null || _pendingDecryptors.isEmpty) return;

    for (final trackId in [..._pendingDecryptors.keys]) {
      final track = _pendingDecryptors.remove(trackId);
      if (track == null) continue;

      await attachDecryptor(track);
    }
  }

  /// Drops decryptors still waiting on a participant who has left.
  void discardPendingDecryptors(String trackIdPrefix) {
    _pendingDecryptors.removeWhere(
      (_, track) => track.trackIdPrefix == trackIdPrefix,
    );
  }

  /// The subscriber receiver carrying [track].
  Future<rtc.RTCRtpReceiver?> _receiverForTrack(RtcRemoteTrack track) async {
    final trackId = track.mediaTrack.id;

    try {
      final transceivers = await subscriber.pc.getTransceivers();
      final match = transceivers.firstWhereOrNull(
        (it) => it.receiver.track?.id == trackId,
      );
      if (match != null) return match.receiver;
    } catch (e) {
      _logger.w(() => '[receiverForTrack] getTransceivers failed: $e');
    }

    return track.transceiver?.receiver;
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    _isDisposing = true;

    await _screenSharingStartedSubscription?.cancel();
    _screenSharingStartedSubscription = null;

    final trackIds = [...tracks.keys];
    await Future.wait(
      trackIds.map(
        (trackId) => unpublishTrack(trackId: trackId).catchError(
          (Object e, StackTrace stk) {
            _logger.e(
              () => '[dispose] unpublishTrack failed for $trackId: $e\n$stk',
            );
          },
        ),
      ),
    );

    tracks.clear();
    _pendingDecryptors.clear();

    onLocalTrackMuted = null;
    onLocalTrackPublished = null;
    onRemoteTrackReceived = null;

    // Fail any peer-connection attempt that never finished connecting.
    _publisherConnectReporter?.abortInFlight();
    _subscriberConnectReporter?.abortInFlight();
    _mediaFrameReporter?.dispose();

    await Future.wait([
      if (publisher != null)
        publisher!.dispose().catchError((
          Object e,
          StackTrace stk,
        ) {
          _logger.e(() => '[dispose] publisher.dispose failed: $e\n$stk');
        }),
      subscriber.dispose().catchError((
        Object e,
        StackTrace stk,
      ) {
        _logger.e(() => '[dispose] subscriber.dispose failed: $e\n$stk');
      }),
    ]);

    return super.dispose();
  }

  RtcTrack? getTrack(String trackId) {
    _logger.v(() => '[getTrack] trackId: $trackId');
    return tracks[trackId];
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [
      ...tracks.values.where((track) {
        return track.trackIdPrefix == trackIdPrefix;
      }),
    ];
  }

  /// The Apple audio session configuration last applied with
  /// [setAppleAudioConfiguration].
  rtc.AppleAudioConfiguration? _appleAudioConfiguration;

  /// Applies [policy]'s Apple audio session configuration, asking for the
  /// loudspeaker as the built-in output when [speakerOn].
  @internal
  Future<Result<None>> setAppleAudioConfiguration({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  }) async {
    final configuration = policy.getAppleConfiguration(
      defaultToSpeaker: speakerOn,
    );
    try {
      await rtc.Helper.setAppleAudioConfiguration(configuration);
      _appleAudioConfiguration = configuration;
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Re-applies the configuration last applied with
  /// [setAppleAudioConfiguration], if any.
  ///
  /// Resuming suspended audio restores the configuration the call's factory
  /// was built with, which asks for the loudspeaker only under a policy that
  /// defaults to it. This brings back the loudspeaker the call settings or
  /// an output change asked for since.
  @internal
  Future<Result<None>> restoreAppleAudioConfiguration() async {
    final configuration = _appleAudioConfiguration;
    if (configuration == null) return const Result.success(none);

    try {
      await rtc.Helper.setAppleAudioConfiguration(configuration);
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }
}

extension PublisherRtcManager on RtcManager {
  List<RtcLocalTrack> getPublisherTracks() {
    return [...tracks.values.whereType<RtcLocalTrack>()];
  }

  RtcLocalTrack? getPublisherTrackByType(SfuTrackType trackType) {
    final track = getPublisherTracks().firstWhereOrNull((track) {
      return track.trackType == trackType;
    });

    if (track == null) {
      _logger.d(() => '[getPublisherTrackByType] track not found: $trackType');
      return null;
    }

    return track;
  }

  /// The transceivers currently on the publisher peer connection.
  ///
  /// Never throws as it would abort a renegotiation (leaving the
  /// publisher in `have-local-offer`) or a whole reconnect.
  Future<List<rtc.RTCRtpTransceiver>> _liveTransceivers() async {
    final pc = publisher?.pc;
    if (pc == null) return const [];

    try {
      return await pc.getTransceivers();
    } catch (e, stk) {
      _logger.w(() => '[liveTransceivers] failed: $e\n$stk');
      return const [];
    }
  }

  /// True when the publisher has nothing to offer: no cached, in-flight or
  /// live transceivers.
  Future<bool> isPublisherEmpty() async {
    if (transceiversManager.items().isNotEmpty) return false;
    if (_pendingTransceivers.isNotEmpty) return false;
    return (await _liveTransceivers()).isEmpty;
  }

  /// The SDP of the publisher's local description, or null when unavailable.
  ///
  /// Never throws as it would abort a renegotiation (leaving the
  /// publisher in `have-local-offer`) or a whole reconnect.
  Future<String?> _localSdp() async {
    final pc = publisher?.pc;
    if (pc == null) return null;

    try {
      return (await pc.getLocalDescription())?.sdp;
    } catch (e, stk) {
      _logger.w(() => '[localSdp] failed: $e\n$stk');
      return null;
    }
  }

  /// The tracks to announce in `SetPublisher`, or null when the mid of at least
  /// one sending transceiver that is part of the offer could not be resolved.
  ///
  /// All-or-nothing on purpose: announcing a subset commits an offer whose
  /// omitted m-lines keep sending media the SFU cannot map, and the SFU may read
  /// a missing entry as an unpublish of a track that was working. A null tells
  /// the caller to roll the offer back and retry instead. An empty list is a
  /// different answer — nothing is sending, which is a legitimate no-op.
  ///
  /// A transceiver whose track is absent from the offer entirely (a publish
  /// that landed while this negotiation was preparing) is skipped, not failed
  /// its own queued negotiation announces it right after.
  Future<List<RtcTrackInfo>?> getAnnouncedTracks({String? sdp}) async {
    // Wait for all pending transceivers to settle before announcing tracks.
    //
    // Bounded on purpose: this runs inside the negotiation lock with the offer
    // already applied locally, so waiting forever on a wedged platform call
    // would hold that lock open.
    try {
      await _settlePendingTransceivers().timeout(
        _pendingTransceiverSettleTimeout,
      );
    } on TimeoutException {
      _logger.w(
        () =>
            '[getAnnouncedTracks] pending transceivers did not settle within '
            '$_pendingTransceiverSettleTimeout; failing the announce so the '
            'offer is rolled back',
      );

      return null;
    }

    final finalSdp = sdp ?? await _localSdp();
    final liveTransceivers = await _liveTransceivers();
    final infos = <RtcTrackInfo>[];

    for (final item in transceiversManager.items()) {
      if (item.transceiver.sender.track == null) continue;
      final info = _transceiverToTrackInfo(
        item,
        sdp: finalSdp,
        liveTransceivers: liveTransceivers,
      );

      if (info == null) {
        // A publish that landed after this offer was created is announced by
        // its own queued negotiation, not this one.
        if (isMidFlightPublish(item, finalSdp)) continue;
        return null;
      }
      infos.add(info);
    }

    return infos;
  }

  /// Waits out every in-flight transceiver creation, so the cache reflects
  /// what the peer connection is actually sending.
  Future<void> _settlePendingTransceivers() async {
    while (_pendingTransceivers.isNotEmpty) {
      await Future.wait(_pendingTransceivers.values.toList());
    }
  }

  /// The tracks to report in `ReconnectDetails`.
  ///
  /// Best-effort, unlike [getAnnouncedTracks]: this runs against the previous
  /// session, whose peer connection is often already closed, and there is no
  /// offer to roll back. Aborting a reconnect over an unresolved mid is worse
  /// than reporting what we do know, so unresolved tracks are dropped. With the
  /// publisher gone the mid usually comes from [TransceiverCache.negotiatedMid],
  /// i.e. the last announce the SFU acknowledged.
  Future<List<RtcTrackInfo>> getAnnouncedTracksForReconnect({
    String? sdp,
  }) async {
    final finalSdp = sdp ?? await _localSdp();
    final liveTransceivers = await _liveTransceivers();
    final infos = <RtcTrackInfo>[];
    final seenKeys = <TransceiverKey>{};

    for (final publishOption in publishOptions) {
      if (!seenKeys.add(publishOption.transceiverKey)) continue;

      final item = transceiversManager.get(publishOption);

      if (item?.transceiver.sender.track == null) continue;
      final info = _transceiverToTrackInfo(
        item!,
        sdp: finalSdp,
        liveTransceivers: liveTransceivers,
      );

      if (info == null) continue;

      infos.add(info);
    }

    return infos;
  }

  RtcTrackInfo? _transceiverToTrackInfo(
    TransceiverCache transceiverCache, {
    required List<rtc.RTCRtpTransceiver> liveTransceivers,
    String? sdp,
  }) {
    return transceiverToTrackInfo(
      transceiverCache,
      liveTransceivers: liveTransceivers,
      sdp: sdp,
      audioSettings: stateManager.callState.settings.audio,
      dimensionOf: captureDimensionResolver.resolve,
      onMidUnresolved: (data) {
        publisher?.tracer.trace(TraceTag.trackMidUnresolved, data);
      },
    );
  }

  /// Removes all tracks from the publisher with the given [trackIdPrefix].
  Future<void> removeSubscriber(String trackIdPrefix) async {
    final tracks = getTracks(trackIdPrefix);
    for (final track in tracks) {
      await unpublishTrack(trackId: track.trackId);
    }
  }

  Future<Result<RtcLocalTrack>> publishTrack(RtcLocalTrack track) async {
    if (track is RtcLocalAudioTrack) {
      return publishAudioTrack(
        track: track,
        stopTrackOnMute: track.stopTrackOnMute,
      );
    }
    if (track is RtcLocalVideoTrack) return publishVideoTrack(track: track);

    return Result.failure('Unsupported track type: ${track.runtimeType}');
  }

  /// Undoes the bookkeeping of a publish that registered its track and then
  /// failed.
  ///
  /// [publishAudioTrack] and [publishVideoTrack] register [registered] before
  /// any sender exists so `onPublisherNegotiationNeeded` can see it, and there
  /// is no matching `unpublishTrack` when the publish never completes. Left
  /// behind, the entry makes [getPublisherTrackByType] report a track that
  /// never reached the SFU: the next enable takes the unmute path instead of
  /// retrying the publish, and the camera or microphone keeps capturing for a
  /// sender that does not exist.
  ///
  /// [acquired] is the same track carrying whatever clones the publish managed
  /// to make; stopping it releases the device.
  Future<void> _discardFailedPublish({
    required RtcLocalTrack registered,
    required RtcLocalTrack acquired,
  }) async {
    // A concurrent publish may already own the entry — drop only our own.
    if (identical(tracks[registered.trackId], registered)) {
      tracks.remove(registered.trackId);
    }

    await acquired.stop();
  }

  Future<Result<RtcLocalAudioTrack>> publishAudioTrack({
    required RtcLocalAudioTrack track,
    bool stopTrackOnMute = true,
  }) async {
    var audioTrack = track;

    // Add publisherId to the trackIdPrefix if it's a local track.
    if (audioTrack.trackIdPrefix == kLocalTrackIdPrefix) {
      audioTrack = audioTrack.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishAudioTrack] track: $audioTrack');
    tracks[audioTrack.trackId] = audioTrack;
    var updatedTrack = audioTrack.copyWith(stopTrackOnMute: stopTrackOnMute);
    var needsRenegotiation = false;

    // Ensure a new live audio track isn't still muted by an existing ADM-level mute.
    // ADM mute persists beyond sessions (per-call factory).
    if (_isAppleAdmMuteSupported(audioTrack) && audioTrack.mediaTrack.enabled) {
      await _setAppleAdmMicrophoneMuted(false);
    }

    for (final option in publishOptions) {
      if (option.trackType != audioTrack.trackType) continue;

      // Create a clone of the track so each transceiver has a unique trackId
      // in the SDP, matching the JS SDK pattern.
      final mediaTrackClone = await audioTrack.mediaTrack.clone();
      final trackToPublish = audioTrack.copyWith(mediaTrack: mediaTrackClone);

      // Another publish may have claimed this key and still be waiting on the
      // platform. Let it settle, then re-read: whoever claimed first creates
      // the sender, everyone else reuses it through `replaceTrack` below.
      var pending = _pendingTransceivers[option.transceiverKey];
      while (pending != null) {
        await pending;
        pending = _pendingTransceivers[option.transceiverKey];
      }

      final cachedBundle = transceiversManager.get(option);
      final cachedTransceiver = cachedBundle?.transceiver;
      if (cachedTransceiver == null) {
        final transceiverResult = await _addTransceiver(
          trackToPublish,
          option,
          RtcTrackPublishOptions(
            audioBitrateProfile: stateManager.callState.audioBitrateProfile,
          ),
        );

        if (transceiverResult is Failure) {
          await mediaTrackClone.stop();
          await _discardFailedPublish(
            registered: audioTrack,
            acquired: updatedTrack,
          );
          return transceiverResult;
        }

        _logger.v(() => '[publishAudioTrack] transceiver: $transceiverResult');
      } else {
        final previousTrack = cachedTransceiver.sender.track;
        final publishOptions = RtcTrackPublishOptions(
          audioBitrateProfile: stateManager.callState.audioBitrateProfile,
        );
        await _updateTransceiver(
          cachedTransceiver,
          trackToPublish,
          audioTrack.trackType,
          trackPublishOptions: publishOptions,
        );
        await previousTrack?.stop();

        transceiversManager.update(
          option,
          track: trackToPublish,
          trackPublishOptions: publishOptions,
        );

        // Reusing a transceiver via replaceTrack does not fire
        // onRenegotiationNeeded. If its previous negotiation never reached the
        // SFU, the SFU still doesn't know about it, so force a renegotiation.
        // The same holds for a sender that was detached: an announce made
        // meanwhile left it out, so the SFU may have dropped it.
        if (cachedBundle != null &&
            (!cachedBundle.negotiated || previousTrack == null)) {
          needsRenegotiation = true;
        }

        _logger.v(
          () => '[publishAudioTrack] cached transceiver: $cachedTransceiver',
        );
      }

      updatedTrack = updatedTrack.copyWith(
        clonedTracks: [...updatedTrack.clonedTracks, mediaTrackClone],
      );
    }

    if (needsRenegotiation) {
      _forceRenegotiation('[publishAudioTrack]');
    }

    if (_isDisposing) {
      _logger.w(
        () =>
            '[publishAudioTrack] disposed mid-publish; discarding '
            '${updatedTrack.trackId}',
      );
      await _discardFailedPublish(
        registered: audioTrack,
        acquired: updatedTrack,
      );
      return failureWithError('RtcManager was disposed while publishing');
    }

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    tracks[updatedTrack.trackId] = updatedTrack;

    // Republishing restarts capture, which drops the ADM mute. No-op when the
    // ADM already matches the track being published.
    await reconcileAppleAdmMicrophoneMute();

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalVideoTrack>> publishVideoTrack({
    required RtcLocalVideoTrack track,
    bool stopTrackOnMute = true,
  }) async {
    var videoTrack = track;

    // Add publisherId to the trackIdPrefix if it's a local track.
    if (videoTrack.trackIdPrefix == kLocalTrackIdPrefix) {
      videoTrack = videoTrack.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishVideoTrack] track: $videoTrack');
    tracks[videoTrack.trackId] = videoTrack;
    var updatedTrack = videoTrack.copyWith(
      videoDimension: captureDimensionResolver.resolve(videoTrack),
      stopTrackOnMute: stopTrackOnMute,
    );

    if (!publishOptions.any((o) => o.trackType == videoTrack.trackType)) {
      _logger.w(
        () =>
            '[publishVideoTrack] No publish options found for track type: ${videoTrack.trackType}',
      );
      await _discardFailedPublish(
        registered: videoTrack,
        acquired: updatedTrack,
      );
      return failureWithError(
        'No publish options found for track type: ${videoTrack.trackType}',
      );
    }

    var needsRenegotiation = false;

    for (final option in publishOptions) {
      if (option.trackType != videoTrack.trackType) continue;

      // Create a clone of the track so each transceiver has a unique trackId
      // in the SDP, matching the JS SDK pattern.
      final mediaTrackClone = await videoTrack.mediaTrack.clone();
      // Carry the resolved size over: on Android the clone has no settings,
      // so it could not work out the capture size itself.
      final trackToPublish = videoTrack.copyWith(
        mediaTrack: mediaTrackClone,
        videoDimension: updatedTrack.videoDimension,
      );

      // Another publish may have claimed this key and still be waiting on the
      // platform. Let it settle, then re-read: whoever claimed first creates
      // the sender, everyone else reuses it through `replaceTrack` below.
      var pending = _pendingTransceivers[option.transceiverKey];
      while (pending != null) {
        await pending;
        pending = _pendingTransceivers[option.transceiverKey];
      }

      final cachedBundle = transceiversManager.get(option);
      final cachedTransceiver = cachedBundle?.transceiver;
      if (cachedTransceiver == null) {
        final transceiverResult = await _addTransceiver(
          trackToPublish,
          option,
          const RtcTrackPublishOptions(),
        );

        if (transceiverResult is Failure) {
          await mediaTrackClone.stop();
          await _discardFailedPublish(
            registered: videoTrack,
            acquired: updatedTrack,
          );
          return transceiverResult;
        }

        _logger.v(
          () => '[publishVideoTrack] new transceiver: $transceiverResult',
        );
      } else {
        final previousTrack = cachedTransceiver.sender.track;
        await _updateTransceiver(
          cachedTransceiver,
          trackToPublish,
          videoTrack.trackType,
        );
        await previousTrack?.stop();

        transceiversManager.update(option, track: trackToPublish);

        // Reusing a transceiver via replaceTrack does not fire
        // onRenegotiationNeeded. If its previous negotiation never reached the
        // SFU, the SFU still doesn't know about it, so force a renegotiation.
        // The same holds for a sender that was detached: an announce made
        // meanwhile left it out, so the SFU may have dropped it.
        if (cachedBundle != null &&
            (!cachedBundle.negotiated || previousTrack == null)) {
          needsRenegotiation = true;
        }

        _logger.v(
          () => '[publishVideoTrack] cached transceiver: $cachedTransceiver',
        );
      }

      updatedTrack = updatedTrack.copyWith(
        clonedTracks: [...updatedTrack.clonedTracks, mediaTrackClone],
      );
    }

    if (needsRenegotiation) {
      _forceRenegotiation('[publishVideoTrack]');
    }

    if (_isDisposing) {
      _logger.w(
        () =>
            '[publishVideoTrack] disposed mid-publish; discarding '
            '${updatedTrack.trackId}',
      );
      await _discardFailedPublish(
        registered: videoTrack,
        acquired: updatedTrack,
      );
      return failureWithError('RtcManager was disposed while publishing');
    }

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  /// Explicitly triggers a publisher renegotiation.
  void _forceRenegotiation(String tag) {
    final pub = publisher;
    if (pub == null) return;

    if (pub.isReconnecting) {
      _logger.v(
        () => '$tag skipping forced renegotiation — reconnect in progress',
      );
      return;
    }

    _logger.v(
      () =>
          '$tag forcing renegotiation for a reused transceiver the SFU never '
          'acknowledged',
    );

    pub.onRenegotiationNeeded?.call(pub);
  }

  /// Forces a publisher renegotiation if any transceiver sending [trackId]
  /// was never acknowledged by the SFU.
  void _renegotiateIfUnacknowledged(String trackId, String tag) {
    final hasUnacknowledged = transceiversManager
        .findAll((t) => t.track.trackId == trackId)
        .any((t) => t.transceiver.sender.track != null && !t.negotiated);

    if (hasUnacknowledged) {
      _forceRenegotiation(tag);
    }
  }

  /// Creates the sender for [publishOptions], claiming its
  /// `(trackType, publishOptionId)` for the duration.
  ///
  /// Deliberately **not** `async`: everything up to the claim runs in the same
  /// synchronous step as the caller's cache lookup, so no other publish can
  /// slip between "this key is free" and "this key is mine".
  Future<Result<rtc.RTCRtpTransceiver>> _addTransceiver(
    RtcLocalTrack track,
    SfuPublishOptions publishOptions,
    RtcTrackPublishOptions trackPublishOptions,
  ) {
    if (publisher == null) {
      return Future.value(
        failureWithError<rtc.RTCRtpTransceiver>(
          'Publisher is not created, cannot add transceiver',
        ),
      );
    }

    // The SFU rejects a publisher that announces the same key twice, so a
    // second sender must never exist — not even briefly. Callers check the
    // cache and wait out [_pendingTransceivers] before getting here, so this
    // is a backstop; failing is the honest answer, since the caller's track
    // would not be the one on the wire.
    final key = publishOptions.transceiverKey;
    if (transceiversManager.has(publishOptions) ||
        _pendingTransceivers.containsKey(key)) {
      _logger.e(
        () =>
            '[addTransceiver] duplicate publish for trackType: '
            '${publishOptions.trackType}, publishOptionId: '
            '${publishOptions.id} — rejecting',
      );

      return Future.value(
        failureWithError<rtc.RTCRtpTransceiver>(
          'Already publishing trackType: ${publishOptions.trackType} with '
          'publishOptionId: ${publishOptions.id}',
        ),
      );
    }

    final claim = Completer<void>();
    _pendingTransceivers[key] = claim.future;

    return _createTransceiver(
      track,
      publishOptions,
      trackPublishOptions,
    ).whenComplete(() {
      _pendingTransceivers.remove(key);
      claim.complete();
    });
  }

  /// Encrypts everything [transceiver]'s sender publishes.
  Future<Result<None>> _attachEncryptor(
    rtc.RTCRtpTransceiver transceiver,
    SfuPublishOptions publishOptions,
  ) async {
    final manager = e2eeManager;
    if (manager == null) return const Result.success(none);

    final codecPin = publishOptions.codec.e2eeCodecPin;
    final trackType = publishOptions.trackType.e2eeTrackType;

    try {
      await manager.encrypt(
        transceiver.sender,
        codec: codecPin,
        trackType: trackType,
      );

      _logger.d(
        () =>
            '[attachEncryptor] attached; codec: $codecPin, '
            'trackType: $trackType',
      );

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(
        () =>
            '[attachEncryptor] failed for trackType: '
            '${publishOptions.trackType}; refusing to publish cleartext: $e',
      );
      _logger.v(() => '[attachEncryptor] $stk');

      return failureWithError(
        'Failed to attach the E2EE encryptor for trackType: '
        '${publishOptions.trackType}: $e',
      );
    }
  }

  Future<Result<rtc.RTCRtpTransceiver>> _createTransceiver(
    RtcLocalTrack track,
    SfuPublishOptions publishOptions,
    RtcTrackPublishOptions trackPublishOptions,
  ) async {
    Result<rtc.RTCRtpTransceiver>? transceiverResult;

    _logger.v(
      () =>
          '[addTransceiver] adding transceiver for: ${publishOptions.codec.name}, trackId: ${track.mediaTrack.id}',
    );

    if (track is RtcLocalAudioTrack) {
      final audioEncodings = codecs.findOptimalAudioLayers(
        publishOptions: publishOptions,
        trackPublishOptions: trackPublishOptions,
      );
      transceiverResult = await publisher!.addAudioTransceiver(
        track: track.mediaTrack,
        encodings: audioEncodings,
      );
    } else if (track is RtcLocalVideoTrack) {
      final captureDimension = captureDimensionResolver.resolve(track);
      final videoEncodings = codecs.findOptimalVideoLayers(
        dimensions: captureDimension,
        publishOptions: publishOptions,
      );

      final sendEncodings = isSvcCodec(publishOptions.codec.name)
          ? toSvcEncodings(videoEncodings)
          : videoEncodings;

      _logger.d(
        () =>
            '[addTransceiver] ${publishOptions.trackType} layers: '
            'publishOption(id: ${publishOptions.id}, '
            'codec: ${publishOptions.codec.name}, '
            'bitrate: ${publishOptions.bitrate}, '
            'dimension: ${publishOptions.videoDimension}, '
            'useSingleLayer: ${publishOptions.useSingleLayer}), '
            'capture: $captureDimension, '
            'encodings: ${sendEncodings.map(describeEncoding).join(', ')}',
      );

      transceiverResult = await publisher!.addVideoTransceiver(
        track: track.mediaTrack,
        encodings: sendEncodings,
        degradationPreference: publishOptions.degradationPreference,
      );
    } else {
      return failureWithError('Unsupported track type: ${track.runtimeType}');
    }

    // Return early if the transceiver could not be added.
    if (transceiverResult is Failure) return transceiverResult;

    final transceiver = transceiverResult.getDataOrNull()!;

    // Attach before the answer is negotiated so the first encoded frame this
    // sender produces is already encrypted.
    final encryptorResult = await _attachEncryptor(transceiver, publishOptions);
    if (encryptorResult is Failure) {
      // Drop the sender: leaving it in place would negotiate an m-line that
      // publishes unencrypted media.
      final stopped = await _stopTransceiver(transceiver);
      if (!stopped) {
        _logger.e(
          () =>
              '[addTransceiver] could not stop the sender for trackType: '
              '${publishOptions.trackType} after its encryptor failed; it may '
              'still negotiate and publish unencrypted',
        );
      }

      return failureWithError(encryptorResult.videoError.message);
    }

    final cached = transceiversManager.add(
      track,
      publishOptions,
      transceiver,
      trackPublishOptions,
    );

    if (!cached) {
      _logger.e(
        () =>
            '[addTransceiver] cache already holds trackType: '
            '${publishOptions.trackType}, publishOptionId: '
            '${publishOptions.id} — discarding the sender just created',
      );

      await _stopTransceiver(transceiver);

      return failureWithError(
        'Already publishing trackType: ${publishOptions.trackType} with '
        'publishOptionId: ${publishOptions.id}',
      );
    }

    return Result.success(transceiver);
  }

  Future<void> _updateTransceiver(
    RTCRtpTransceiver transceiver,
    RtcLocalTrack? track,
    SfuTrackType trackType, {
    RtcTrackPublishOptions? trackPublishOptions,
  }) async {
    await transceiver.sender.replaceTrack(track?.mediaTrack);

    if (track is RtcLocalAudioTrack) {
      await _updateAudioPublishOptions(
        track.trackType,
        trackPublishOptions ?? const RtcTrackPublishOptions(),
      );
    }
  }

  /// Stops [transceiver] so its m-line becomes recyclable, reporting whether
  /// it actually stopped.
  Future<bool> _stopTransceiver(RTCRtpTransceiver transceiver) async {
    try {
      await transceiver.stop();
      return true;
    } catch (e, stk) {
      _logger.w(() => '[stopTransceiver] failed: $e\n$stk');
      return false;
    }
  }

  Future<void> _updateAudioPublishOptions(
    SfuTrackType trackType,
    RtcTrackPublishOptions options,
  ) async {
    for (final publishOption in publishOptions) {
      if (publishOption.trackType != trackType) continue;
      final transceiverBundle = transceiversManager.get(publishOption);
      if (transceiverBundle == null) continue;

      final transceiver = transceiverBundle.transceiver;
      final current = transceiverBundle.trackPublishOptions;
      if (current.audioBitrateProfile != options.audioBitrateProfile) {
        final encodings = codecs.findOptimalAudioLayers(
          publishOptions: publishOption,
          trackPublishOptions: options,
        );

        final params = transceiver.sender.parameters;
        if (applyAudioBitrate(params, encodings)) {
          await transceiver.sender.setParameters(params);
        }
      }

      transceiverBundle.trackPublishOptions = options;
    }
  }

  Future<Result<RtcLocalTrack>> muteTrack({
    required String trackId,
    bool? stopTrackOnMute,
  }) async {
    final originalTrack = tracks[trackId];

    if (originalTrack == null) {
      _logger.w(() => 'muteTrack: track not found');
      return failureWithError('Track not found');
    }

    if (originalTrack is! RtcLocalTrack) {
      _logger.w(() => 'muteTrack: track is not local');
      return failureWithError('Track is not local');
    }

    // If [stopTrackOnMute] is true or unset, the track is stopped and released (default).
    // If false, the track stays alive and is muted at the device level (iOS/macOS only).
    final track = originalTrack.copyWith(stopTrackOnMute: stopTrackOnMute);
    tracks[trackId] = track;

    final useAdmLevelMute =
        !track.stopTrackOnMute && _isAppleAdmMuteSupported(track);

    track.disable();
    if (useAdmLevelMute) {
      await _setAppleAdmMicrophoneMuted(true);
    } else if (track.stopTrackOnMute) {
      // Releases the track and stops the permission indicator.
      await track.stop();
    }

    onLocalTrackMuted?.call(track, true);
    return Result.success(track);
  }

  Future<Result<RtcLocalTrack>> unmuteTrack({
    required String trackId,
  }) async {
    final track = tracks[trackId];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return failureWithError('Track not found');
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'unmuteTrack: track is not local');
      return failureWithError('Track is not local');
    }

    // Lift any ADM-level mute on iOS/macOS. Deliberately not gated on
    // [stopTrackOnMute]: a soft mute (ADM muted) followed by a hard mute
    // leaves the ADM muted, and the recreate path below neither clears it nor
    // goes through publishAudioTrack's reconcile — which would leave a live,
    // published track with capture silenced inside the ADM.
    if (_isAppleAdmMuteSupported(track)) {
      await _setAppleAdmMicrophoneMuted(false);
    }

    // A soft-muted track was never released, but it is still capturing with
    // the constraints it was created with — enabling it again would leave it
    // on the stale ones and skip the publish-options update below. So it is
    // recreated too whenever [_defaultAudioConstraints] moved on since.
    //
    // A track that is still enabled was never muted — joining with a track
    // from the lobby unmutes it straight after publishing. Recreating it would
    // stop the camera or microphone and acquire it again for nothing, so only
    // stale constraints justify it.
    final wasReleased = track.stopTrackOnMute && !track.mediaTrack.enabled;
    if (wasReleased || _hasStaleAudioConstraints(track)) {
      final transceivers = transceiversManager
          .getTransceiversForTrack(track.trackId)
          .toList();

      final updatedTrack = await track.recreate(
        transceivers,
        mediaConstraints: track.trackType == SfuTrackType.audio
            ? _defaultAudioConstraints
            : null,
      );

      if (track is RtcLocalAudioTrack) {
        await _updateAudioPublishOptions(
          track.trackType,
          RtcTrackPublishOptions(
            audioBitrateProfile: stateManager.callState.audioBitrateProfile,
          ),
        );
      }

      tracks[trackId] = updatedTrack;
      onLocalTrackMuted?.call(updatedTrack, false);

      _renegotiateIfUnacknowledged(trackId, '[unmuteTrack]');
      return Result.success(updatedTrack);
    }

    // Otherwise simply enable it again
    track.enable();
    onLocalTrackMuted?.call(track, false);

    _renegotiateIfUnacknowledged(trackId, '[unmuteTrack]');
    return Result.success(track);
  }

  /// Whether [track] captures with audio constraints that no longer match
  /// [_defaultAudioConstraints].
  bool _hasStaleAudioConstraints(RtcLocalTrack track) {
    if (track is! RtcLocalAudioTrack) return false;

    final current = track.mediaConstraints;
    final next = _defaultAudioConstraints;

    return current.noiseSuppression != next.noiseSuppression ||
        current.echoCancellation != next.echoCancellation ||
        current.autoGainControl != next.autoGainControl ||
        current.highPassFilter != next.highPassFilter ||
        current.typingNoiseDetection != next.typingNoiseDetection ||
        current.channelCount != next.channelCount;
  }

  /// Returns true if [track] should use ADM-level mute.
  /// Audio tracks on iOS / macOS only.
  bool _isAppleAdmMuteSupported(RtcLocalTrack track) =>
      pcFactory.isAppleAdmMicrophoneMuteSupported &&
      track.trackType == SfuTrackType.audio;

  Future<void> _setAppleAdmMicrophoneMuted(bool muted) async {
    try {
      await pcFactory.setAppleAdmMicrophoneMuted(muted);
    } catch (e, stk) {
      _logger.w(() => '[setAppleAdmMicrophoneMuted] failed: $e\n$stk');
    }
  }

  /// Reads the ADM's own mute state, or `null` when it cannot be determined.
  Future<bool?> _getAppleAdmMicrophoneMuted() async {
    try {
      return await pcFactory.isAppleAdmMicrophoneMuted();
    } catch (e, stk) {
      _logger.w(() => '[getAppleAdmMicrophoneMuted] failed: $e\n$stk');
      return null;
    }
  }

  /// Syncs the ADM mute state with the local audio track, to avoid mismatches
  /// after audio restarts or suspends. Idempotent: only updates when needed.
  ///
  /// No-op on platforms without ADM-level mute.
  Future<void> reconcileAppleAdmMicrophoneMute() async {
    final track = getPublisherTrackByType(SfuTrackType.audio);
    if (track == null) return;
    if (!_isAppleAdmMuteSupported(track)) return;

    final bool desiredMuted;
    if (track.mediaTrack.enabled) {
      // A live track must never stay silenced by a leftover ADM mute.
      desiredMuted = false;
    } else if (!track.stopTrackOnMute) {
      // A disabled track is the SDK's muted state when using ADM-level mute.
      desiredMuted = true;
    } else {
      // When the track is muted by stopping it, ADM mute is not used.
      return;
    }

    final actual = await _getAppleAdmMicrophoneMuted();
    if (actual == desiredMuted) return;

    _logger.w(
      () =>
          '[reconcileAppleAdmMicrophoneMute] ADM mute out of sync '
          '(adm reported: $actual, expected: $desiredMuted), re-applying for '
          'track ${track.trackId}',
    );
    await _setAppleAdmMicrophoneMuted(desiredMuted);
  }

  Future<Result<RtcLocalAudioTrack>> createAudioTrack({
    AudioConstraints? constraints,
  }) async {
    _logger.d(() => '[createAudioTrack] constraints: ${constraints?.toMap()}');

    if (publisher == null || publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create audio track',
      );
    }

    try {
      final nativeFactory = await pcFactory.ensureNativeFactory();
      final audioTrack = await RtcLocalTrack.audio(
        trackIdPrefix: publisherId!,
        constraints: constraints ?? _defaultAudioConstraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(audioTrack);
    } catch (e, stk) {
      _logger.e(() => '[createAudioTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<RtcLocalCameraTrack>> createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    _logger.d(() => '[createCameraTrack] constraints: ${constraints.toMap()}');

    if (publisher == null || publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create camera track',
      );
    }

    try {
      final nativeFactory = await pcFactory.ensureNativeFactory();
      final videoTrack = await RtcLocalTrack.camera(
        trackIdPrefix: publisherId!,
        constraints: constraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(videoTrack);
    } catch (e, stk) {
      _logger.e(() => '[createCameraTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<RtcLocalScreenShareTrack>> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    _logger.d(
      () => '[createScreenShareTrack] constraints: ${constraints.toMap()}',
    );

    if (publisher == null || publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create screen share track',
      );
    }

    try {
      final nativeFactory = await pcFactory.ensureNativeFactory();
      final screenShareTrack = await RtcLocalTrack.screenShare(
        trackIdPrefix: publisherId!,
        constraints: constraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(screenShareTrack);
    } catch (e, stk) {
      _logger.e(() => '[createScreenShareTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<RtcLocalCameraTrack>> setTrackFacingMode({
    required FacingMode facingMode,
  }) async {
    _logger.d(() => '[setTrackFacingMode] facingMode: $facingMode');

    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) return failureWithError('Track not found');

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setTrackFacingMode] rejected (track is not camera)');
      return failureWithError('Track is not camera');
    }

    final transceivers = transceiversManager
        .getTransceiversForTrack(track.trackId)
        .toList();

    final updatedTrack = await track.recreate(
      transceivers,
      mediaConstraints: track.mediaConstraints.copyWith(facingMode: facingMode),
    );

    tracks[updatedTrack.trackId] = updatedTrack;
    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalCameraTrack>> setCameraVideoParameters({
    required RtcVideoParameters params,
  }) async {
    _logger.d(() => '[setCameraVideoParameters] params: $params');

    final track = getPublisherTrackByType(SfuTrackType.video);

    if (track == null) {
      _logger.w(() => '[setCameraVideoParameters] rejected (track not found)');
      return failureWithError('Track not found');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.w(
        () => '[setCameraVideoParameters] rejected (track is not camera)',
      );
      return failureWithError('Track is not camera');
    }

    final transceivers = transceiversManager
        .getTransceiversForTrack(track.trackId)
        .toList();

    final updatedTrack = await track.recreate(
      transceivers,
      mediaConstraints: track.mediaConstraints.copyWith(
        params: track.mediaConstraints.params.copyWith(
          dimension: params.dimension,
        ),
      ),
    );

    tracks[updatedTrack.trackId] = updatedTrack;
    return Result.success(updatedTrack);
  }
}
