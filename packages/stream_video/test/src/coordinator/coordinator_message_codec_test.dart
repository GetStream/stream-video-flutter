import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show StreamApiError, StreamApiErrorExtension;
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
    const codec = CoordinatorMessageCodec();

    // The socket client reads `error` to close the connection with it, which is
    // what tells the next authentication attempt why the previous one was
    // refused. An error that is only suppressed leaves the attempt refreshing
    // nothing and resending the token the server just rejected.
    test('surfaces an expired-token error as the event error', () {
      final event = codec.decode(_apiErrorMessage(40));

      expect(event.event, isNull);
      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).isTokenExpiredError, isTrue);
    });

    test('surfaces an invalid-token error as the event error', () {
      final event = codec.decode(_apiErrorMessage(41));

      final error = event.error;
      expect(error, isA<StreamApiError>());
      expect((error! as StreamApiError).isInvalidTokenError, isTrue);
    });

    test('surfaces an error unrelated to the token too', () {
      final event = codec.decode(_apiErrorMessage(17));

      expect(event.error, isA<StreamApiError>());
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
}
