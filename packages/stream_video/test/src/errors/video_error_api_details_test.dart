import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

VideoError _apiFailure(int status, Object body) {
  return VideoErrorWithCause(
    message: 'failed',
    cause: ApiException(status, body is String ? body : jsonEncode(body)),
  );
}

void main() {
  group('VideoError.apiError', () {
    test('decodes the error the server actually sent', () {
      final error = _apiFailure(400, {
        'code': 109,
        'message':
            'call default:teste2e is end-to-end encrypted; '
            'the join must request e2ee',
        'StatusCode': 400,
        'duration': '0.00ms',
        'more_info': 'https://getstream.io/chat/docs/api_errors_response',
        'details': <int>[],
        'unrecoverable': true,
      });

      final api = error.apiError;

      expect(api, isNotNull);
      expect(api!.unrecoverable, isTrue);
      // The Stream code, which the HTTP status cannot tell you.
      expect(api.code, 109);
      expect(api.message, contains('must request e2ee'));
    });

    test('reports null when the server did not say', () {
      final api = _apiFailure(500, {
        'code': 0,
        'message': 'internal error',
        'StatusCode': 500,
        'duration': '0.00ms',
        'more_info': '',
        'details': <int>[],
      }).apiError;

      // Absent, not false: the caller falls back to the status rather than
      // reading an omission as a verdict.
      expect(api, isNotNull);
      expect(api!.unrecoverable, isNull);
    });

    test('survives a body that is not a Stream error at all', () {
      // A proxy or gateway can answer with anything.
      expect(_apiFailure(502, '<html>Bad Gateway</html>').apiError, isNull);
      expect(_apiFailure(400, '').apiError, isNull);
    });

    test('is null for a failure that did not come from the API', () {
      expect(const VideoError(message: 'local').apiError, isNull);
      expect(
        const VideoErrorWithCause(
          message: 'x',
          cause: 'not an exception',
        ).apiError,
        isNull,
      );
    });
  });
}
