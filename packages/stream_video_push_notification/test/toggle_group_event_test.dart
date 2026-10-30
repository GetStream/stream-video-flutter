import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_call_event.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelStreamVideoPushNotification();

  Future<RingingEvent?> decode(Map<String, Object?> body) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          platform.eventChannel,
          MockStreamHandler.inline(
            onListen: (_, sink) => sink.success({
              'event': Event.actionCallToggleGroup.name,
              'body': body,
            }),
          ),
        );
    return platform.onEvent.first;
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(platform.eventChannel, null);
  });

  test('decodes a group event with the call to group with', () async {
    final event = await decode({
      'id': 'call-1',
      'callUUIDToGroupWith': 'call-2',
    });

    expect(
      event,
      const ActionCallToggleGroup(
        uuid: 'call-1',
        callUUIDToGroupWith: 'call-2',
      ),
    );
  });

  test('decodes an ungroup event, which has no call to group with', () async {
    // CallKit sends a nil uuid to group with when a call is ungrouped.
    final event = await decode({'id': 'call-1', 'callUUIDToGroupWith': null});

    expect(
      event,
      const ActionCallToggleGroup(uuid: 'call-1', callUUIDToGroupWith: null),
    );
  });
}
