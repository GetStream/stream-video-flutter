import 'package:flutter_test/flutter_test.dart';
// The libraries themselves, not the barrel, which needs a browser.
// ignore_for_file: implementation_imports, invalid_use_of_internal_member
import 'package:stream_dart_webrtc/src/e2ee/e2ee_worker_messages.dart';
import 'package:stream_dart_webrtc/src/e2ee/encoded_transform_api.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  group('encodedTransformApiFor', () {
    const chrome =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36';
    const firefox =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:145.0) '
        'Gecko/20100101 Firefox/145.0';

    test('takes insertable streams on Chrome, even with script transforms', () {
      expect(
        encodedTransformApiFor(
          userAgent: chrome,
          hasScriptTransform: true,
          hasInsertableStreams: true,
        ),
        EncodedTransformApi.insertableStreams,
      );
    });

    test('takes script transforms elsewhere', () {
      expect(
        encodedTransformApiFor(
          userAgent: firefox,
          hasScriptTransform: true,
          hasInsertableStreams: false,
        ),
        EncodedTransformApi.script,
      );
    });

    test('falls back to insertable streams without script transforms', () {
      expect(
        encodedTransformApiFor(
          userAgent: firefox,
          hasScriptTransform: false,
          hasInsertableStreams: true,
        ),
        EncodedTransformApi.insertableStreams,
      );
    });

    test('is null without either', () {
      expect(
        encodedTransformApiFor(
          userAgent: chrome,
          hasScriptTransform: false,
          hasInsertableStreams: false,
        ),
        isNull,
      );
    });
  });

  group('e2eeWorkerTrackType', () {
    test('names each track type as the worker does', () {
      expect(e2eeWorkerTrackType(E2eeTrackType.audio, 'video'), 'AUDIO');
      expect(e2eeWorkerTrackType(E2eeTrackType.video, null), 'VIDEO');
      expect(
        e2eeWorkerTrackType(E2eeTrackType.screenShare, 'video'),
        'SCREEN_SHARE',
      );
      expect(
        e2eeWorkerTrackType(E2eeTrackType.screenShareAudio, 'audio'),
        'SCREEN_SHARE_AUDIO',
      );
    });

    test('takes audio or video from the kind without a track type', () {
      expect(e2eeWorkerTrackType(null, 'audio'), 'AUDIO');
      expect(e2eeWorkerTrackType(null, 'video'), 'VIDEO');
    });
  });

  group('e2eeEventFromWorkerMessage', () {
    test('reads a missing key, with numbers as the worker sends them', () {
      final event = e2eeEventFromWorkerMessage({
        'type': 'e2ee.missing_key',
        'userId': 'alice',
        'keyIndex': 3.0,
        'trackType': 'SCREEN_SHARE',
      })!;

      expect(event.type, E2eeEventType.missingKey);
      expect(event.name, 'e2ee.missing_key');
      expect(event.userId, 'alice');
      expect(event.keyIndex, 3);
      expect(event.trackType, E2eeTrackType.screenShare);
    });

    test('reads an encryption failure', () {
      final event = e2eeEventFromWorkerMessage({
        'type': 'e2ee.encryption_failed',
        'userId': 'bob',
        'trackType': 'VIDEO',
        'reason': 'unsupported codec for E2EE: av1',
      })!;

      expect(event.type, E2eeEventType.encryptionFailed);
      expect(event.reason, 'unsupported codec for E2EE: av1');
      expect(event.trackType, E2eeTrackType.video);
    });

    test('reads a key state', () {
      final event = e2eeEventFromWorkerMessage({
        'type': 'e2ee.key_state',
        'perUserKeys': [
          {'userId': 'alice', 'keyIndex': 1.0, 'fingerprint': 'ab'},
        ],
        'sharedKeys': [
          {'keyIndex': 0.0, 'fingerprint': 'cd', 'isActive': true},
        ],
      })!;

      final keyState = event.keyState!;
      expect(keyState.perUserKeys.single.userId, 'alice');
      expect(keyState.perUserKeys.single.keyIndex, 1);
      expect(keyState.sharedKeys.single.keyIndex, 0);
      expect(keyState.sharedKeys.single.isActive, isTrue);
    });

    test('reads a performance report', () {
      final event = e2eeEventFromWorkerMessage({
        'type': 'e2ee.perf_report',
        'encode': [
          {
            'userId': 'me',
            'trackType': 'AUDIO',
            'codec': 'opus',
            'fps': 50.0,
            'maxCryptoMs': 0.4,
          },
        ],
        'decode': [
          {
            'userId': 'alice',
            'trackType': 'VIDEO',
            'fps': 30,
            'maxCryptoMs': 1,
          },
        ],
      })!;

      expect(event.encode!.single.codec, 'opus');
      expect(event.encode!.single.trackType, E2eeTrackType.audio);
      expect(event.decode!.single.fps, 30);
      expect(event.decode!.single.trackType, E2eeTrackType.video);
    });

    test('leaves out errors and other messages', () {
      expect(
        e2eeEventFromWorkerMessage({'type': 'e2ee.error', 'message': 'x'}),
        isNull,
      );
      expect(e2eeEventFromWorkerMessage({'type': 'something'}), isNull);
      expect(e2eeEventFromWorkerMessage({}), isNull);
    });
  });
}
