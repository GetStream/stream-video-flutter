import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_core/stream_core.dart' show MutableStateEmitter;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/call_state.dart';
import 'package:stream_video/src/models/models.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_remote_track.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {
  @override
  Future<void> dispose() {
    return Future.value();
  }
}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockReceiver extends Mock implements rtc.RTCRtpReceiver {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

class _MockEncryptionManager extends Mock implements rtc.EncryptionManager {}

const _prefix = 'remote-prefix';

/// A remote track whose receiver is reachable through its transceiver.
RtcRemoteTrack _remoteTrack() {
  final mediaTrack = _MockMediaStreamTrack();
  when(() => mediaTrack.id).thenReturn('remote-media');
  when(() => mediaTrack.kind).thenReturn('video');

  final transceiver = _MockTransceiver();
  when(() => transceiver.receiver).thenReturn(_MockReceiver());

  return RtcRemoteTrack(
    trackIdPrefix: _prefix,
    trackType: SfuTrackType.video,
    mediaTrack: mediaTrack,
    mediaStream: _MockMediaStream(),
    transceiver: transceiver,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(_MockReceiver());
  });

  late _MockEncryptionManager e2ee;
  late MutableStateEmitter<CallState> callState;
  late CallStateNotifier stateManager;
  late RtcManager manager;

  /// Puts a participant on the call, which is what lets a queued track resolve
  /// the user id its key is stored under.
  void addParticipant() {
    callState.value = callState.value.copyWith(
      callParticipants: [
        CallParticipantState(
          userId: 'remote-user',
          roles: const [],
          name: '',
          custom: const {},
          image: '',
          sessionId: 'remote-session',
          trackIdPrefix: _prefix,
        ),
      ],
    );
    when(() => stateManager.callState).thenReturn(callState.value);
  }

  setUp(() {
    e2ee = _MockEncryptionManager();
    when(() => e2ee.isDisposed).thenReturn(false);
    when(
      () => e2ee.decrypt(
        any(),
        userId: any(named: 'userId'),
        trackType: any(named: 'trackType'),
      ),
    ).thenAnswer((_) async {});

    callState = MutableStateEmitter<CallState>(
      createTestCallState(),
      sync: true,
    );
    stateManager = createTestCallStateManager(callState: callState);

    manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: _MockTracedStreamPeerConnection(),
      subscriber: _MockTracedStreamPeerConnection(),
      publishOptions: const [],
      stateManager: stateManager,
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
      e2eeManager: e2ee,
    );
  });

  group('attachDecryptor', () {
    test('queues a track whose participant is not known yet', () async {
      await manager.attachDecryptor(_remoteTrack());

      // Attaching against an unknown user id would decrypt with the wrong key,
      // so the track waits instead.
      verifyNever(
        () => e2ee.decrypt(
          any(),
          userId: any(named: 'userId'),
          trackType: any(named: 'trackType'),
        ),
      );
    });

    test('attaches a queued track once its participant arrives', () async {
      await manager.attachDecryptor(_remoteTrack());
      addParticipant();

      await manager.flushPendingDecryptors();

      verify(
        () => e2ee.decrypt(
          any(),
          userId: 'remote-user',
          trackType: rtc.E2eeTrackType.video,
        ),
      ).called(1);
    });

    test('a flushed track is not attached twice', () async {
      await manager.attachDecryptor(_remoteTrack());
      addParticipant();

      await manager.flushPendingDecryptors();
      await manager.flushPendingDecryptors();

      verify(
        () => e2ee.decrypt(
          any(),
          userId: any(named: 'userId'),
          trackType: any(named: 'trackType'),
        ),
      ).called(1);
    });

    test('drops queued tracks for a participant who left', () async {
      await manager.attachDecryptor(_remoteTrack());

      // Otherwise they are retried on every flush for the rest of the call,
      // and the queue keeps their tracks alive.
      manager.discardPendingDecryptors(_prefix);
      addParticipant();
      await manager.flushPendingDecryptors();

      verifyNever(
        () => e2ee.decrypt(
          any(),
          userId: any(named: 'userId'),
          trackType: any(named: 'trackType'),
        ),
      );
    });

    test('does nothing when the call is not encrypted', () async {
      final plain = RtcManager(
        sessionId: 'test-session',
        callCid: SampleCallData.defaultCid,
        publisherId: 'test-publisher',
        publisher: _MockTracedStreamPeerConnection(),
        subscriber: _MockTracedStreamPeerConnection(),
        publishOptions: const [],
        stateManager: stateManager,
        streamVideo: setupMockStreamVideo(),
        pcFactory: StreamPeerConnectionFactory(
          callCid: SampleCallData.defaultCid,
        ),
      );

      addParticipant();
      await plain.attachDecryptor(_remoteTrack());
      await plain.flushPendingDecryptors();

      verifyNever(
        () => e2ee.decrypt(
          any(),
          userId: any(named: 'userId'),
          trackType: any(named: 'trackType'),
        ),
      );
    });
  });
}
