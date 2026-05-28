import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../open_api/video/coordinator/api.dart';
import '../../protobuf/video/sfu/models/models.pb.dart';
import '../call/session/call_session_config.dart';
import '../call/stats/tracer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/audio_configuration_policy.dart';
import '../models/call_cid.dart';
import '../platform_detector/platform_detector.dart';
import '../sfu/sfu_client.dart';
import '../types/other.dart';
import 'peer_type.dart';
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
      final policy = audioConfigurationPolicy ?? const BroadcasterAudioPolicy();
      final options = <String, dynamic>{
        'bypassVoiceProcessing': policy.bypassVoiceProcessing,
      };

      if (CurrentPlatform.isAndroid) {
        options['androidAudioConfiguration'] = policy
            .getAndroidConfiguration()
            .toMap();
      }

      if (CurrentPlatform.isIos || CurrentPlatform.isMacOS) {
        options['appleAudioConfiguration'] = policy
            .getAppleConfiguration()
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
      'create',
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
