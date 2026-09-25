import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/src/sfu/ws/sfu_message_codec.dart';
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

/// Delivers [event] as if the SFU had sent it, through the same codec the
/// socket decodes the wire with.
void _receive(SfuWebSocket socket, sfu_events.SfuEvent event) {
  final events = socket.client.events as MutableEventEmitter<WsEvent>;
  events.emit(const SfuMessageCodec().decode(event.writeToBuffer()));
}

/// Moves the socket to [state] the way core does when the connection changes.
void _setState(SfuWebSocket socket, WebSocketConnectionState state) {
  final connectionState =
      socket.client.connectionState as MutableConnectionStateEmitter;
  connectionState.value = state;
}

const _dropped = WebSocketConnectionState.disconnected(
  source: DisconnectionSource.serverInitiated(
    error: StreamNetworkException(message: 'connection lost'),
  ),
);

sfu_events.SfuEvent _joinResponse({required bool reconnected}) {
  return sfu_events.SfuEvent(
    joinResponse: sfu_events.JoinResponse(
      reconnected: reconnected,
      fastReconnectDeadlineSeconds: 13,
    ),
  );
}

sfu_events.SfuRequest _joinRequest() {
  return sfu_events.SfuRequest(
    joinRequest: sfu_events.JoinRequest(sessionId: 'session-1'),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A fast reconnect checks this before it waits for an answer: a request
  // that never left cannot be answered.
  group('SfuWebSocket.send', () {
    test('fails on a socket that was never opened', () {
      expect(_socket().send(_joinRequest()).isFailure, isTrue);
    });

    test('fails on a socket that went down', () {
      final socket = _socket();
      _setState(socket, _dropped);

      expect(socket.send(_joinRequest()).isFailure, isTrue);
    });
  });

  // This replaced a wait that only ever ended on the join response or 30s,
  // however early the socket had gone: long enough to take a fast reconnect
  // past the SFU's deadline and into a rejoin.
  group('SfuWebSocket.waitForJoinResponse', () {
    // Far longer than any case below should take, so a wait that only
    // settles on the time limit fails the test through its own timeout.
    const timeLimit = Duration(seconds: 30);
    const settlesWithin = Duration(seconds: 2);

    test('settles with the join response', () async {
      final socket = _socket();

      final wait = socket.waitForJoinResponse(timeLimit: timeLimit);
      _receive(socket, _joinResponse(reconnected: true));
      final result = await wait.timeout(settlesWithin);

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull()!.isReconnected, isTrue);
    });

    test('passes a reconnected: false answer through untouched', () async {
      final socket = _socket();

      final wait = socket.waitForJoinResponse(timeLimit: timeLimit);
      _receive(socket, _joinResponse(reconnected: false));
      final result = await wait.timeout(settlesWithin);

      expect(result.getOrNull()!.isReconnected, isFalse);
    });

    test('fails on an SFU error instead of waiting it out', () async {
      final socket = _socket();

      final wait = socket.waitForJoinResponse(timeLimit: timeLimit);
      _receive(
        socket,
        sfu_events.SfuEvent(
          error: sfu_events.Error(
            error: sfu_models.Error(message: 'participant not found'),
          ),
        ),
      );
      final result = await wait.timeout(settlesWithin);

      expect(result.isFailure, isTrue);
    });

    test('fails as soon as the socket drops', () async {
      final socket = _socket();

      final wait = socket.waitForJoinResponse(timeLimit: timeLimit);
      _setState(socket, _dropped);
      final result = await wait.timeout(settlesWithin);

      expect(result.isFailure, isTrue);
    });

    test('fails at once on a socket already down', () async {
      final socket = _socket();
      _setState(socket, _dropped);

      final result = await socket
          .waitForJoinResponse(timeLimit: timeLimit)
          .timeout(settlesWithin);

      expect(result.isFailure, isTrue);
    });

    test('fails once the time limit passes', () async {
      final result = await _socket().waitForJoinResponse(
        timeLimit: const Duration(milliseconds: 50),
      );

      expect(result.isFailure, isTrue);
    });

    test('ignores events that are neither answer nor error', () async {
      final socket = _socket();

      final wait = socket.waitForJoinResponse(timeLimit: timeLimit);
      _receive(
        socket,
        sfu_events.SfuEvent(
          healthCheckResponse: sfu_events.HealthCheckResponse(),
        ),
      );
      _receive(socket, _joinResponse(reconnected: true));
      final result = await wait.timeout(settlesWithin);

      expect(result.isSuccess, isTrue);
    });
  });
}
