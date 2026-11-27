import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

// Android names an output by its kind in both its id and its group id.
RtcMediaDevice _output(String id) => RtcMediaDevice(
  id: id,
  label: id,
  groupId: id,
  kind: RtcMediaDeviceKind.audioOutput,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelecomAudioEndpoint.fromAudioOutput', () {
    test('maps each Android output to its Telecom endpoint', () {
      expect(
        TelecomAudioEndpoint.fromAudioOutput(_output('speaker')),
        TelecomAudioEndpoint.speaker,
      );
      expect(
        TelecomAudioEndpoint.fromAudioOutput(_output('earpiece')),
        TelecomAudioEndpoint.earpiece,
      );
      expect(
        TelecomAudioEndpoint.fromAudioOutput(_output('bluetooth')),
        TelecomAudioEndpoint.bluetooth,
      );
      expect(
        TelecomAudioEndpoint.fromAudioOutput(_output('wired-headset')),
        TelecomAudioEndpoint.wiredHeadset,
      );
    });

    test('maps an output Telecom has no endpoint for to none', () {
      expect(
        TelecomAudioEndpoint.fromAudioOutput(_output('usb-headset')),
        isNull,
      );
    });

    test('sends the names the native side reads', () {
      expect(TelecomAudioEndpoint.values.map((e) => e.wireName), [
        'earpiece',
        'speaker',
        'wired_headset',
        'bluetooth',
      ]);
    });
  });

  group('TelecomAudioEndpoint.fromWireName', () {
    test('reads each name the native side sends', () {
      for (final endpoint in TelecomAudioEndpoint.values) {
        expect(TelecomAudioEndpoint.fromWireName(endpoint.wireName), endpoint);
      }
    });

    test('reads a name it does not know as none', () {
      expect(TelecomAudioEndpoint.fromWireName('unknown'), isNull);
    });
  });

  group('TelecomAudioEndpoint.toAudioOutput', () {
    test('is the Android output fromAudioOutput maps back to it', () {
      for (final endpoint in TelecomAudioEndpoint.values) {
        expect(
          TelecomAudioEndpoint.fromAudioOutput(endpoint.toAudioOutput()),
          endpoint,
        );
      }
    });

    test('is the output Android lists, with the id as its label', () {
      expect(
        TelecomAudioEndpoint.wiredHeadset.toAudioOutput(),
        _output('wired-headset'),
      );
    });

    test('is labelled with the name it is given', () {
      expect(
        TelecomAudioEndpoint.bluetooth.toAudioOutput(name: 'Car').label,
        'Car',
      );
    });
  });

  group('requestAudioEndpoint', () {
    final platform = MethodChannelStreamVideoPushNotification();
    final calls = <MethodCall>[];
    Object? answer = true;

    setUp(() {
      calls.clear();
      answer = true;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(platform.methodChannel, (call) async {
            calls.add(call);
            return answer;
          });
    });

    tearDown(() {
      CurrentPlatform.debugCurrentPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(platform.methodChannel, null);
    });

    test(
      'sends the cid and the endpoint, and answers what Android did',
      () async {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

        final routed = await platform.requestAudioEndpoint(
          'default:abc',
          TelecomAudioEndpoint.wiredHeadset,
        );

        expect(routed, isTrue);
        expect(calls.single.method, 'requestAudioEndpoint');
        expect(calls.single.arguments, {
          'cid': 'default:abc',
          'type': 'wired_headset',
        });
      },
    );

    test('sends the endpoint name when there is one', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await platform.requestAudioEndpoint(
        'default:abc',
        TelecomAudioEndpoint.bluetooth,
        name: 'Car',
      );

      expect(calls.single.arguments, {
        'cid': 'default:abc',
        'type': 'bluetooth',
        'name': 'Car',
      });
    });

    test('answers false when Android answers nothing', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      answer = null;

      final routed = await platform.requestAudioEndpoint(
        'default:abc',
        TelecomAudioEndpoint.speaker,
      );

      expect(routed, isFalse);
    });

    test('answers false off Android without asking', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

      final routed = await platform.requestAudioEndpoint(
        'default:abc',
        TelecomAudioEndpoint.speaker,
      );

      expect(routed, isFalse);
      expect(calls, isEmpty);
    });
  });
}
