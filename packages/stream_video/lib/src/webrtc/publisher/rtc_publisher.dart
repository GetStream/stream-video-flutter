import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../../../stream_video.dart';
import '../../call/stats/trace_tag.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../sfu/data/models/sfu_publish_options.dart';
import '../../sfu/data/models/sfu_video_sender.dart';
import '../audio/adm_microphone_mute.dart';
import '../codecs_helper.dart' as codecs;
import '../codecs_helper.dart';
import '../e2ee/e2ee_mapping.dart';
import '../media/capture_dimension.dart';
import '../model/rtc_tracks_info.dart';
import '../peer_connection.dart';
import '../rtc_track/rtc_track_publish_options.dart';
import '../traced_peer_connection.dart';
import '../transceiver_cache.dart';
import 'announced_tracks.dart';
import 'publish_quality.dart';

/// {@template OnLocalTrackMuted}
/// Called when a local track is muted or unmuted; [muted] says which.
/// {@endtemplate}
typedef OnLocalTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnLocalTrackPublished}
/// Called when a local track is published.
/// {@endtemplate}
typedef OnLocalTrackPublished = void Function(RtcLocalTrack track);

final _logger = taggedLogger(tag: 'SV:RtcPublisher');

/// How long [RtcPublisher.getAnnouncedTracks] waits for in-flight transceiver
/// creations before giving up on the current negotiation.
const _pendingTransceiverSettleTimeout = Duration(seconds: 5);

/// The sending side of a call session: the publisher peer connection and the
/// local tracks it sends.
///
/// It sends each local track on one transceiver per publish option, encrypts
/// those senders when the call is end-to-end encrypted, mutes and unmutes the
/// tracks (keeping the microphone mute of the audio device module in step
/// where there is one), follows the SFU's publish options and publish
/// quality, and builds the tracks announced in `SetPublisher` and
/// `ReconnectDetails`.
///
/// It does not acquire new tracks: they come in already acquired. Unmuting,
/// a facing-mode change, new camera parameters, a camera switch and new
/// default audio constraints capture a track it holds again, one recapture
/// of a track at a time. It also keeps the one acquire-and-publish in flight per
/// track type, which the caller starts through [singleFlight].
///
/// A session that does not publish has no peer connection: [pc] is null and
/// a publish fails, without keeping its track, at its first transceiver.
@internal
class RtcPublisher {
  RtcPublisher({
    required this.pc,
    required this.publisherId,
    required this.publishOptions,
    required AdmMicrophoneMute Function() admMute,
    required this._captureDimensionResolver,
    required this._audioBitrateProfile,
    required this._audioSettings,
    required this._defaultAudioConstraints,
    this._e2eeManager,
  }) : _createAdmMute = admMute;

  /// The publisher peer connection, or null when this session does not
  /// publish.
  final TracedStreamPeerConnection? pc;

  /// The prefix given to the id of every local track published here.
  final String? publisherId;

  /// The publish options from the SFU, one or more per track type.
  List<SfuPublishOptions> publishOptions;

  final AdmMicrophoneMute Function() _createAdmMute;

  /// The ADM mute, made on first use.
  late final AdmMicrophoneMute _admMute = _createAdmMute();
  final CaptureDimensionResolver _captureDimensionResolver;

  /// The audio bitrate profile of the call.
  final SfuAudioBitrateProfile Function() _audioBitrateProfile;

  /// The audio settings of the call.
  final StreamAudioSettings Function() _audioSettings;

  /// The constraints a microphone track is acquired with when none are given.
  final AudioConstraints Function() _defaultAudioConstraints;

  /// End-to-end encryption for the senders, or null when the call is
  /// unencrypted.
  final rtc.EncryptionManager? _e2eeManager;

  /// The transceiver of every publish option that has one.
  final transceiversManager = TransceiverManager();

  bool _isDisposing = false;

  /// Publishes that have claimed a `(trackType, publishOptionId)` and are
  /// still creating their transceiver.
  final _pendingTransceivers = <TransceiverKey, Future<void>>{};

  /// The local tracks by track id.
  final tracks = </*trackId*/ String, RtcLocalTrack>{};

  /// The media tracks given to the next session by [handOverLocalTracks], by
  /// track id. Unpublishing a track that still holds that media track stops
  /// only this session's clones.
  final _handedOverMediaTracks = <String, rtc.MediaStreamTrack>{};

  /// The acquire-and-publish running for each track type.
  final _inFlight = InFlightCache<SfuTrackType, Result<RtcLocalTrack>>();

  /// The recapture running for each track id.
  final _recaptures = <String, Completer<void>>{};

  OnLocalTrackMuted? onLocalTrackMuted;
  OnLocalTrackPublished? onLocalTrackPublished;

  /// Runs [create] as the single acquire-and-publish in flight for
  /// [trackType], returning the already-running one when there is one.
  Future<Result<RtcLocalTrack>> singleFlight(
    SfuTrackType trackType,
    Future<Result<RtcLocalTrack>> Function() create,
  ) {
    if (_inFlight.inFlight(trackType) != null) {
      _logger.i(
        () =>
            '[createTrack] $trackType is already being created; '
            'joining the in-flight request instead of acquiring media again',
      );
    }
    return _inFlight.run(trackType, create);
  }

  /// The acquire-and-publish in flight for [trackType], if any.
  Future<Result<RtcLocalTrack>>? inFlight(SfuTrackType trackType) {
    return _inFlight.inFlight(trackType);
  }

  /// Marks the transceivers sending [announced] as acknowledged by the SFU.
  void markNegotiated(Iterable<RtcTrackInfo> announced) {
    transceiversManager.markNegotiated(announced);
  }

  /// Syncs the ADM mute state with the local audio track, to avoid mismatches
  /// after audio restarts or suspends. Idempotent: only updates when needed.
  ///
  /// No-op on platforms without ADM-level mute.
  Future<void> reconcileAdmMute() {
    return _admMute.reconcile(getPublisherTrackByType(SfuTrackType.audio));
  }

  /// Recaptures the live microphone tracks with the default audio
  /// constraints, on the senders that carry them.
  ///
  /// A muted track is left muted: it picks the constraints up when it is
  /// unmuted. Nothing is muted or unmuted along the way, except a track that
  /// cannot be captured again, which is reported muted. Never throws.
  Future<void> restartLiveAudioTracks() async {
    final trackIds = [
      for (final track in tracks.values)
        if (track.trackType == SfuTrackType.audio) track.trackId,
    ];

    for (final trackId in trackIds) {
      final track = tracks[trackId];
      if (track == null) continue;

      // Checked once this recapture's turn starts: a recapture still running
      // has disabled the capture it replaces, and a track muted meanwhile
      // stays muted.
      final recaptured = await recapture(
        trackId,
        tag: '[restartLiveAudioTracks]',
        constraintsFor: (_) => _defaultAudioConstraints(),
        skipIf: (current) => !current.mediaTrack.enabled,
      );

      // The old capture is stopped, so the microphone is reported muted.
      // Unmuting captures it again, with the new constraints. A microphone
      // published again meanwhile is live, and is left alone.
      final held = tracks[trackId];
      if (recaptured.isFailure &&
          held != null &&
          identical(held.mediaTrack, track.mediaTrack)) {
        onLocalTrackMuted?.call(held, true);
      }
    }

    // Recapturing drops the ADM mute; no-op when it already matches.
    try {
      await reconcileAdmMute();
    } catch (e, stk) {
      _logger.e(
        () => '[restartLiveAudioTracks] ADM reconcile failed: $e\n$stk',
      );
    }
  }

  /// Stops the local track of [trackId], its clones and media stream, and
  /// calls `pc.removeTrack` on every sender that referenced it. A track handed
  /// over by [handOverLocalTracks] has only its clones stopped. Returns false
  /// when there is no local track of [trackId].
  Future<bool> unpublishTrack({
    required String trackId,
  }) async {
    final publishedTrack = tracks.remove(trackId);
    if (publishedTrack == null) return false;

    await _stopLocalTrack(publishedTrack);

    for (final publishOption in publishOptions) {
      if (publishOption.trackType != publishedTrack.trackType) continue;

      final transceiver = transceiversManager.get(publishOption)?.transceiver;

      try {
        if (transceiver != null) {
          await pc?.pc.removeTrack(transceiver.sender);
        }
      } catch (e) {
        _logger.w(() => '[unpublishTrack] removeTrack failed: $e');
      }
    }

    return true;
  }

  /// Stops [track], or only its clones when its media track was handed over
  /// to the next session.
  Future<void> _stopLocalTrack(RtcLocalTrack track) async {
    final handedOver = _handedOverMediaTracks.remove(track.trackId);
    if (identical(handedOver, track.mediaTrack)) {
      await track.stopClones();
    } else {
      await track.stop();
    }
  }

  /// Gives the live local tracks to the session that replaces this one, so
  /// the camera, microphone and screen share are not opened again.
  ///
  /// Each returned track carries the local prefix and no clones, ready to be
  /// published by the next session. This publisher keeps sending through its
  /// own clones until it is disposed, and then stops only those. Muted tracks
  /// stay here and are stopped on dispose. A second call returns nothing.
  List<RtcLocalTrack> handOverLocalTracks() {
    final handedOver = <RtcLocalTrack>[];
    for (final MapEntry(key: trackId, value: track) in tracks.entries) {
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

  /// Whether a sender of [trackType] has an enabled track.
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
        _addClone(item.track.trackId, mediaTrackClone);
      } else {
        await mediaTrackClone.stop();
      }
    }

    await _removeDroppedPublishOptions(publishOptions);
  }

  /// Records [clone] as a clone of the local track of [trackId], if it is
  /// still held, so it is stopped with it.
  void _addClone(String trackId, rtc.MediaStreamTrack clone) {
    final localTrack = tracks[trackId];
    if (localTrack == null) return;

    tracks[trackId] = localTrack.copyWith(
      clonedTracks: [...localTrack.clonedTracks, clone],
    );
  }

  /// Stops and forgets the transceivers whose publish option is not in
  /// [publishOptions].
  Future<void> _removeDroppedPublishOptions(
    List<SfuPublishOptions> publishOptions,
  ) async {
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

  List<RtcLocalTrack> getPublisherTracks() {
    return [...tracks.values];
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
    final nativePc = pc?.pc;
    if (nativePc == null) return const [];

    try {
      return await nativePc.getTransceivers();
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
    final nativePc = pc?.pc;
    if (nativePc == null) return null;

    try {
      return (await nativePc.getLocalDescription())?.sdp;
    } catch (e, stk) {
      _logger.w(() => '[localSdp] failed: $e\n$stk');
      return null;
    }
  }

  /// The tracks to announce in `SetPublisher`, or null when the mid of at least
  /// one sending transceiver that is part of the offer could not be resolved.
  ///
  /// All-or-nothing on purpose: announcing a subset commits an offer whose
  /// omitted m-lines keep sending media the SFU cannot map, and the SFU may
  /// read a missing entry as an unpublish of a track that was working. A null tells
  /// the caller to roll the offer back and retry instead. An empty list is a
  /// different answer — nothing is sending, which is a legitimate no-op.
  ///
  /// A transceiver whose track is absent from the offer entirely (a publish
  /// that landed while this negotiation was preparing) is skipped, not failed:
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
  /// than reporting what we do know, so unresolved tracks are dropped. With
  /// the publisher gone the mid usually comes from
  /// [TransceiverCache.negotiatedMid], i.e. the last announce the SFU
  /// acknowledged.
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
      audioSettings: _audioSettings(),
      dimensionOf: _captureDimensionResolver.resolve,
      heldTrack: tracks[transceiverCache.track.trackId],
      onMidUnresolved: (data) {
        pc?.tracer.trace(TraceTag.trackMidUnresolved, data);
      },
    );
  }

  /// Publishes [track], keeping the `stopTrackOnMute` it carries.
  Future<Result<RtcLocalTrack>> publishTrack(RtcLocalTrack track) async {
    if (track is RtcLocalAudioTrack) {
      return publishAudioTrack(
        track: track,
        stopTrackOnMute: track.stopTrackOnMute,
      );
    }
    if (track is RtcLocalVideoTrack) {
      return publishVideoTrack(
        track: track,
        stopTrackOnMute: track.stopTrackOnMute,
      );
    }

    return Result.failure('Unsupported track type: ${track.runtimeType}');
  }

  /// Drops [registered] and stops [acquired], so a failed publish leaves no
  /// track behind.
  ///
  /// [acquired] is the same track carrying whatever clones the publish managed
  /// to make.
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

  /// Publishes a microphone or screen share audio track.
  Future<Result<RtcLocalAudioTrack>> publishAudioTrack({
    required RtcLocalAudioTrack track,
    bool stopTrackOnMute = true,
  }) async {
    final result = await _publish(
      track.copyWith(stopTrackOnMute: stopTrackOnMute),
      tag: '[publishAudioTrack]',
      trackPublishOptions: () => RtcTrackPublishOptions(
        audioBitrateProfile: _audioBitrateProfile(),
      ),
      beforeSend: _liftAdmMute,
    );
    // Republishing restarts capture, which drops the ADM mute. No-op when the
    // ADM already matches the track being published.
    if (result.isSuccess) await reconcileAdmMute();

    return result.map((it) => it as RtcLocalAudioTrack);
  }

  /// Publishes a camera or screen share track, announced at the size it is
  /// captured at.
  Future<Result<RtcLocalVideoTrack>> publishVideoTrack({
    required RtcLocalVideoTrack track,
    bool stopTrackOnMute = true,
  }) async {
    // Every clone carries the resolved size: on Android a clone has no
    // settings, so it could not work out the capture size itself.
    final result = await _publish(
      track.copyWith(
        videoDimension: _captureDimensionResolver.resolve(track),
        stopTrackOnMute: stopTrackOnMute,
      ),
      tag: '[publishVideoTrack]',
    );

    return result.map((it) => it as RtcLocalVideoTrack);
  }

  /// Lifts an ADM mute left over from an earlier track, so a new live audio
  /// track is not muted at the device. The ADM mute outlives sessions: it
  /// belongs to the call's factory.
  Future<void> _liftAdmMute(RtcLocalTrack track) async {
    if (_admMute.isSupported(track) && track.mediaTrack.enabled) {
      await _admMute.setMuted(false);
    }
  }

  /// Publishes [track] on every publish option of its type and keeps it.
  ///
  /// A track with the local prefix gets the publisher id. A track type
  /// without a publish option fails, and so does a publish that cannot send
  /// on one of them or that is still running when disposing starts: each
  /// stops the track and keeps nothing.
  Future<Result<RtcLocalTrack>> _publish(
    RtcLocalTrack track, {
    required String tag,
    RtcTrackPublishOptions Function()? trackPublishOptions,
    Future<void> Function(RtcLocalTrack track)? beforeSend,
  }) async {
    final registered = track.trackIdPrefix == kLocalTrackIdPrefix
        ? track.copyWith(trackIdPrefix: publisherId)
        : track;

    // Added early so the `onRenegotiationNeeded` handler of the peer
    // connection can see it.
    _logger.i(() => '$tag track: $registered');
    tracks[registered.trackId] = registered;

    if (!publishOptions.any((o) => o.trackType == registered.trackType)) {
      final message =
          'No publish options found for track type: ${registered.trackType}';
      _logger.w(() => '$tag $message');
      await _discardFailedPublish(registered: registered, acquired: registered);
      return failureWithError(message);
    }

    final Result<RtcLocalTrack> sent;
    try {
      await beforeSend?.call(registered);
      sent = await _sendClones(
        registered,
        tag: tag,
        trackPublishOptions: trackPublishOptions,
      );
    } catch (e, stk) {
      _logger.e(() => '$tag failed: $e');
      await _discardFailedPublish(registered: registered, acquired: registered);
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
    if (sent is! Success<RtcLocalTrack>) return sent;
    final published = sent.data;

    if (_isDisposing) {
      _logger.w(
        () => '$tag disposed mid-publish; discarding ${published.trackId}',
      );
      await _discardFailedPublish(registered: registered, acquired: published);
      return failureWithError('RtcPublisher was disposed while publishing');
    }

    onLocalTrackPublished?.call(published);
    tracks[published.trackId] = published;

    return Result.success(published);
  }

  /// Sends a clone of [registered] on the transceiver of every publish option
  /// of its type, and returns it carrying those clones.
  ///
  /// Each transceiver gets a clone of its own, so each has a unique track id
  /// in the SDP. On a failure the clones made so far and the track are
  /// stopped and the registration is dropped.
  Future<Result<RtcLocalTrack>> _sendClones(
    RtcLocalTrack registered, {
    required String tag,
    RtcTrackPublishOptions Function()? trackPublishOptions,
  }) async {
    var published = registered;
    var needsRenegotiation = false;

    for (final option in publishOptions) {
      if (option.trackType != registered.trackType) continue;

      rtc.MediaStreamTrack? clone;
      Result<bool> sent;
      try {
        clone = await registered.mediaTrack.clone();
        sent = await _sendOnOption(
          option,
          registered.copyWith(mediaTrack: clone),
          tag: tag,
          trackPublishOptions: trackPublishOptions,
        );
      } catch (e, stk) {
        sent = Result.failure(StreamVideoExceptions.compose(e, stk), stk);
      }

      if (sent is! Success<bool>) {
        await clone?.stop();
        await _discardFailedPublish(
          registered: registered,
          acquired: published,
        );
        return sent as Failure;
      }

      needsRenegotiation |= sent.data;
      published = published.copyWith(
        clonedTracks: [...published.clonedTracks, clone!],
      );
    }

    if (needsRenegotiation) _forceRenegotiation(tag);

    return Result.success(published);
  }

  /// Sends [track] on the transceiver of [option]: a new one when it has
  /// none, otherwise the cached one in place of its previous track.
  ///
  /// Returns whether a renegotiation has to be forced for a reused sender,
  /// or the failure to create a new one.
  ///
  /// [trackPublishOptions] is read once no other publish holds the key. Without
  /// it a new transceiver gets the defaults, and a reused video sender keeps
  /// the options it has.
  Future<Result<bool>> _sendOnOption(
    SfuPublishOptions option,
    RtcLocalTrack track, {
    required String tag,
    RtcTrackPublishOptions Function()? trackPublishOptions,
  }) async {
    // Another publish may have claimed this key and still be waiting on the
    // platform. Let it settle, then re-read: whoever claimed first creates
    // the sender, everyone else reuses it through `replaceTrack` below.
    //
    // The re-read below must follow the last check with no await between
    // them, so this loop stays in this function.
    var pending = _pendingTransceivers[option.transceiverKey];
    while (pending != null) {
      await pending;
      pending = _pendingTransceivers[option.transceiverKey];
    }

    final options = trackPublishOptions?.call();
    final cachedBundle = transceiversManager.get(option);
    if (cachedBundle != null) {
      final unannounced = await _reuseTransceiver(
        cachedBundle,
        track,
        tag: tag,
        trackPublishOptions: options,
      );
      return Result.success(unannounced);
    }

    final transceiverResult = await _addTransceiver(
      track,
      option,
      options ?? const RtcTrackPublishOptions(),
    );
    if (transceiverResult is Failure) return transceiverResult;

    _logger.v(() => '$tag new transceiver: $transceiverResult');
    return const Result.success(false);
  }

  /// Sends [track] on [cached]'s transceiver in place of its previous track,
  /// which is stopped, and returns whether the SFU may not know about that
  /// sender, so a renegotiation has to be forced.
  ///
  /// Reusing a transceiver via replaceTrack does not fire
  /// onRenegotiationNeeded. If the sender's last negotiation never reached
  /// the SFU, the SFU does not know about it yet. The same holds for a sender
  /// that was detached: an announce made meanwhile left it out, so the SFU
  /// may have dropped it.
  Future<bool> _reuseTransceiver(
    TransceiverCache cached,
    RtcLocalTrack track, {
    required String tag,
    RtcTrackPublishOptions? trackPublishOptions,
  }) async {
    final transceiver = cached.transceiver;
    final previousTrack = transceiver.sender.track;
    await _updateTransceiver(
      transceiver,
      track,
      track.trackType,
      trackPublishOptions: trackPublishOptions,
    );
    await previousTrack?.stop();

    transceiversManager.update(
      cached.publishOption,
      track: track,
      trackPublishOptions: trackPublishOptions,
    );

    _logger.v(() => '$tag cached transceiver: $transceiver');

    return !cached.negotiated || previousTrack == null;
  }

  /// Explicitly triggers a publisher renegotiation.
  void _forceRenegotiation(String tag) {
    final pub = pc;
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
    if (pc == null) {
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
    final manager = _e2eeManager;
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
      transceiverResult = await pc!.addAudioTransceiver(
        track: track.mediaTrack,
        encodings: audioEncodings,
      );
    } else if (track is RtcLocalVideoTrack) {
      final captureDimension = _captureDimensionResolver.resolve(track);
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

      transceiverResult = await pc!.addVideoTransceiver(
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
    // A recapture in flight would replace the capture this mute applies to.
    await _settleRecapture(trackId);

    final originalTrack = tracks[trackId];

    if (originalTrack == null) {
      _logger.w(() => 'muteTrack: track not found');
      return failureWithError('Track not found');
    }

    // If [stopTrackOnMute] is true or unset, the track is stopped and released
    // (default). If false, the track stays alive and is muted at the device
    // level (iOS/macOS only).
    final track = originalTrack.copyWith(stopTrackOnMute: stopTrackOnMute);
    tracks[trackId] = track;

    final useAdmLevelMute =
        !track.stopTrackOnMute && _admMute.isSupported(track);

    track.disable();
    if (useAdmLevelMute) {
      await _admMute.setMuted(true);
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
    await _settleRecapture(trackId);

    final track = tracks[trackId];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return failureWithError('Track not found');
    }

    // Lift any ADM-level mute on iOS/macOS. Deliberately not gated on
    // [stopTrackOnMute]: a soft mute (ADM muted) followed by a hard mute
    // leaves the ADM muted, and the recreate path below neither clears it nor
    // goes through publishAudioTrack's reconcile — which would leave a live,
    // published track with capture silenced inside the ADM.
    if (_admMute.isSupported(track)) {
      await _admMute.setMuted(false);
    }

    // A soft-muted track was never released, but it is still capturing with
    // the constraints it was created with — enabling it again would leave it
    // on the stale ones and skip the publish-options update below. So it is
    // recreated too whenever the default audio constraints moved on since.
    //
    // A track that is still enabled was never muted — joining with a track
    // from the lobby unmutes it straight after publishing. Recreating it would
    // stop the camera or microphone and acquire it again for nothing, so only
    // stale constraints justify it.
    final wasReleased = track.stopTrackOnMute && !track.mediaTrack.enabled;
    if (wasReleased || _hasStaleAudioConstraints(track)) {
      final recreated = await recapture(
        trackId,
        tag: '[unmuteTrack]',
        constraintsFor: (current) => current.trackType == SfuTrackType.audio
            ? _defaultAudioConstraints()
            : null,
      );
      if (recreated is! Success<RtcLocalTrack>) return recreated;

      onLocalTrackMuted?.call(recreated.data, false);

      _renegotiateIfUnacknowledged(trackId, '[unmuteTrack]');
      return recreated;
    }

    // Otherwise simply enable it again
    track.enable();
    onLocalTrackMuted?.call(track, false);

    _renegotiateIfUnacknowledged(trackId, '[unmuteTrack]');
    return Result.success(track);
  }

  /// Whether [track] captures with audio constraints that no longer match
  /// the default audio constraints.
  bool _hasStaleAudioConstraints(RtcLocalTrack track) {
    if (track is! RtcLocalAudioTrack) return false;

    final current = track.mediaConstraints;
    final next = _defaultAudioConstraints();

    return current.noiseSuppression != next.noiseSuppression ||
        current.echoCancellation != next.echoCancellation ||
        current.autoGainControl != next.autoGainControl ||
        current.highPassFilter != next.highPassFilter ||
        current.typingNoiseDetection != next.typingNoiseDetection ||
        current.channelCount != next.channelCount;
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

    final recaptured = await recapture(
      track.trackId,
      tag: '[setTrackFacingMode]',
      constraintsFor: (current) => (current as RtcLocalCameraTrack)
          .mediaConstraints
          .copyWith(facingMode: facingMode),
    );
    return recaptured.map((it) => it as RtcLocalCameraTrack);
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

    final recaptured = await recapture(
      track.trackId,
      tag: '[setCameraVideoParameters]',
      constraintsFor: (current) {
        final constraints = (current as RtcLocalCameraTrack).mediaConstraints;
        return constraints.copyWith(
          params: constraints.params.copyWith(dimension: params.dimension),
        );
      },
    );
    return recaptured.map((it) => it as RtcLocalCameraTrack);
  }

  /// Captures the camera from [device] instead, on the senders that carry
  /// it. Does nothing when [device] is already the one in use.
  Future<Result<RtcLocalCameraTrack>> setVideoInputDevice(
    RtcMediaDevice device,
  ) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.w(() => '[setVideoInputDevice] rejected (track is null)');
      return failureWithError('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setVideoInputDevice] rejected (track is not camera)');
      return failureWithError('Track is not camera');
    }

    if (track.mediaConstraints.deviceId == device.id) {
      _logger.i(() => '[setVideoInputDevice] already selected: $device');
      return Result.success(track);
    }

    final recaptured = await recapture(
      track.trackId,
      tag: '[setVideoInputDevice]',
      constraintsFor: (current) => (current as RtcLocalCameraTrack)
          .mediaConstraints
          .copyWith(deviceId: device.id),
    );
    if (recaptured is! Success<RtcLocalTrack>) {
      return recaptured.map((it) => it as RtcLocalCameraTrack);
    }

    // Nothing is awaited since the recapture kept it, so it is still the held
    // track.
    final updated = (recaptured.data as RtcLocalCameraTrack).withFacingModeOf(
      device,
      fallback: track.mediaConstraints.facingMode,
    );
    tracks[updated.trackId] = updated;
    return Result.success(updated);
  }

  /// Runs [change] on the local track of [trackId] once no recapture of it
  /// is running, and keeps what it returns in place of that track.
  ///
  /// A track unpublished, or published again, meanwhile is not overwritten:
  /// a capture of its own that [change] made is stopped, and this fails. So
  /// does a [change] that throws.
  Future<Result<RtcLocalTrack>> updateHeldTrack(
    String trackId,
    Future<RtcLocalTrack> Function(RtcLocalTrack current) change, {
    required String tag,
  }) {
    return _oneRecaptureAtATime(trackId, () async {
      final current = tracks[trackId];
      if (current == null) return failureWithError('Track not found');

      try {
        return await _keepIfStillHeld(current, await change(current), tag);
      } catch (e, stk) {
        _logger.e(() => '$tag failed for $trackId: $e');
        return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
      }
    });
  }

  /// Captures the local track of [trackId] again, with the constraints
  /// [constraintsFor] gives for the track held when it starts (its own when
  /// that is null), sends the new capture on every sender that carried the
  /// track, and keeps it.
  ///
  /// Recaptures of a track run one at a time, each from the previous one's
  /// result. When [skipIf] holds for the track held once this recapture's
  /// turn starts, it is kept as it is. The new capture goes on the senders
  /// only while the track is still held. A track unpublished, or published again, meanwhile is not
  /// overwritten: the new capture is stopped, and this fails. So does a
  /// capture that fails; the old capture is stopped either way.
  Future<Result<RtcLocalTrack>> recapture(
    String trackId, {
    required String tag,
    MediaConstraints? Function(RtcLocalTrack current)? constraintsFor,
    bool Function(RtcLocalTrack current)? skipIf,
  }) {
    return _oneRecaptureAtATime(trackId, () async {
      final current = tracks[trackId];
      if (current == null) return failureWithError('Track not found');
      if (skipIf?.call(current) ?? false) return Result.success(current);

      RtcLocalTrack? captured;
      try {
        var sending = captured = await current.recapture(
          mediaConstraints: constraintsFor?.call(current),
        );

        // Sender by sender, each only while the track is still held, so a
        // track published again meanwhile keeps its senders.
        final clones = <rtc.MediaStreamTrack>[];
        for (final transceiver in transceiversManager.getTransceiversForTrack(
          trackId,
        )) {
          if (!_isHeld(current)) break;
          final sent = await sending.sendOn([transceiver]);
          clones.addAll(sent.clonedTracks);
          captured = sending = sending.copyWith(clonedTracks: [...clones]);
        }

        if (_isHeld(current) && sending is RtcLocalAudioTrack) {
          await _updateAudioPublishOptions(
            sending.trackType,
            RtcTrackPublishOptions(audioBitrateProfile: _audioBitrateProfile()),
          );
        }

        return await _keepIfStillHeld(current, sending, tag);
      } catch (e, stk) {
        _logger.e(() => '$tag failed for $trackId: $e');
        await captured?.stop();
        return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
      }
    });
  }

  /// Keeps [updated] in place of [current] when [current] is still the held
  /// track, with the `stopTrackOnMute` held now. Otherwise stops [updated]'s
  /// own capture, if it made one, and fails.
  Future<Result<RtcLocalTrack>> _keepIfStillHeld(
    RtcLocalTrack current,
    RtcLocalTrack updated,
    String tag,
  ) async {
    final held = tracks[current.trackId];
    if (held == null || !identical(held.mediaTrack, current.mediaTrack)) {
      _logger.w(() => '$tag ${current.trackId} is no longer held');
      if (!identical(updated.mediaTrack, current.mediaTrack)) {
        await updated.stop();
      }
      return failureWithError('Track was unpublished while it was changed');
    }

    final kept = updated.copyWith(stopTrackOnMute: held.stopTrackOnMute);
    tracks[kept.trackId] = kept;
    return Result.success(kept);
  }

  /// Whether [track]'s capture is still the one held under its id. A copy
  /// made by a mute counts; a track published again under the same id does
  /// not.
  bool _isHeld(RtcLocalTrack track) {
    return identical(tracks[track.trackId]?.mediaTrack, track.mediaTrack);
  }

  /// Runs [run] once no recapture of [trackId] is running, as the one that
  /// is.
  Future<R> _oneRecaptureAtATime<R>(
    String trackId,
    Future<R> Function() run,
  ) async {
    // The claim below must follow the last check with no await between them.
    var running = _recaptures[trackId];
    while (running != null) {
      await running.future;
      running = _recaptures[trackId];
    }

    final done = Completer<void>();
    _recaptures[trackId] = done;
    try {
      return await run();
    } finally {
      _recaptures.remove(trackId);
      done.complete();
    }
  }

  /// Waits until no recapture of [trackId] is running.
  Future<void> _settleRecapture(String trackId) async {
    var running = _recaptures[trackId];
    while (running != null) {
      await running.future;
      running = _recaptures[trackId];
    }
  }

  /// Takes the track of [trackId] off every sender carrying it.
  ///
  /// For a stopped screen share. Muting leaves the ended track on the sender,
  /// and every announce reports a sender that has a track, so a reconnect or
  /// a migration would tell the SFU the share is still published. Sharing
  /// again always publishes a new track, which puts one back.
  Future<void> detachFromSenders(String trackId) async {
    for (final transceiver in transceiversManager.getTransceiversForTrack(
      trackId,
    )) {
      try {
        await transceiver.sender.replaceTrack(null);
      } catch (e, stk) {
        _logger.w(() => '[detachFromSenders] failed for $trackId: $e\n$stk');
      }
    }
  }

  /// Applies a remote ICE [candidate] to the publisher peer connection, or
  /// returns null when this session does not publish.
  Future<Result<AddIceCandidateResult>>? addIceCandidate(
    rtc.RTCIceCandidate candidate,
  ) {
    return pc?.addIceCandidate(candidate);
  }

  /// Makes a publish still in flight discard its track rather than keep it.
  ///
  /// [dispose] does this too; calling it earlier covers the part of a
  /// session's teardown that runs before the publisher's.
  void beginDispose() {
    _isDisposing = true;
  }

  /// Stops every local track, clears [onLocalTrackMuted] and
  /// [onLocalTrackPublished], and closes the publisher peer connection, if
  /// any. A publish still in flight discards its track.
  ///
  /// The tracks stay on their senders until the peer connection closes.
  Future<void> dispose() async {
    beginDispose();

    final localTracks = [...tracks.values];
    tracks.clear();
    await Future.wait(
      localTracks.map(
        (track) =>
            _stopLocalTrack(track).catchError((Object e, StackTrace stk) {
              _logger.e(
                () => '[dispose] stop failed for ${track.trackId}: $e\n$stk',
              );
            }),
      ),
    );

    onLocalTrackMuted = null;
    onLocalTrackPublished = null;

    await pc?.dispose();
  }
}
