import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_call_event.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelStreamVideoPushNotification();

  /// Replays [messages] on the event channel, then closes it, and returns
  /// whatever the platform's `onEvent` stream produced.
  Future<List<RingingEvent?>> receive(List<Object?> messages) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          platform.eventChannel,
          MockStreamHandler.inline(
            onListen: (_, sink) {
              messages.forEach(sink.success);
              sink.endOfStream();
            },
          ),
        );
    return platform.onEvent.toList();
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(platform.eventChannel, null);
  });

  test('an unknown event is dropped and the next one still arrives', () async {
    final events = await receive([
      {
        'event': 'io.getstream.video.ACTION_FROM_A_NEWER_PLUGIN',
        'body': <String, Object?>{},
      },
      {
        'event': Event.actionCallAccept.name,
        'body': {
          'id': 'call-uuid',
          'extra': {'callCid': 'default:ada'},
        },
      },
    ]);

    // The unknown one arrives as null, which the push manager filters out;
    // the stream is not closed by an error.
    expect(events, [isNull, isA<ActionCallAccept>()]);
  });
}
