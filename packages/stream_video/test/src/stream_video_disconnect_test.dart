// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('StreamVideo.disconnect', () {
    late StreamVideo streamVideo;

    StreamVideo createClient({bool allowMultipleActiveCalls = false}) {
      return StreamVideo.create(
        'test-api-key',
        user: User.regular(userId: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          // Never connected: disconnect() takes the "already disconnected"
          // path, as it does after the websocket dropped.
          autoConnect: false,
          allowMultipleActiveCalls: allowMultipleActiveCalls,
        ),
      );
    }

    Call makeCall(String id) => streamVideo.makeCall(
      callType: StreamCallType.defaultType(),
      id: id,
    );

    tearDown(() async {
      await streamVideo.dispose();
    });

    test('leaves the active call', () async {
      streamVideo = createClient();
      final call = makeCall('call-1');
      await streamVideo.state.setActiveCall(call);

      await streamVideo.disconnect();

      expect(call.state.value.status.isDisconnected, isTrue);
      expect(streamVideo.activeCalls, isEmpty);
    });

    test('leaves every active call when multiple are allowed', () async {
      streamVideo = createClient(allowMultipleActiveCalls: true);
      final call1 = makeCall('call-1');
      final call2 = makeCall('call-2');
      await streamVideo.state.setActiveCall(call1);
      await streamVideo.state.setActiveCall(call2);

      await streamVideo.disconnect();

      expect(call1.state.value.status.isDisconnected, isTrue);
      expect(call2.state.value.status.isDisconnected, isTrue);
      expect(streamVideo.activeCalls, isEmpty);
    });

    test('succeeds with no active calls', () async {
      streamVideo = createClient();

      final result = await streamVideo.disconnect();

      expect(result.isSuccess, isTrue);
    });
  });
}
