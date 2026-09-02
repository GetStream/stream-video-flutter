import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_notification.dart';

CallData _call({String? uuid, String? callCid}) =>
    CallData(uuid: uuid, callCid: callCid);

void main() {
  group('resolveCallsToEnd', () {
    test('ends everything when every active call belongs to the cid', () {
      final decision = resolveCallsToEnd([
        _call(uuid: 'uuid-1', callCid: 'default:abc'),
      ], 'default:abc');

      expect(decision.endAll, isTrue);
    });

    test('ends everything when the platform reports no calls', () {
      // The Android Telecom sweep in endAllCalls depends on this: a call can be live in the
      // Telecom stack after it was already removed from the native active call list.
      final decision = resolveCallsToEnd([], 'default:abc');

      expect(decision.endAll, isTrue);
    });

    test('ends a call the platform can no longer identify', () {
      // iOS reports a CallKit call that outlived the process with its uuid and nothing else.
      // Before this was handled, nothing ended it and the CallKit screen stayed up for good.
      final decision = resolveCallsToEnd([_call(uuid: 'uuid-1')], 'default:abc');

      expect(decision.endAll, isFalse);
      expect(decision.calls.map((c) => c.uuid), ['uuid-1']);
    });

    test('ends the matching call and the unidentifiable one together', () {
      final decision = resolveCallsToEnd([
        _call(uuid: 'uuid-1', callCid: 'default:abc'),
        _call(uuid: 'uuid-2'),
      ], 'default:abc');

      expect(decision.endAll, isFalse);
      expect(decision.calls.map((c) => c.uuid), ['uuid-1', 'uuid-2']);
    });

    test('leaves a call that belongs to another cid alone', () {
      final decision = resolveCallsToEnd([
        _call(uuid: 'uuid-1', callCid: 'default:abc'),
        _call(uuid: 'uuid-2', callCid: 'default:xyz'),
      ], 'default:abc');

      expect(decision.endAll, isFalse);
      expect(decision.calls.map((c) => c.uuid), ['uuid-1']);
    });

    test('skips calls without a uuid, which cannot be ended', () {
      final decision = resolveCallsToEnd([
        _call(callCid: 'default:abc'),
        _call(uuid: 'uuid-2', callCid: 'default:xyz'),
      ], 'default:abc');

      expect(decision.endAll, isFalse);
      expect(decision.calls, isEmpty);
    });
  });
}
