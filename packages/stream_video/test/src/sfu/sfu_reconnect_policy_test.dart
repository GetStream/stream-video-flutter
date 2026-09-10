import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';

/// The SFU reconnect gate reads `DisconnectionSource.isReconnectable` rather
/// than the close code, because a server can close with a normal code even when
/// something went wrong and report the reason separately.
///
/// That makes stream_core's policy part of this SDK's behaviour, so it is
/// pinned here: a future upgrade that changes when a call reconnects should
/// fail this file rather than surface as calls that stop recovering — which is
/// how the 0.5.0 upgrade's changes reached us.
void main() {
  DisconnectionSource serverClosed({StreamException? error}) {
    return DisconnectionSource.serverInitiated(error: error);
  }

  group('closures the SFU recovers from', () {
    test('a closure the server gave no reason for', () {
      expect(serverClosed().isReconnectable, isTrue);
    });

    test('an unhealthy connection', () {
      expect(const UnHealthyConnection().isReconnectable, isTrue);
    });

    test('a connection that never came up in time', () {
      expect(const ConnectTimeout().isReconnectable, isTrue);
    });

    // The close-code gate this replaced treated 1001 as an intentional closure
    // and stayed down. A server going away is exactly when a call should come
    // back — on another SFU if need be.
    test('a server going away (1001)', () {
      expect(
        serverClosed(
          error: const StreamNetworkException(
            message: 'going away',
            closeCode: CloseCode.goingAway,
          ),
        ).isReconnectable,
        isTrue,
      );
    });

    test('a server error, which may not recur', () {
      expect(
        serverClosed(
          error: const StreamApiException(message: 'boom', statusCode: 503),
        ).isReconnectable,
        isTrue,
      );
    });

    test('an expired token, which the reconnect authenticates afresh', () {
      expect(
        serverClosed(
          error: const StreamApiException(
            message: 'token expired',
            statusCode: 401,
            code: StreamErrorCode.tokenExpired,
          ),
        ).isReconnectable,
        isTrue,
      );
    });
  });

  group('closures the SFU stays down for', () {
    test('a deliberate normal closure (1000)', () {
      expect(
        serverClosed(
          error: const StreamNetworkException(
            message: 'closed',
            closeCode: CloseCode.normalClosure,
          ),
        ).isReconnectable,
        isFalse,
      );
    });

    test('an error the server marked unrecoverable', () {
      expect(
        serverClosed(
          error: const StreamApiException(
            message: 'nope',
            statusCode: 400,
            unrecoverable: true,
          ),
        ).isReconnectable,
        isFalse,
      );
    });

    test('a permission denial', () {
      expect(
        serverClosed(
          error: const StreamApiException(message: 'nope', statusCode: 403),
        ).isReconnectable,
        isFalse,
      );
    });

    test('a refused token signature, which no retry changes', () {
      expect(
        serverClosed(
          error: const StreamApiException(
            message: 'bad signature',
            statusCode: 401,
            code: StreamErrorCode.tokenSignatureInvalid,
          ),
        ).isReconnectable,
        isFalse,
      );
    });

    test('an unknown API key', () {
      expect(
        serverClosed(
          error: const StreamApiException(
            message: 'bad key',
            statusCode: 401,
            code: StreamErrorCode.apiKeyInvalid,
          ),
        ).isReconnectable,
        isFalse,
      );
    });

    test('a disconnect the caller asked for', () {
      expect(const UserInitiated().isReconnectable, isFalse);
    });
  });
}
