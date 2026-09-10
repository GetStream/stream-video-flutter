import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_ws.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/token/token_source.dart';

/// A syntactically valid JWT carrying [userId], which is all `UserToken`
/// validates.
String _fakeJwt(String userId) {
  String encode(Map<String, dynamic> part) =>
      base64Url.encode(utf8.encode(json.encode(part))).replaceAll('=', '');

  final header = encode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = encode({'user_id': userId});
  final signature = encode({'sig': 'fake'});
  return '$header.$payload.$signature';
}

CoordinatorWebSocket _socket() {
  return CoordinatorWebSocket(
    'wss://localhost:0',
    apiKey: 'test-key',
    userInfo: const UserInfo(id: 'user-1'),
    tokenSource: TokenSource(
      TokenManager(
        userId: 'user-1',
        tokenProvider: TokenProvider.static(UserToken(_fakeJwt('user-1'))),
      ),
    ),
  );
}

/// Closes the socket the way core does, with [source] as the reason.
void _close(CoordinatorWebSocket socket, DisconnectionSource source) {
  final connectionState =
      socket.client.connectionState as MutableConnectionStateEmitter;

  connectionState.value = WebSocketConnectionState.disconnected(source: source);
}

void main() {
  // A closure that is not reconnectable ends the session, so this event is the
  // only account the app gets of why. It has to carry the server's verdict —
  // flattening the exception to its message loses the token code and status,
  // which is what an app keys its "sign in again" handling off.
  group('CoordinatorDisconnectedEvent carries the refusal', () {
    // Built the way the real path builds it: the coordinator sends an error
    // frame, the codec hands core the payload, and core turns it into the
    // exception via `fromApiError` — which is what puts the payload on it.
    // `CoordinatorDisconnectedEvent.apiError` is that payload.
    final refusal = StreamApiException.fromApiError(
      const StreamApiError(
        code: StreamErrorCode.tokenExpired,
        details: [],
        duration: '1ms',
        message: 'token expired',
        moreInfo: '',
        statusCode: 401,
      ),
    );

    test('an authentication failure reports the code and status', () async {
      final socket = _socket();
      final event = socket.events
          .firstWhere((it) => it is CoordinatorDisconnectedEvent)
          .then((it) => it as CoordinatorDisconnectedEvent);

      _close(
        socket,
        DisconnectionSource.authenticationFailed(error: refusal),
      );

      final disconnected = await event;
      expect(disconnected.apiError, isNotNull);
      expect(disconnected.apiError?.statusCode, 401);
      expect(disconnected.apiError?.code.isTokenExpired, isTrue);
    });

    test('a server-initiated refusal reports them too', () async {
      final socket = _socket();
      final event = socket.events
          .firstWhere((it) => it is CoordinatorDisconnectedEvent)
          .then((it) => it as CoordinatorDisconnectedEvent);

      _close(socket, DisconnectionSource.serverInitiated(error: refusal));

      final disconnected = await event;
      expect(disconnected.apiError?.statusCode, 401);
    });

    // Nothing to report is still a valid outcome; it must not throw or invent
    // an error.
    test('a user-initiated closure reports no error', () async {
      final socket = _socket();
      final event = socket.events
          .firstWhere((it) => it is CoordinatorDisconnectedEvent)
          .then((it) => it as CoordinatorDisconnectedEvent);

      _close(socket, const DisconnectionSource.userInitiated());

      final disconnected = await event;
      expect(disconnected.apiError, isNull);
    });
  });
}
