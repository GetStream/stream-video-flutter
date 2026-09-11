import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/errors/stream_video_exception.dart';
import 'package:stream_video/src/sfu/data/models/sfu_error.dart';
import 'package:stream_video/src/telemetry/client_event_error_mapper.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';

/// A failure shaped the way this SDK composes one: a message, and the thing
/// that actually failed underneath.
StreamVideoException _composed(Object cause, {String message = 'failed'}) {
  return StreamVideoExceptionWithCause(message: message, cause: cause);
}

void main() {
  const mapper = ClientEventErrorMapper();

  // The mapper used to classify by the runtime type of `cause`, which the core
  // migration changed underneath it: a Dio timeout arrives as a
  // StreamNetworkException now, so every HTTP failure was being reported as a
  // generic SERVER_ERROR. It reads the facts instead.
  group('classifies a core failure by the facts it carries', () {
    test('a timeout is a request timeout, not a server error', () {
      final failure = mapper.map(
        _composed(
          const StreamNetworkException(message: 'timed out', isTimeout: true),
        ),
      );

      expect(failure.code, ClientEventStandardCode.requestTimeout);
    });

    test('a 408 the server named is a request timeout too', () {
      final failure = mapper.map(
        _composed(
          const StreamApiException(message: 'too slow', statusCode: 408),
        ),
      );

      expect(failure.code, ClientEventStandardCode.requestTimeout);
    });

    test('a cancellation is the client aborting, not a failure', () {
      final failure = mapper.map(
        _composed(
          const StreamNetworkException(
            message: 'cancelled',
            isCancelled: true,
          ),
        ),
      );

      expect(failure.code, ClientEventStandardCode.clientAborted);
    });

    test('a connection that never reached a verdict reads as offline', () {
      final failure = mapper.map(
        _composed(const StreamNetworkException(message: 'no route')),
      );

      expect(failure.code, ClientEventStandardCode.networkOffline);
    });

    test('a server verdict reports its status', () {
      final failure = mapper.map(
        _composed(
          const StreamApiException(message: 'boom', statusCode: 503),
        ),
      );

      expect(failure.code, ClientEventStandardCode.serverError);
      expect(failure.reason, 'HTTP 503: boom');
    });

    test('an SFU verdict wins over everything else', () {
      final failure = mapper.map(
        _composed(
          const SfuError(
            message: 'not allowed',
            code: SfuErrorCode.participantNotFound,
            shouldRetry: false,
            reconnectStrategy: SfuReconnectionStrategy.unspecified,
          ),
        ),
      );

      expect(failure.code, ClientEventStandardCode.sfuError);
      expect(failure.reason, contains('not allowed'));
    });

    test('a credentials failure has no code of its own', () {
      final failure = mapper.map(
        _composed(
          const StreamAuthenticationException(message: 'no token'),
          message: 'could not authenticate',
        ),
      );

      expect(failure.code, ClientEventStandardCode.serverError);
      expect(failure.reason, 'could not authenticate');
    });
  });

  // Nothing guarantees the reporter is handed a composed failure — it takes an
  // `Object?`, so a raw throw can reach it.
  group('classifies what never went through error composition', () {
    test('a bare core exception', () {
      final failure = mapper.map(
        const StreamNetworkException(message: 'timed out', isTimeout: true),
      );

      expect(failure.code, ClientEventStandardCode.requestTimeout);
    });

    test('a raw TimeoutException', () {
      final failure = mapper.map(TimeoutException('gave up'));

      expect(failure.code, ClientEventStandardCode.requestTimeout);
    });

    test('a platform message that reads as offline', () {
      final failure = mapper.map(
        _composed(Exception('Failed host lookup: video.stream-io-api.com')),
      );

      expect(failure.code, ClientEventStandardCode.networkOffline);
    });

    test('anything else reports the message it had', () {
      final failure = mapper.map(
        const StreamVideoException(message: 'something odd'),
      );

      expect(failure.code, ClientEventStandardCode.serverError);
      expect(failure.reason, 'something odd');
    });

    test('a null error is still reportable', () {
      final failure = mapper.map(null);

      expect(failure.code, ClientEventStandardCode.serverError);
      expect(failure.reason, 'Unknown error');
    });
  });
}
