import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_call_event.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

// Pins how the method channel turns what the native sides put on the event
// channel into `RingingEvent`s: the payload keys each event reads, and that
// an event name this version does not know is dropped rather than surfacing
// as an error on the stream.
//
// The call events are fed the body each platform actually sends, from the
// payloads in test/fixtures/ringing_events/ that the Kotlin and Swift tests
// check their side against.

/// The body a platform sends for a call event, from the shared fixtures.
Map<String, dynamic> _payload(String platform) {
  final file = File('test/fixtures/ringing_events/${platform}_call_event.json');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

final _androidCallBody = _payload('android');
final _iosCallBody = _payload('ios');

Map<String, dynamic> _message(Event event, Map<String, dynamic> body) => {
  'event': event.wireName,
  'body': body,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelStreamVideoPushNotification platform;

  /// Replays [messages] on the event channel, then closes it, and returns
  /// whatever the platform's `onEvent` stream produced.
  Future<List<RingingEvent?>> receive(List<Object?> messages) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          platform.eventChannel,
          MockStreamHandler.inline(
            onListen: (arguments, events) {
              messages.forEach(events.success);
              events.endOfStream();
            },
          ),
        );
    return platform.onEvent.toList();
  }

  setUp(() {
    platform = MethodChannelStreamVideoPushNotification();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(platform.eventChannel, null);
  });

  group('unreadable messages', () {
    test('a message that is not a map is ignored', () async {
      final events = await receive([
        'not a map',
        _message(Event.actionCallAccept, _iosCallBody),
      ]);

      expect(events, [isNull, isA<ActionCallAccept>()]);
    });
  });

  group('call events carry the call data', () {
    const callEvents = {
      Event.actionCallIncoming: ActionCallIncoming,
      Event.actionCallStart: ActionCallStart,
      Event.actionCallAccept: ActionCallAccept,
      Event.actionCallDecline: ActionCallDecline,
      Event.actionCallEnded: ActionCallEnded,
      Event.actionCallTimeout: ActionCallTimeout,
      Event.actionCallCallback: ActionCallCallback,
      Event.actionCallConnected: ActionCallConnected,
    };

    /// The single call event [body] decodes to as [event], and its data.
    Future<CallData> callDataOf(Event event, Map<String, dynamic> body) async {
      final events = await receive([_message(event, body)]);

      final received = events.single!;
      expect(received.runtimeType, callEvents[event]);
      return switch (received) {
        ActionCallIncoming(:final data) => data,
        ActionCallStart(:final data) => data,
        ActionCallAccept(:final data) => data,
        ActionCallDecline(:final data) => data,
        ActionCallEnded(:final data) => data,
        ActionCallTimeout(:final data) => data,
        ActionCallCallback(:final data) => data,
        ActionCallConnected(:final data) => data,
        _ => fail('unexpected event $received'),
      };
    }

    for (final event in callEvents.keys) {
      test('${event.name} from iOS becomes ${callEvents[event]}', () async {
        final data = await callDataOf(event, _iosCallBody);

        expect(data.uuid, 'call-uuid');
        expect(data.callCid, 'default:ada');
        expect(data.callerName, 'Ada');
        expect(data.handle, 'ada');
        expect(data.hasVideo, isTrue);
        expect(data.isAccepted, isFalse);
        expect(data.endedBySystem, isFalse);
        expect(data.extraData, {'callCid': 'default:ada'});
      });

      test('${event.name} from Android becomes ${callEvents[event]}', () async {
        final data = await callDataOf(event, _androidCallBody);

        expect(data.uuid, 'call-uuid');
        expect(data.callCid, 'default:ada');
        expect(data.callerName, 'Ada');
        // Current behaviour, pinned: Android sends the handle as `number`
        // and no `isAccepted`, neither of which is read here.
        expect(data.handle, isNull);
        expect(data.isAccepted, isFalse);
        expect(data.hasVideo, isTrue);
        expect(data.endedBySystem, isFalse);
        expect(data.extraData, {'callCid': 'default:ada'});
      });
    }

    test('an end reported by the Android system call UI', () async {
      final data = await callDataOf(Event.actionCallEnded, {
        ..._androidCallBody,
        'endedBySystem': true,
      });

      expect(data.endedBySystem, isTrue);
    });

    test('a call iOS reports as accepted', () async {
      final data = await callDataOf(Event.actionCallAccept, {
        ..._iosCallBody,
        'isAccepted': true,
      });

      expect(data.isAccepted, isTrue);
    });

    test('missing optional fields fall back to their defaults', () async {
      final data = await callDataOf(Event.actionCallIncoming, {
        'id': 'call-uuid',
        'type': 0,
      });

      expect(data.uuid, 'call-uuid');
      expect(data.callCid, isNull);
      expect(data.hasVideo, isFalse);
      expect(data.isAccepted, isFalse);
      expect(data.endedBySystem, isFalse);
    });
  });

  group('the other events read their own keys', () {
    test('incoming failed', () async {
      final events = await receive([
        _message(Event.actionCallIncomingFailed, {
          ..._iosCallBody,
          'errorCode': 'filteredByDoNotDisturb',
          'error': 'Do Not Disturb',
        }),
      ]);

      final event = events.single! as ActionCallIncomingFailed;
      expect(event.data.uuid, 'call-uuid');
      expect(event.reason, IncomingCallFailureReason.filteredByDoNotDisturb);
      expect(event.error, 'Do Not Disturb');
    });

    test('VoIP token update', () async {
      final events = await receive([
        _message(Event.actionDidUpdateDevicePushTokenVoip, {
          'deviceTokenVoIP': 'abc123',
        }),
      ]);

      final event = events.single! as ActionDidUpdateDevicePushTokenVoip;
      expect(event.token, 'abc123');
    });

    test('hold', () async {
      final events = await receive([
        _message(Event.actionCallToggleHold, {
          'id': 'call-uuid',
          'isOnHold': true,
        }),
      ]);

      final event = events.single! as ActionCallToggleHold;
      expect(event.uuid, 'call-uuid');
      expect(event.isOnHold, isTrue);
    });

    test('mute', () async {
      final events = await receive([
        _message(Event.actionCallToggleMute, {
          'id': 'call-uuid',
          'isMuted': false,
        }),
      ]);

      final event = events.single! as ActionCallToggleMute;
      expect(event.uuid, 'call-uuid');
      expect(event.isMuted, isFalse);
    });

    test('DTMF', () async {
      final events = await receive([
        _message(Event.actionCallToggleDtmf, {
          'id': 'call-uuid',
          'digits': '12#',
          'type': 0,
        }),
      ]);

      final event = events.single! as ActionCallToggleDtmf;
      expect(event.uuid, 'call-uuid');
      expect(event.digits, '12#');
    });

    test('group', () async {
      final events = await receive([
        _message(Event.actionCallToggleGroup, {
          'id': 'call-uuid',
          'callUUIDToGroupWith': 'other-uuid',
        }),
      ]);

      // ignore: deprecated_member_use
      final event = events.single! as ActionCallToggleGroup;
      expect(event.uuid, 'call-uuid');
      expect(event.callUUIDToGroupWith, 'other-uuid');
    });

    test('audio session', () async {
      final events = await receive([
        _message(Event.actionCallToggleAudioSession, {'isActive': true}),
      ]);

      final event = events.single! as ActionCallToggleAudioSession;
      expect(event.isActive, isTrue);
    });

    test('custom keeps the whole body', () async {
      final events = await receive([
        _message(Event.actionCallCustom, {
          'id': 'call-uuid',
          'type': 'telecomAudioEndpointsChanged',
          'audio': {'currentEndpoint': 'speaker'},
        }),
      ]);

      final event = events.single! as ActionCallCustom;
      expect(event.body!['type'], 'telecomAudioEndpointsChanged');
      expect(event.body!['audio'], {'currentEndpoint': 'speaker'});
    });
  });
}
