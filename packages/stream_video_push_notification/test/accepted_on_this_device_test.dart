import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_notification.dart';

class _MockCall extends Mock implements Call {}

class _MockCallStateEmitter extends Mock implements StateEmitter<CallState> {}

Call _callWith(CallStatus status) {
  final call = _MockCall();
  final emitter = _MockCallStateEmitter();

  when(() => emitter.value).thenReturn(
    CallState(
      callCid: StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'call-id',
      ),
      currentUserId: 'current-user',
      preferences: DefaultCallPreferences(),
    ).copyWith(status: status),
  );
  // `thenAnswer`, not `thenReturn`: a StateEmitter is a Stream, which mocktail
  // refuses to hand back from `thenReturn`.
  when(() => call.state).thenAnswer((_) => emitter);

  return call;
}

void main() {
  group('isAcceptedOnThisDevice', () {
    test('accepts a call that is active on this device', () {
      expect(
        isAcceptedOnThisDevice(
          acceptedLocally: false,
          activeCall: _callWith(CallStatus.connected()),
        ),
        isTrue,
      );
    });

    test('reports another device when nothing here accepted the call', () {
      // The call was answered elsewhere: this device never sent an accept and
      // has no active call, so the CallKit UI here has to go away.
      expect(
        isAcceptedOnThisDevice(acceptedLocally: false, activeCall: null),
        isFalse,
      );
    });

    test(
      'accepts a call answered here that has not reached activeCalls yet',
      () {
        // The regression. `call.accepted` arriving before `join()` runs used to
        // look identical to an accept on another device, and the CallKit call
        // the user had just answered was ended — which on iOS releases the
        // process assertion and suspends the app mid-join.
        expect(
          isAcceptedOnThisDevice(acceptedLocally: true, activeCall: null),
          isTrue,
        );
      },
    );

    test('accepts a call answered here that is still only ringing', () {
      // Same window seen from the other side: the Call object exists and is
      // still in the ringing flow, because `join()` has not started.
      expect(
        isAcceptedOnThisDevice(
          acceptedLocally: true,
          activeCall: _callWith(CallStatus.idle()),
        ),
        isTrue,
      );
    });

    test('reports another device for a call that only ever rang here', () {
      // No local accept and the call never went active: answered elsewhere
      // while this device was still ringing.
      expect(
        isAcceptedOnThisDevice(
          acceptedLocally: false,
          activeCall: _callWith(CallStatus.idle()),
        ),
        isFalse,
      );
    });
  });
}
