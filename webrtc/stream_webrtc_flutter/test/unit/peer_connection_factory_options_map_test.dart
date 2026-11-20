import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/peer_connection_factory_options_map.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  final android = AndroidAudioConfiguration.communication;
  final apple = AppleAudioConfiguration(
    appleAudioCategory: AppleAudioCategory.playAndRecord,
    appleAudioMode: AppleAudioMode.voiceChat,
  );
  final options = PeerConnectionFactoryOptions(
    bypassVoiceProcessing: true,
    androidAudioConfiguration: android,
    appleAudioConfiguration: apple,
  );

  group('peerConnectionFactoryOptionsMap', () {
    test('carries both platform configurations', () {
      expect(peerConnectionFactoryOptionsMap(options), {
        'bypassVoiceProcessing': true,
        'androidAudioConfiguration': android.toMap(),
        'appleAudioConfiguration': apple.toMap(),
      });
    });

    test('leaves out a configuration that is not set', () {
      expect(
        peerConnectionFactoryOptionsMap(const PeerConnectionFactoryOptions()),
        {'bypassVoiceProcessing': false},
      );
    });
  });

  group('over the method channel', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    const channel = MethodChannel('FlutterWebRTC.Method');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final calls = <MethodCall>[];

    setUp(() {
      calls.clear();
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return switch (call.method) {
          'createPeerConnectionFactory' => {'factoryId': 'factory-1'},
          _ => null,
        };
      });
    });

    tearDown(() => messenger.setMockMethodCallHandler(channel, null));

    Map<Object?, Object?> optionsOf(String method) {
      final call = calls.lastWhere((call) => call.method == method);
      return (call.arguments as Map)['options'] as Map<Object?, Object?>;
    }

    test('NativePeerConnectionFactory.create sends the options', () async {
      await NativePeerConnectionFactory.create(options: options);

      expect(
        optionsOf('createPeerConnectionFactory'),
        peerConnectionFactoryOptionsMap(options),
      );
    });

    test('NativePeerConnectionFactory.create defaults to voice processing '
        'on', () async {
      await NativePeerConnectionFactory.create();

      expect(optionsOf('createPeerConnectionFactory'), {
        'bypassVoiceProcessing': false,
      });
    });

    test('WebRTC.initialize adds the factory options to the other '
        'options', () async {
      await WebRTC.initialize(
        refresh: true,
        options: {'forceSWCodec': true, 'bypassVoiceProcessing': false},
        factoryOptions: PeerConnectionFactoryOptions(
          bypassVoiceProcessing: true,
          androidAudioConfiguration: android,
        ),
      );

      expect(optionsOf('initialize'), {
        'forceSWCodec': true,
        'bypassVoiceProcessing': true,
        'androidAudioConfiguration': android.toMap(),
      });
    });

    test('WebRTC.initialize without factory options sends the options '
        'unchanged', () async {
      await WebRTC.initialize(refresh: true, options: {'forceSWCodec': true});

      expect(optionsOf('initialize'), {'forceSWCodec': true});
    });
  });
}
