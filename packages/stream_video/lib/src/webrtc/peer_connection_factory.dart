import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../protobuf/video/sfu/models/models.pb.dart';
import '../../stream_video.dart';
import '../call/session/call_session_config.dart';
import '../call/stats/trace_tag.dart';
import '../call/stats/tracer.dart';
import '../sfu/sfu_client.dart';
import 'sdp/editor/sdp_editor.dart';
import 'traced_peer_connection.dart';

/// Owns the per-call native peer connection factory.
///
/// The factory is built lazily on first [makePeerConnection] call and
/// disposed via [dispose]. Callers must dispose the factory once every PC
/// it created has been disposed.
class StreamPeerConnectionFactory {
  StreamPeerConnectionFactory({
    required this.callCid,
    this.audioConfigurationPolicy,
  });

  final _logger = taggedLogger(tag: 'SV:PeerConnectionFactory');

  final StreamCallCid callCid;

  /// Audio policy applied to the per-call factory build. Falls back to
  /// [BroadcasterAudioPolicy] when null.
  final AudioConfigurationPolicy? audioConfigurationPolicy;

  /// The audio policy this factory is built with, fixed for its lifetime.
  ///
  /// Falls back to [BroadcasterAudioPolicy] when [audioConfigurationPolicy]
  /// is null.
  AudioConfigurationPolicy get resolvedAudioConfigurationPolicy =>
      audioConfigurationPolicy ?? const BroadcasterAudioPolicy();

  rtc.NativePeerConnectionFactory? _nativeFactory;
  Future<rtc.NativePeerConnectionFactory?>? _nativeFactoryFuture;

  /// Whether the platform exposes the per-call native factory APIs.
  /// Web / desktop fall through to the global webrtc entrypoints because
  /// per-call factories aren't a concept there.
  bool get _isPerCallFactorySupported =>
      CurrentPlatform.isAndroid ||
      CurrentPlatform.isIos ||
      CurrentPlatform.isMacOS;

  /// The per-call native factory, lazily built on first use. Returns null on
  /// web (no per-call factory concept) so callers can fall back to the
  /// global webrtc entrypoints.
  Future<rtc.NativePeerConnectionFactory?> ensureNativeFactory() {
    if (!_isPerCallFactorySupported) {
      return Future.value();
    }
    if (_nativeFactory != null) {
      return Future.value(_nativeFactory);
    }
    return _nativeFactoryFuture ??= _buildNativeFactory();
  }

  Future<rtc.NativePeerConnectionFactory?> _buildNativeFactory() async {
    try {
      final policy = resolvedAudioConfigurationPolicy;
      final options = <String, dynamic>{
        'bypassVoiceProcessing': policy.bypassVoiceProcessing,
      };

      if (CurrentPlatform.isAndroid) {
        options['androidAudioConfiguration'] = policy
            .getAndroidConfiguration()
            .toMap();
      }

      if (CurrentPlatform.isIos || CurrentPlatform.isMacOS) {
        // Applied when the factory is built and again when its audio resumes.
        // A policy that defaults to the speaker starts on the loudspeaker. On
        // iOS, `Call.resumeAudio` then re-applies the configuration and output
        // applied since.
        options['appleAudioConfiguration'] = policy
            .getAppleConfiguration(defaultToSpeaker: policy.defaultsToSpeaker)
            .toMap();
      }

      _nativeFactory = await rtc.NativePeerConnectionFactory.create(
        options: options,
      );

      _logger.i(
        () =>
            '[ensureNativeFactory] built per-call factory '
            'id: ${_nativeFactory!.factoryId}, policy: ${policy.runtimeType}',
      );
      return _nativeFactory;
    } finally {
      // Drop the in-flight reference once the build resolves so a future
      // rebuild after dispose works as expected.
      _nativeFactoryFuture = null;
    }
  }

  /// Synchronous accessor returning the cached factory if already built.
  /// Returns null if [ensureNativeFactory] has not yet been awaited or on
  /// platforms without per-call factory support.
  rtc.NativePeerConnectionFactory? get nativeFactory => _nativeFactory;

  /// Suspends this factory's audio capture + playback so another factory
  /// can take exclusive ownership of mic/speaker resources. Used when this
  /// call coexists with a second active call (multiple calls).
  Future<void> suspendAudio() async {
    final native = _nativeFactory;
    if (native == null) {
      _logger.w(() => '[suspendAudio] no native factory to suspend');
      return;
    }
    _logger.i(() => '[suspendAudio] factoryId: ${native.factoryId}');
    await native.suspendAudio();
  }

  /// Resumes a previously [suspendAudio]'d factory.
  Future<void> resumeAudio() async {
    final native = _nativeFactory;
    if (native == null) {
      _logger.w(() => '[resumeAudio] no native factory to resume');
      return;
    }
    _logger.i(() => '[resumeAudio] factoryId: ${native.factoryId}');
    await native.resumeAudio();
  }

  /// Whether ADM-level microphone mute is available on this platform.
  ///
  /// An instance member rather than a static so tests can exercise the
  /// ADM-level mute branch on any host.
  bool get isAppleAdmMicrophoneMuteSupported =>
      rtc.NativePeerConnectionFactory.isAdmMicrophoneMuteSupported;

  /// Mutes / unmutes microphone capture at the audio-device-module level
  /// while the audio engine keeps running, arming Apple's muted-talker
  /// detection, which powers speaking-while-muted events.
  ///
  /// No-op unless [isAppleAdmMicrophoneMuteSupported].
  Future<void> setAppleAdmMicrophoneMuted(bool muted) async {
    if (!isAppleAdmMicrophoneMuteSupported) {
      _logger.w(
        () => '[setAppleAdmMicrophoneMuted] unsupported platform, skipping',
      );
      return;
    }

    final native = _nativeFactory;
    if (native == null) {
      _logger.w(() => '[setAppleAdmMicrophoneMuted] no native factory');
      return;
    }
    _logger.i(
      () =>
          '[setAppleAdmMicrophoneMuted] muted: $muted, '
          'factoryId: ${native.factoryId}',
    );
    await native.setMicrophoneMuted(muted);
  }

  /// Reads back the ADM microphone mute state, or `null` when it cannot be
  /// asked: no native factory, or a platform without ADM-level mute.
  Future<bool?> isAppleAdmMicrophoneMuted() async {
    if (!isAppleAdmMicrophoneMuteSupported) {
      _logger.w(
        () => '[isAppleAdmMicrophoneMuted] unsupported platform, skipping',
      );
      return null;
    }

    final native = _nativeFactory;
    if (native == null) {
      _logger.w(() => '[isAppleAdmMicrophoneMuted] no native factory');
      return null;
    }

    return native.isMicrophoneMuted();
  }

  Future<TracedStreamPeerConnection> makeSubscriber({
    required String sessionId,
    required SdpEditor sdpEditor,
    required SfuClient sfuClient,
    required RTCConfiguration configuration,
    required ClientDetails? clientDetails,
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  }) async {
    return makePeerConnection(
      sessionId: sessionId,
      sdpEditor: sdpEditor,
      sfuClient: sfuClient,
      type: StreamPeerType.subscriber,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
      statsOptions: statsOptions,
      callSessionConfig: callSessionConfig,
    );
  }

  Future<TracedStreamPeerConnection> makePublisher({
    required String sessionId,
    required SdpEditor sdpEditor,
    required SfuClient sfuClient,
    required RTCConfiguration configuration,
    required ClientDetails? clientDetails,
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  }) async {
    return makePeerConnection(
      sessionId: sessionId,
      sdpEditor: sdpEditor,
      sfuClient: sfuClient,
      type: StreamPeerType.publisher,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
      statsOptions: statsOptions,
      callSessionConfig: callSessionConfig,
    );
  }

  Future<TracedStreamPeerConnection> makePeerConnection({
    required String sessionId,
    required SdpEditor sdpEditor,
    required SfuClient sfuClient,
    required StreamPeerType type,
    required RTCConfiguration configuration,
    required ClientDetails? clientDetails,
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  }) async {
    _logger.i(
      () =>
          '[createPeerConnection] #$type; configuration: '
          '${configuration.toMap()}, mediaConstraints: $mediaConstraints',
    );

    final nativeFactory = await ensureNativeFactory();
    final pc = nativeFactory != null
        ? await nativeFactory.createPeerConnection(
            configuration.toMap(),
            mediaConstraints,
          )
        : await rtc.createPeerConnection(
            configuration.toMap(),
            mediaConstraints,
          );

    final tracer = Tracer(
      "$tracerIdPrefix-${type == StreamPeerType.publisher ? 'pub' : 'sub'}",
    );

    tracer.setEnabled(statsOptions?.enableRtcStats ?? false);

    tracer.trace(
      TraceTag.create,
      configuration.toMap()..addAll(
        {
          'url': callSessionConfig?.sfuName,
        },
      ),
    );

    return TracedStreamPeerConnection(
      sfuClient: sfuClient,
      sessionId: sessionId,
      callCid: callCid,
      type: type,
      pc: pc,
      sdpEditor: sdpEditor,
      tracer: tracer,
    );
  }

  final _genericSdpByDirection = <rtc.TransceiverDirection, Future<String>>{};

  /// A generic offer SDP for [direction], made on a throwaway peer connection
  /// of this factory. Cached per direction, since the factory's capabilities
  /// don't change; a failed or empty result is not cached.
  Future<String> getGenericSdp(rtc.TransceiverDirection direction) {
    return _genericSdpByDirection[direction] ??= _createGenericSdp(direction)
        .then((sdp) {
          if (sdp.isEmpty) _genericSdpByDirection.remove(direction);
          return sdp;
        })
        .catchError((Object e, StackTrace stk) {
          _genericSdpByDirection.remove(direction);
          return Future<String>.error(e, stk);
        });
  }

  Future<String> _createGenericSdp(rtc.TransceiverDirection direction) async {
    final nativeFactory = await ensureNativeFactory();
    final tempPC = nativeFactory != null
        ? await nativeFactory.createPeerConnection({}, {})
        : await rtc.createPeerConnection({});

    final String? sdp;
    try {
      await tempPC.addTransceiver(
        kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: rtc.RTCRtpTransceiverInit(direction: direction),
      );

      await tempPC.addTransceiver(
        kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: rtc.RTCRtpTransceiverInit(direction: direction),
      );

      final offer = await tempPC.createOffer();
      sdp = offer.sdp;
    } finally {
      // Logged, not thrown: a failed dispose must neither hide why the offer
      // failed nor throw away an offer that was made.
      try {
        await tempPC.dispose();
      } catch (e, stk) {
        _logger.w(
          () => '[getGenericSdp] peer connection dispose failed: $e\n$stk',
        );
      }
    }

    if (sdp == null) {
      _logger.e(() => '[getGenericSdp] sdp is null');
      return '';
    }

    return sdp;
  }

  /// Tears down the per-call factory. Must be called only after every PC the
  /// factory created has been disposed.
  Future<void> dispose() async {
    if (_nativeFactoryFuture != null) {
      try {
        await _nativeFactoryFuture;
      } catch (_) {}
    }
    if (_nativeFactory == null) {
      return;
    }
    final factory = _nativeFactory!;
    _nativeFactory = null;
    try {
      await factory.dispose();
      _logger.i(() => '[dispose] released factory id: ${factory.factoryId}');
    } catch (e, stk) {
      _logger.w(() => '[dispose] native factory dispose failed: $e\n$stk');
    }
  }
}
