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

  // Dropping is the one sanctioned way a failure goes undelivered, and the
  // count is what keeps it visible: without it, an event this SDK version has
  // no model for is indistinguishable from one the server never sent.
  group('CoordinatorMessageCodec counts what it drops', () {
    late CoordinatorMessageCodec codec;

    setUp(() => codec = CoordinatorMessageCodec());

    test('counts a frame that is not text', () {
      codec.decode(const [1, 2, 3]);

      expect(codec.dropped[CoordinatorDropReason.notText], 1);
      expect(codec.dropped.total, 1);
    });

    test('counts a frame that is not JSON', () {
      codec.decode('not json');

      expect(codec.dropped[CoordinatorDropReason.malformedJson], 1);
    });

    test('counts a server error it did not surface', () {
      codec.decode(_apiErrorMessage(17));

      expect(codec.dropped[CoordinatorDropReason.serverError], 1);
    });

    test('counts an envelope it does not recognise', () {
      codec.decode(json.encode({'nothing': 'recognisable'}));

      expect(codec.dropped[CoordinatorDropReason.unrecognisedEnvelope], 1);
    });

    test('does not count a credentials error, which it surfaces', () {
      codec.decode(_apiErrorMessage(40));

      expect(codec.dropped.total, 0);
    });

    test('does not count an event it delivered', () {
      codec.decode(
        json.encode({
          'type': 'health.check',
          'connection_id': 'connection-1',
          'created_at': '2026-01-01T00:00:00.000Z',
        }),
      );

      expect(codec.dropped.total, 0);
    });

    test('accumulates across messages, by reason', () {
      codec
        ..decode('not json')
        ..decode('still not json')
        ..decode(_apiErrorMessage(17));

      expect(codec.dropped[CoordinatorDropReason.malformedJson], 2);
      expect(codec.dropped[CoordinatorDropReason.serverError], 1);
      expect(codec.dropped.total, 3);
    });
  });
}
