import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelStreamVideoPushNotification();

  /// Answers `activeCalls` with [reply].
  void replyWith(Object? reply) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (call) async {
          expect(call.method, 'activeCalls');
          return reply;
        });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('no reply is no calls', () async {
    replyWith(null);

    expect(await platform.activeCalls(), isEmpty);
  });

  test('each entry becomes a call', () async {
    replyWith([
      {
        'id': 'video-call',
        'callerName': 'Ada',
        'handle': 'ada',
        'type': 1,
        'isAccepted': true,
        'endedBySystem': true,
        'extra': {'callCid': 'default:video'},
      },
      {'id': 'audio-call', 'type': 0},
    ]);

    final calls = await platform.activeCalls();

    expect(calls, hasLength(2));
    expect(calls[0].uuid, 'video-call');
    expect(calls[0].callCid, 'default:video');
    expect(calls[0].callerName, 'Ada');
    expect(calls[0].handle, 'ada');
    expect(calls[0].hasVideo, isTrue);
    expect(calls[0].isAccepted, isTrue);
    expect(calls[0].endedBySystem, isTrue);
    expect(calls[1].uuid, 'audio-call');
    expect(calls[1].hasVideo, isFalse);
  });

  test('a missing accepted or ended-by-system flag is false', () async {
    replyWith([
      {'id': 'call'},
    ]);

    final call = (await platform.activeCalls()).single;

    expect(call.isAccepted, isFalse);
    expect(call.endedBySystem, isFalse);
    expect(call.hasVideo, isFalse);
    expect(call.callCid, isNull);
  });

  test('an entry it cannot read is skipped and the others are kept', () async {
    replyWith([
      {'id': 'first'},
      {'id': 42},
      'not a map',
      {'id': 'last'},
    ]);

    final calls = await platform.activeCalls();

    expect(calls.map((call) => call.uuid), ['first', 'last']);
  });
}
