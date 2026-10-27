// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/ws/sfu_ws.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_manager_factory.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

class _MockSfuWebSocket extends Mock implements SfuWebSocket {}

class _MockRtcManagerFactory extends Mock implements RtcManagerFactory {}

class _MockStreamPeerConnectionFactory extends Mock
    implements StreamPeerConnectionFactory {}

class _MockNativePeerConnectionFactory extends Mock
    implements rtc.NativePeerConnectionFactory {}

class _MockRTCPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class _MockRTCRtpTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockRtcManager extends Mock implements RtcManager {}

/// A [CallSession] whose SFU socket answers the join at once, and whose
/// [RtcManager] is created when [rtcManager] completes.
CallSession _buildSession({
  required Completer<RtcManager> rtcManager,
}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();

  final events = MutableSharedEmitter<SfuEvent>();
  final sfuWS = _MockSfuWebSocket();
  when(() => sfuWS.events).thenAnswer((_) => events);
  when(sfuWS.connect).thenAnswer((_) async => const Result.success(none));
  when(
    () => sfuWS.disconnect(any(), any()),
  ).thenAnswer((_) async => const Result.success(none));
  when(() => sfuWS.send(any())).thenAnswer((_) {
    // After the session starts waiting for it.
    Timer.run(
      () => events.emit(
        SfuJoinResponseEvent(callState: createTestSfuCallState()),
      ),
    );
    return const Result<void>.success(null);
  });

  final pc = _MockRTCPeerConnection();
  when(
    () => pc.addTransceiver(
      kind: any(named: 'kind'),
      init: any(named: 'init'),
    ),
  ).thenAnswer((_) async => _MockRTCRtpTransceiver());
  when(
    pc.createOffer,
  ).thenAnswer((_) async => rtc.RTCSessionDescription('v=0', 'offer'));
  when(pc.dispose).thenAnswer((_) async {});

  final nativeFactory = _MockNativePeerConnectionFactory();
  when(
    () => nativeFactory.createPeerConnection(any(), any()),
  ).thenAnswer((_) async => pc);

  final pcFactory = _MockStreamPeerConnectionFactory();
  when(pcFactory.ensureNativeFactory).thenAnswer((_) async => nativeFactory);

  final rtcManagerFactory = _MockRtcManagerFactory();
  when(() => rtcManagerFactory.pcFactory).thenReturn(pcFactory);
  when(
    () => rtcManagerFactory.makeRtcManager(
      sfuClient: any(named: 'sfuClient'),
      stateManager: any(named: 'stateManager'),
      host: any(named: 'host'),
      clientDetails: any(named: 'clientDetails'),
      publisherId: any(named: 'publisherId'),
      sessionSequence: any(named: 'sessionSequence'),
      publishOptions: any(named: 'publishOptions'),
      statsOptions: any(named: 'statsOptions'),
      callSessionConfig: any(named: 'callSessionConfig'),
      clientEventRetryCount: any(named: 'clientEventRetryCount'),
      e2eeManager: any(named: 'e2eeManager'),
    ),
  ).thenAnswer((_) => rtcManager.future);

  final host = setupMockCallHost();
  when(() => host.apiKey).thenReturn('test-api-key');
  when(() => host.webrtcInitialized).thenAnswer((_) async {});

  return CallSession(
    retryPolicy: const RetryPolicy(),
    callCid: callCid,
    sessionSeq: 0,
    sessionId: 'test-session',
    config: const CallSessionConfig(
      sfuName: 'test-sfu',
      sfuToken: 'test-token',
      sfuUrl: 'https://test.example.com',
      sfuWsEndpoint: 'wss://test.example.com/ws',
      rtcConfig: RTCConfiguration(),
    ),
    stateManager: stateManager,
    dynascaleManager: DynascaleManager(stateManager: stateManager),
    onReconnectionNeeded: (_, _, _) {},
    onSuspendedAudioTrackRecorded: (_) {},
    sdpEditor: MockSdpEditor(),
    networkMonitor: setupMockInternetConnection(),
    statsOptions: const StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    host: host,
    tracer: Tracer(null),
    pcFactory: pcFactory,
    sfuWS: sfuWS,
    rtcManagerFactory: rtcManagerFactory,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(sfu_events.SfuRequest());
    registerFallbackValue(rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio);
    registerFallbackValue(rtc.RTCRtpTransceiverInit());
    registerFallbackValue(MockSfuClient());
    registerFallbackValue(<String, dynamic>{});
  });

  test(
    'a close while the rtcManager is being made disposes it once made',
    () async {
      final made = Completer<RtcManager>();
      final session = _buildSession(rtcManager: made);
      final rtcManager = _MockRtcManager();
      when(rtcManager.dispose).thenAnswer((_) async {});

      var callbackRan = false;
      final start = session.start(
        isAnonymousUser: true,
        onRtcManagerCreatedCallback: (_) => callbackRan = true,
      );
      await pumpEventQueue();

      await session.close(CloseCode.normalClosure);
      made.complete(rtcManager);
      final result = await start;

      expect(result.isFailure, isTrue);
      verify(rtcManager.dispose).called(1);
      expect(session.rtcManager, isNull);
      expect(session.statsReporter, isNull);
      expect(callbackRan, isFalse);
    },
  );

  test('a start nothing closes keeps the rtcManager', () async {
    final made = Completer<RtcManager>();
    final session = _buildSession(rtcManager: made);
    final rtcManager = _MockRtcManager();
    when(rtcManager.dispose).thenAnswer((_) async {});

    when(rtcManager.flushPendingDecryptors).thenAnswer((_) async {});

    final start = session.start(isAnonymousUser: true);
    await pumpEventQueue();
    made.complete(rtcManager);
    final result = await start;

    expect(result.isSuccess, isTrue);
    expect(session.rtcManager, same(rtcManager));
    verifyNever(rtcManager.dispose);
  });
}
