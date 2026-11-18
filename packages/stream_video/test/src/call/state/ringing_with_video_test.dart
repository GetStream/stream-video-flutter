import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

void main() {
  late CallStateNotifier notifier;

  setUp(() {
    notifier = CallStateNotifier(
      CallState(
        currentUserId: 'user',
        callCid: SampleCallData.defaultCid,
        preferences: DefaultCallPreferences(),
      ),
    );
  });

  CallCreatedData created() => CallCreatedData(
    callCid: SampleCallData.defaultCid,
    metadata: SampleCallData.createCallMetadata(),
  );

  CallReceivedData received() => CallReceivedData(
    callCid: SampleCallData.defaultCid,
    metadata: SampleCallData.createCallMetadata(),
  );

  test('a new call is not ringing with video', () {
    expect(notifier.state.isRingingWithVideo, isFalse);
  });

  test("a call created ringing takes the ring's video flag", () {
    notifier.updateFromCallCreatedData(
      created(),
      ringing: true,
      video: true,
      callConnectOptions: const CallConnectOptions(),
    );

    expect(notifier.state.isRingingWithVideo, isTrue);
  });

  test("a call fetched ringing takes the ring's video flag", () {
    notifier.updateFromCallReceivedData(received(), ringing: true, video: true);
    expect(notifier.state.isRingingWithVideo, isTrue);

    notifier.updateFromCallReceivedData(received(), ringing: true);
    expect(notifier.state.isRingingWithVideo, isFalse);
  });

  test("fetching the call without ringing keeps the ring's video flag", () {
    notifier
      ..updateFromCallCreatedData(
        created(),
        ringing: true,
        video: true,
        callConnectOptions: const CallConnectOptions(),
      )
      ..updateFromCallReceivedData(received());

    expect(notifier.state.isRingingWithVideo, isTrue);
  });
}
