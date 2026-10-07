import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/connection/reconnect_trigger.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';

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
}

class _MockStreamPeerConnection extends Mock implements StreamPeerConnection {
  @override
  Future<void> dispose() async {}
}

class _MockCallSession extends Mock implements CallSession {
  @override
  Future<void> dispose() async {}
}
