import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/connection/reconnect_trigger.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';

void main() {
  group('ReconnectTrigger.isStillNeeded', () {
    test('a failed peer connection needs it until it is connected again', () {
      final peerConnection = _MockStreamPeerConnection();

      when(peerConnection.isConnected).thenReturn(false);
      expect(PeerConnectionFailed(peerConnection).isStillNeeded, isTrue);

      when(peerConnection.isConnected).thenReturn(true);
      expect(PeerConnectionFailed(peerConnection).isStillNeeded, isFalse);
    });

    test('a stuck peer connection always needs it, even when connected', () {
      final peerConnection = _MockStreamPeerConnection();
      when(peerConnection.isConnected).thenReturn(true);

      expect(PeerConnectionStuck(peerConnection).isStillNeeded, isTrue);
    });

    test('a lost SFU socket needs it until the socket is connected again', () {
      final session = _MockCallSession();

      when(() => session.isSfuConnected).thenReturn(false);
      expect(SfuSocketLost(session).isStillNeeded, isTrue);

      when(() => session.isSfuConnected).thenReturn(true);
      expect(SfuSocketLost(session).isStillNeeded, isFalse);
    });

    test('a lost network always needs it', () {
      expect(const NetworkLost().isStillNeeded, isTrue);
    });

    test('a request from the SFU always needs it', () {
      expect(const SfuRequested().isStillNeeded, isTrue);
    });
  });

  group('IceNeverConnected.isStillNeeded', () {
    late _MockCallSession session;
    late _MockRtcManager rtcManager;

    setUp(() {
      session = _MockCallSession();
      rtcManager = _MockRtcManager();
      when(() => session.rtcManager).thenReturn(rtcManager);
      when(() => rtcManager.hasIceEverConnected).thenReturn(false);
      when(() => rtcManager.hasNoLocalCandidates).thenReturn(true);
    });

    test('needs it while no peer connection has connected', () {
      expect(session.isIceNeverConnected, isTrue);
      expect(
        IceNeverConnected(session, otherwise: null).isStillNeeded,
        isTrue,
      );
    });

    test('for no local candidates, needs it until a gathering round finds '
        'some', () {
      final trigger = IceNeverConnected(
        session,
        otherwise: null,
        noLocalCandidates: true,
      );
      expect(trigger.isStillNeeded, isTrue);

      when(() => rtcManager.hasNoLocalCandidates).thenReturn(false);
      expect(trigger.isStillNeeded, isFalse);
    });

    test('once a peer connection connected, defers to what asked for it', () {
      when(() => rtcManager.hasIceEverConnected).thenReturn(true);
      final failed = _MockStreamPeerConnection();

      expect(session.isIceNeverConnected, isFalse);

      when(failed.isConnected).thenReturn(false);
      expect(
        IceNeverConnected(
          session,
          otherwise: PeerConnectionFailed(failed),
        ).isStillNeeded,
        isTrue,
      );

      when(failed.isConnected).thenReturn(true);
      expect(
        IceNeverConnected(
          session,
          otherwise: PeerConnectionFailed(failed),
        ).isStillNeeded,
        isFalse,
      );

      expect(
        IceNeverConnected(
          session,
          otherwise: const SfuRequested(),
        ).isStillNeeded,
        isTrue,
      );
      expect(
        IceNeverConnected(
          session,
          otherwise: null,
          noLocalCandidates: true,
        ).isStillNeeded,
        isFalse,
      );
    });

    test('a session without peer connections defers to what asked for it', () {
      when(() => session.rtcManager).thenReturn(null);

      expect(session.isIceNeverConnected, isFalse);
      expect(
        IceNeverConnected(
          session,
          otherwise: const SfuRequested(),
        ).isStillNeeded,
        isTrue,
      );
      expect(
        IceNeverConnected(session, otherwise: null).isStillNeeded,
        isFalse,
      );
    });
  });
}

class _MockStreamPeerConnection extends Mock implements StreamPeerConnection {
  @override
  Future<void> dispose() async {}
}

class _MockCallSession extends Mock implements CallSession {
  @override
  Future<void> dispose() async {}
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}
