import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/errors/stream_video_exception.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/ws/sfu_ws.dart';

SfuWebSocket _socket() {
  return SfuWebSocket(
    sessionSeq: 0,
    sessionId: 'session-1',
    cid: 'default:call-1',
    userId: 'user-1',
    apiKey: 'test-key',
    sfuUrl: 'https://sfu.invalid/twirp',
    sfuWsEndpoint: 'wss://sfu.invalid/ws',
  );
}

/// Closes the socket the way core does, with [source] as the reason, and
/// returns whatever the SFU layer made of it.
Future<SfuEvent?> _close(
  SfuWebSocket socket,
  DisconnectionSource source,
) async {
  final emitted = socket.events.first.then<SfuEvent?>((it) => it);
  final connectionState =
      socket.client.connectionState as MutableConnectionStateEmitter;

  connectionState.value = WebSocketConnectionState.disconnected(
    source: source,
  );

  // Nothing is emitted for a closure this layer suppresses, so the wait has to
  // be able to come back empty.
  return emitted.timeout(
    const Duration(milliseconds: 200),
    onTimeout: () => null,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // This is the producer `call.dart` reads: whether a closure becomes
  // `SfuSocketDisconnected` or `SfuSocketFailed` is what decides whether a
  // call reconnects. It had no test — the suites on either side of it cover
  // the consumer and stream_core's policy, but not the mapping between them.
  group('what the SFU makes of a server-initiated closure', () {
    test('a bare closure is a plain disconnection', () async {
      // Core builds exactly this on an unexpected close: a network exception
      // carrying the close code and nothing underneath it.
      final event = await _close(
        _socket(),
        const DisconnectionSource.serverInitiated(
          error: StreamNetworkException(
            message: 'going away',
            closeCode: CloseCode.goingAway,
          ),
        ),
      );

      expect(event, isA<SfuSocketDisconnected>());
      final reason = (event! as SfuSocketDisconnected).reason;
      expect(reason.closeCode, CloseCode.goingAway);
      expect(reason.closeReason, 'going away');
      expect(reason.isReconnectable, isTrue);
    });

    test('a closure wrapping a transport error is a failure', () async {
      final event = await _close(
        _socket(),
        DisconnectionSource.serverInitiated(
          error: StreamNetworkException(
            message: 'connection reset',
            isTimeout: true,
            cause: Exception('SocketException: reset by peer'),
          ),
        ),
      );

      expect(event, isA<SfuSocketFailed>());

      // Carrying the closure, not the socket exception underneath it: the
      // classification is what telemetry reads to tell a client-side network
      // failure from one the SFU answered with.
      final carried = (event! as SfuSocketFailed).error.streamException;
      expect(carried, isA<StreamNetworkException>());
      expect((carried! as StreamNetworkException).isTimeout, isTrue);
    });

    test('a server verdict is a failure, not a disconnection', () async {
      final event = await _close(
        _socket(),
        const DisconnectionSource.serverInitiated(
          error: StreamApiException(
            message: 'not allowed',
            statusCode: 403,
          ),
        ),
      );

      expect(event, isA<SfuSocketFailed>());
      expect((event! as SfuSocketFailed).isReconnectable, isFalse);
    });

    // A socket that closed without a code reports none, rather than reporting
    // zero as though the server had sent it.
    test('a zero close code is reported as none', () async {
      final event = await _close(
        _socket(),
        const DisconnectionSource.serverInitiated(
          error: StreamNetworkException(message: 'closed', closeCode: 0),
        ),
      );

      expect((event! as SfuSocketDisconnected).reason.closeCode, isNull);
    });
  });

  group('what the SFU makes of the other closures', () {
    test('an unhealthy connection is a disconnection', () async {
      final event = await _close(
        _socket(),
        const DisconnectionSource.unHealthyConnection(),
      );

      expect(event, isA<SfuSocketDisconnected>());
      expect((event! as SfuSocketDisconnected).reason.isReconnectable, isTrue);
    });

    test('a refused authentication is a failure', () async {
      final event = await _close(
        _socket(),
        const DisconnectionSource.authenticationFailed(
          error: StreamAuthenticationException(message: 'no token'),
        ),
      );

      expect(event, isA<SfuSocketFailed>());
    });

    // A close this SDK asked for is not news for the call to act on.
    test('a closure the caller asked for emits nothing', () async {
      expect(
        await _close(_socket(), const DisconnectionSource.userInitiated()),
        isNull,
      );
    });

    test('a recreate emits nothing', () async {
      expect(
        await _close(_socket(), const DisconnectionSource.systemInitiated()),
        isNull,
      );
    });
  });
}
