import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video.dart';
import '../call/state/call_state_notifier.dart';
import '../errors/stream_video_exception_composer.dart';
import '../errors/track_missing_exception.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_video_sender.dart';
import '../telemetry/rtc_session_telemetry.dart';
import 'audio/adm_microphone_mute.dart';
import 'audio/audio_session.dart';
import 'audio/ios_audio_session.dart';
import 'e2ee/remote_track_decryptor.dart';
import 'media/capture_dimension.dart';
import 'media/local_track_acquirer.dart';
import 'model/rtc_tracks_info.dart';
import 'peer_connection.dart';
import 'peer_connection_factory.dart';
import 'publisher/rtc_publisher.dart';
import 'rtc_parser.dart';
import 'subscriber/rtc_subscriber.dart';
import 'traced_peer_connection.dart';
import 'transceiver_cache.dart';

export '../errors/track_missing_exception.dart';
export 'publisher/announced_tracks.dart' show resolveTrackMid;
export 'publisher/rtc_publisher.dart'
    show OnLocalTrackMuted, OnLocalTrackPublished;
export 'subscriber/rtc_subscriber.dart' show OnRemoteTrackReceived;

part 'rtc_manager_media.dart';

const _tag = 'SV:RtcManager';

/// The WebRTC side of one call session: a facade over its [RtcPublisher] and
/// [RtcSubscriber], plus the device and audio work around them.
///
/// One is made per `CallSession` by `RtcManagerFactory`, which hands it the
/// subscriber peer connection and, when the session publishes, the publisher
/// one. A rejoin or an SFU migration makes a new one;
/// [handOverLocalTracks] passes the live local tracks to it, so the devices
/// are not opened again.
///
/// - The publisher sends the local tracks, one transceiver per publish
///   option, encrypts its senders when the call is end-to-end encrypted,
///   mutes and unmutes the tracks, changes the camera's facing mode and
///   parameters, follows the SFU's publish options and publish quality, and
///   builds the tracks announced to the SFU.
/// - The subscriber answers the SFU's offers and keeps the remote tracks.
/// - This class acquires the camera, microphone and screen share and hands
///   them to the publisher, switches the camera and microphone, attaches
///   end-to-end decryption to remote tracks, selects the audio output, and
///   applies the audio session.
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
    required List<SfuPublishOptions> publishOptions,
    required this.stateManager,
    required this._host,
    required this.pcFactory,
    this.e2eeManager,
    this.sfuId,
    this.clientEventRetryCount = 0,
    this.captureDimensionResolver = const CaptureDimensionResolver(),
  }) {
    _publisher = RtcPublisher(
      pc: publisher,
      publisherId: publisherId,
      publishOptions: publishOptions,
      admMute: () => AdmMicrophoneMute.forFactory(pcFactory),
      captureDimensionResolver: captureDimensionResolver,
      audioBitrateProfile: () => stateManager.callState.audioBitrateProfile,
      audioSettings: () => stateManager.callState.settings.audio,
      defaultAudioConstraints: () => _trackAcquirer.defaultAudioConstraints,
      e2eeManager: e2eeManager,
    );
    _subscriber = RtcSubscriber(
      pc: subscriber,
      attachDecryptor: attachDecryptor,
      onTrackAdded: (track) => _telemetry?.onRemoteTrack(track),
    );
    _telemetry = _initTelemetry();
  }

  /// The client event reporting of this session, or `null` when it is off.
  RtcSessionTelemetry? _initTelemetry() {
    if (!_host.options.clientEventsReportingEnabled) return null;

    return RtcSessionTelemetry(
      reporter: _host.clientEventReporter,
      callCid: callCid,
      sfuId: sfuId,
      retryCount: clientEventRetryCount,
    )..attach(publisher: publisher, subscriber: subscriber);
  }

  final _logger = taggedLogger(tag: _tag);

  final String sessionId;
  final StreamCallCid callCid;
  final String? publisherId;
  final CallStateNotifier stateManager;
  final TracedStreamPeerConnection? publisher;
  final TracedStreamPeerConnection subscriber;

  late final RtcPublisher _publisher;

  /// The sending side of this session.
  @visibleForTesting
  RtcPublisher get rtcPublisher => _publisher;

  late final RtcSubscriber _subscriber;

  /// The receiving side of this session.
  @visibleForTesting
  RtcSubscriber get rtcSubscriber => _subscriber;

  final CallHost _host;
  final String? sfuId;
  final int clientEventRetryCount;

  /// Works out the size a local video track is encoded at.
  final CaptureDimensionResolver captureDimensionResolver;

  /// Client event reporting for this session, or `null` when it is off.
  late final RtcSessionTelemetry? _telemetry;

  final StreamPeerConnectionFactory pcFactory;

  /// End-to-end encryption for this session, or `null` when the call is
  /// unencrypted.
  ///
  /// Set before the peer connections carry any media: local transceivers get
  /// an encryptor as they are added, remote receivers get a decryptor as
  /// tracks arrive.
  final rtc.EncryptionManager? e2eeManager;

  late final _remoteTrackDecryptor = RemoteTrackDecryptor(
    manager: e2eeManager,
    userIdForTrackPrefix: _userIdForTrackPrefix,
    receiverFor: (track) => _subscriber.receiverFor(track),
  );

  /// The transceiver of every publish option that has one.
  TransceiverManager get transceiversManager => _publisher.transceiversManager;

  /// Acquires local tracks. A session without a publisher acquires none.
  late final _trackAcquirer = LocalTrackAcquirer(
    pcFactory: pcFactory,
    publisherId: publisher == null ? null : publisherId,
  );

  /// The publish options from the SFU, one or more per track type.
  List<SfuPublishOptions> get publishOptions => _publisher.publishOptions;

  set publishOptions(List<SfuPublishOptions> value) {
    _publisher.publishOptions = value;
  }

  /// The local tracks by track id. The remote ones are kept by the
  /// subscriber.
  Map<String, RtcLocalTrack> get tracks => _publisher.tracks;

  /// The local tracks by track id, as an unmodifiable snapshot.
  Map<String, RtcLocalTrack> get localTracks => Map.unmodifiable(tracks);

  /// The remote tracks by track id, as an unmodifiable snapshot.
  Map<String, RtcRemoteTrack> get remoteTracks =>
      Map.unmodifiable(_subscriber.tracks);

  /// Marks the transceivers sending [announced] as acknowledged by the SFU.
  void markNegotiated(Iterable<RtcTrackInfo> announced) {
    _publisher.markNegotiated(announced);
  }

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

  /// {@macro OnLocalTrackMuted}
  OnLocalTrackMuted? get onLocalTrackMuted => _publisher.onLocalTrackMuted;

  set onLocalTrackMuted(OnLocalTrackMuted? callback) {
    _publisher.onLocalTrackMuted = callback;
  }

  /// {@macro OnLocalTrackPublished}
  OnLocalTrackPublished? get onLocalTrackPublished =>
      _publisher.onLocalTrackPublished;

  set onLocalTrackPublished(OnLocalTrackPublished? callback) {
    _publisher.onLocalTrackPublished = callback;
  }

  /// Called for every remote track the subscriber receives.
  OnRemoteTrackReceived? get onRemoteTrackReceived =>
      _subscriber.onRemoteTrackReceived;

  set onRemoteTrackReceived(OnRemoteTrackReceived? callback) {
    _subscriber.onRemoteTrackReceived = callback;
  }

  /// Feeds the subscriber's periodic WebRTC [stats] to first-frame telemetry
  void onSubscriberStats(List<RtcStats> stats) {
    _telemetry?.onSubscriberStats(stats);
  }

  /// The iOS broadcast share created but not started yet, and the
  /// subscription waiting for it to start.
  RtcLocalScreenShareTrack? _pendingBroadcastTrack;
  StreamSubscription<NativeWebRtcEvent>? _pendingBroadcastSubscription;

  /// Cancels a broadcast that was created but has not started, stopping its
  /// track.
  Future<void> _cancelPendingBroadcast() async {
    final track = _pendingBroadcastTrack;
    _pendingBroadcastTrack = null;

    await _pendingBroadcastSubscription?.cancel();
    _pendingBroadcastSubscription = null;
    await track?.stop();
  }

  /// Whether subscriber offers have to be compared for new audio sources.
  /// WebKit only: everywhere else the offers are neither kept nor parsed.
  /// Swappable so a test on the VM can take the WebKit path.
  @visibleForTesting
  bool Function() get needsRemoteAudioReattach =>
      _subscriber.needsRemoteAudioReattach;

  @visibleForTesting
  set needsRemoteAudioReattach(bool Function() value) {
    _subscriber.needsRemoteAudioReattach = value;
  }

  /// Re-attaches every remote audio element after a subscriber renegotiation
  /// brought in a new audio source. Swappable so a test can observe the
  /// trigger.
  @visibleForTesting
  Future<void> Function({required String reason}) get reattachRemoteAudio =>
      _subscriber.reattachRemoteAudio;

  @visibleForTesting
  set reattachRemoteAudio(
    Future<void> Function({required String reason}) value,
  ) {
    _subscriber.reattachRemoteAudio = value;
  }

  /// Applies the SFU's subscriber [offerSdp] and returns the answer, or null
  /// when either step failed.
  Future<String?> onSubscriberOffer(String offerSdp) {
    return _subscriber.onOffer(offerSdp);
  }

  Future<Result<None>> onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) async {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    final Result<AddIceCandidateResult>? result;
    if (peerType == StreamPeerType.publisher) {
      result = await _publisher.addIceCandidate(candidate);
      if (result == null) return failureWithError('no publisher created');
    } else if (peerType == StreamPeerType.subscriber) {
      result = await _subscriber.addIceCandidate(candidate);
    } else {
      return failureWithError('unexpected peerType: $peerType');
    }
    return result.map((_) => none);
  }

  /// Makes [constraints] the default for microphone tracks, and restarts the
  /// live ones so they capture with it.
  Future<void> changeDefaultAudioConstraints(
    AudioConstraints constraints,
  ) {
    _trackAcquirer.defaultAudioConstraints = constraints;
    return _publisher.restartLiveAudioTracks();
  }

  /// Stops the track / clones / media stream for [trackId]. For a local
  /// track, also calls `pc.removeTrack` on every sender that referenced it.
  Future<void> unpublishTrack({
    required String trackId,
  }) async {
    if (await _publisher.unpublishTrack(trackId: trackId)) return;

    // A remote track is only stopped: its receiver belongs to the
    // receive-only subscriber, so there is no sender to remove.
    if (await _subscriber.removeTrack(trackId)) return;

    _logger.w(() => '[unpublishTrack] rejected (track not found): $trackId');
  }

  /// Gives the live local tracks to the manager of the session that replaces
  /// this one, so the camera, microphone and screen share are not opened
  /// again.
  ///
  /// Each returned track carries the local prefix and no clones, ready to be
  /// published by the next manager. This manager keeps sending through its
  /// own clones until it is disposed, and then stops only those. Muted tracks
  /// stay here and are stopped on dispose. A second call returns nothing.
  List<RtcLocalTrack> handOverLocalTracks() => _publisher.handOverLocalTracks();

  /// Applies the SFU's new [publishOptions]: adds a transceiver for each new
  /// one of a track type being published, and removes the ones dropped.
  Future<void> onPublishOptionsChanged(
    List<SfuPublishOptions> publishOptions,
  ) {
    return _publisher.onPublishOptionsChanged(publishOptions);
  }

  /// Applies the layers the SFU asks [videoSender] to send.
  Future<void> onPublishQualityChanged(
    SfuVideoSender videoSender,
    String? codecInUse,
  ) {
    return _publisher.onPublishQualityChanged(videoSender, codecInUse);
  }

  /// The user id that owns the remote track under [trackIdPrefix].
  String? _userIdForTrackPrefix(String trackIdPrefix) {
    return stateManager.callState.callParticipants
        .firstWhereOrNull((it) => it.trackIdPrefix == trackIdPrefix)
        ?.userId;
  }

  /// Decrypts everything [track]'s receiver delivers, or queues the track
  /// until its participant is known.
  Future<void> attachDecryptor(RtcRemoteTrack track) =>
      _remoteTrackDecryptor.attach(track);

  /// Retries decryptors that were waiting on a participant.
  Future<void> flushPendingDecryptors() => _remoteTrackDecryptor.flush();

  /// Drops decryptors still waiting on a participant who has left.
  void discardPendingDecryptors(String trackIdPrefix) =>
      _remoteTrackDecryptor.discard(trackIdPrefix);

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    _publisher.beginDispose();

    await _cancelPendingBroadcast();

    final trackIds = [...tracks.keys, ..._subscriber.tracks.keys];
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

    _publisher.clearTracks();
    _subscriber.clearTracks();
    _remoteTrackDecryptor.clear();

    onLocalTrackMuted = null;
    onLocalTrackPublished = null;
    onRemoteTrackReceived = null;

    _telemetry?.dispose();

    await Future.wait([
      if (publisher != null)
        _publisher.dispose().catchError((
          Object e,
          StackTrace stk,
        ) {
          _logger.e(() => '[dispose] publisher.dispose failed: $e\n$stk');
        }),
      _subscriber.dispose().catchError((
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
    return tracks[trackId] ?? _subscriber.tracks[trackId];
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [
      ...[...tracks.values, ..._subscriber.tracks.values].where((track) {
        return track.trackIdPrefix == trackIdPrefix;
      }),
    ];
  }

  late final AudioSession _audioSession = AudioSession.forPlatform();

  /// Applies [policy]'s audio session configuration, asking for the
  /// loudspeaker as the built-in output when [speakerOn]. Does nothing on a
  /// platform without an audio session to configure.
  @internal
  Future<Result<None>> configureAudioSession({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  }) {
    return _audioSession.set(policy: policy, speakerOn: speakerOn);
  }

  /// Re-applies the configuration last applied with
  /// [configureAudioSession], if any.
  @internal
  Future<Result<None>> restoreAudioSession() {
    return _audioSession.restore();
  }

  /// Syncs the ADM mute state with the local audio track, to avoid mismatches
  /// after audio restarts or suspends. Idempotent: only updates when needed.
  ///
  /// No-op on platforms without ADM-level mute.
  @internal
  Future<void> reconcileAppleAdmMicrophoneMute() {
    return _publisher.reconcileAdmMute();
  }

  RtcLocalTrack? getPublisherTrackByType(SfuTrackType trackType) {
    return _publisher.getPublisherTrackByType(trackType);
  }

  /// True when the publisher has nothing to offer: no cached, in-flight or
  /// live transceivers.
  Future<bool> isPublisherEmpty() => _publisher.isPublisherEmpty();

  /// The tracks to announce in `SetPublisher`, or null when the mid of at least
  /// one sending transceiver that is part of the offer could not be resolved.
  Future<List<RtcTrackInfo>?> getAnnouncedTracks({String? sdp}) {
    return _publisher.getAnnouncedTracks(sdp: sdp);
  }

  /// The tracks to report in `ReconnectDetails`, leaving out the ones whose
  /// mid could not be resolved.
  Future<List<RtcTrackInfo>> getAnnouncedTracksForReconnect({String? sdp}) {
    return _publisher.getAnnouncedTracksForReconnect(sdp: sdp);
  }

  /// Removes all tracks from the publisher with the given [trackIdPrefix].
  Future<void> removeSubscriber(String trackIdPrefix) async {
    final tracks = getTracks(trackIdPrefix);
    for (final track in tracks) {
      await unpublishTrack(trackId: track.trackId);
    }
  }

  Future<Result<RtcLocalTrack>> publishTrack(RtcLocalTrack track) {
    return _publisher.publishTrack(track);
  }

  Future<Result<RtcLocalAudioTrack>> publishAudioTrack({
    required RtcLocalAudioTrack track,
    bool stopTrackOnMute = true,
  }) {
    return _publisher.publishAudioTrack(
      track: track,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<Result<RtcLocalVideoTrack>> publishVideoTrack({
    required RtcLocalVideoTrack track,
    bool stopTrackOnMute = true,
  }) {
    return _publisher.publishVideoTrack(
      track: track,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<Result<RtcLocalTrack>> muteTrack({
    required String trackId,
    bool? stopTrackOnMute,
  }) {
    return _publisher.muteTrack(
      trackId: trackId,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<Result<RtcLocalTrack>> unmuteTrack({required String trackId}) {
    return _publisher.unmuteTrack(trackId: trackId);
  }

  Future<Result<RtcLocalCameraTrack>> setTrackFacingMode({
    required FacingMode facingMode,
  }) {
    return _publisher.setTrackFacingMode(facingMode: facingMode);
  }

  Future<Result<RtcLocalCameraTrack>> setCameraVideoParameters({
    required RtcVideoParameters params,
  }) {
    return _publisher.setCameraVideoParameters(params: params);
  }
}
