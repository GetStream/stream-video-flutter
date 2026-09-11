import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

StreamVideoException _apiFailure(
  int status, {
  StreamErrorCode code = StreamErrorCode.videoJoinMustRequestE2ee,
  bool? unrecoverable,
}) {
  return StreamVideoExceptionWithCause(
    message: 'failed',
    cause: StreamApiError(
      code: code,
      details: const [],
      duration: '0.00ms',
      message:
          'call default:teste2e is end-to-end encrypted; '
          'the join must request e2ee',
      moreInfo: 'https://getstream.io/chat/docs/api_errors_response',
      statusCode: status,
      unrecoverable: unrecoverable,
    ),
  );
}

void main() {
  group('StreamVideoException.apiError', () {
    test('exposes the error the server actually sent', () {
      final api = _apiFailure(400, unrecoverable: true).apiError;

      expect(api, isNotNull);
      expect(api!.unrecoverable, isTrue);
      // The Stream code, which the HTTP status cannot tell you.
      expect(api.code, 109);
      expect(api.message, contains('must request e2ee'));
    });

    test('reports null when the server did not say', () {
      final api = _apiFailure(500, code: const StreamErrorCode(0)).apiError;

      // Absent, not false: the caller falls back to the status rather than
      // reading an omission as a verdict.
      expect(api, isNotNull);
      expect(api!.unrecoverable, isNull);
    });

    test('is null for a failure that did not come from the API', () {
      expect(const StreamVideoException(message: 'local').apiError, isNull);
      expect(
        const StreamVideoExceptionWithCause(
          message: 'x',
          cause: 'not an api error',
        ).apiError,
        isNull,
      );
    });
  });
}
