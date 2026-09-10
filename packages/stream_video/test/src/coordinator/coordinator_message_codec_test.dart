import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show StreamApiError, StreamErrorCodePredicates;
import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_message_codec.dart';

/// The wire form of a coordinator API error with the given [code].
String _apiErrorMessage(int code) {
  return json.encode({
    'error': {
      'code': code,
      'details': <int>[],
      'duration': '0.1ms',
      'message': 'error message',
      'more_info': 'https://getstream.io/docs',
      'StatusCode': 401,
    },
  });
}

void main() {
  group('CoordinatorMessageCodec', () {
    late CoordinatorMessageCodec codec;

    setUp(() => codec = CoordinatorMessageCodec());

    // The socket client reads `error` to close the connection with it, which is
    // what tells the next authentication attempt why the previous one was
    // refused. An error that is only suppressed leaves the attempt refreshing
    // nothing and resending the token the server just rejected.
    test('surfaces an expired-token error as the event error', () {
      final event = codec.decode(_apiErrorMessage(40));

      expect(event.event, isNull);
      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenExpired, isTrue);
    });

    test('surfaces a not-yet-valid token as the event error', () {
      final event = codec.decode(_apiErrorMessage(41));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenNotYetValid, isTrue);
    });

    test('surfaces a refused token signature as the event error', () {
      final event = codec.decode(_apiErrorMessage(43));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isTokenSignatureInvalid, isTrue);
    });

    test('surfaces a rejected API key as the event error', () {
      final event = codec.decode(_apiErrorMessage(2));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).code.isApiKeyInvalid, isTrue);
    });

    // The socket client closes the connection with any error it is handed, so
    // an error that says nothing about the credentials must stay suppressed —
    // otherwise a working connection is dropped over an error about a single
    // request.
    test('suppresses an error unrelated to the credentials', () {
      final event = codec.decode(_apiErrorMessage(17));

      expect(event.event, isNull);
      expect(event.error, isNull);
    });

    test('decodes a domain event without an error', () {
      final event = codec.decode(
        json.encode({
          'type': 'health.check',
          'connection_id': 'connection-1',
          'created_at': '2026-01-01T00:00:00.000Z',
        }),
      );

      expect(event.event, isA<CoordinatorHealthCheckEvent>());
      expect(event.error, isNull);
      expect(event.healthCheckInfo?.connectionId, 'connection-1');
    });

    test('suppresses a message it cannot read, without an error', () {
      final event = codec.decode('not json');

      expect(event.event, isNull);
      expect(event.error, isNull);
    });
  });

  // Dropping is the one sanctioned way a failure goes undelivered: there is no
  // operation to fail, and closing a healthy connection over one bad frame
  // would be worse. What the socket must never see is a half-decoded message.
  group('CoordinatorMessageCodec suppresses what it cannot deliver', () {
    late CoordinatorMessageCodec codec;

    setUp(() => codec = CoordinatorMessageCodec());

    void expectSuppressed(Object message) {
      final event = codec.decode(message);

      expect(event.event, isNull);
      expect(event.error, isNull);
      expect(event.healthCheckInfo, isNull);
    }

    test('a frame that is not text', () => expectSuppressed(const [1, 2, 3]));

    test('a frame that is not JSON', () => expectSuppressed('not json'));

    test('a server error it does not surface', () {
      expectSuppressed(_apiErrorMessage(17));
    });

    test('an envelope it does not recognise', () {
      expectSuppressed(json.encode({'nothing': 'recognisable'}));
    });

    // Suppressed by the codec, which still knows the type name to log, rather
    // than handed to the socket as an event it can only discard unnamed.
    test('an event type this SDK version has no model for', () {
      expectSuppressed(
        json.encode({
          'type': 'call.invented_in_a_later_version',
          'created_at': '2026-01-01T00:00:00.000Z',
        }),
      );
    });
  });
}
