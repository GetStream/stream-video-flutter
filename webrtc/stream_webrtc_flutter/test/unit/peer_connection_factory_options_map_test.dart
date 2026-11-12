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

  test('Android gets the Android configuration only', () {
    expect(
      peerConnectionFactoryOptionsMap(
        options,
        isAndroid: true,
        isApple: false,
      ),
      {
        'bypassVoiceProcessing': true,
        'androidAudioConfiguration': android.toMap(),
      },
    );
  });

  test('iOS and macOS get the Apple configuration only', () {
    expect(
      peerConnectionFactoryOptionsMap(
        options,
        isAndroid: false,
        isApple: true,
      ),
      {
        'bypassVoiceProcessing': true,
        'appleAudioConfiguration': apple.toMap(),
      },
    );
  });

  test('other platforms get the voice processing flag only', () {
    expect(
      peerConnectionFactoryOptionsMap(
        options,
        isAndroid: false,
        isApple: false,
      ),
      {'bypassVoiceProcessing': true},
    );
  });

  test('a configuration that is not set is left out', () {
    expect(
      peerConnectionFactoryOptionsMap(
        const PeerConnectionFactoryOptions(),
        isAndroid: true,
        isApple: true,
      ),
      {'bypassVoiceProcessing': false},
    );
  });
}
