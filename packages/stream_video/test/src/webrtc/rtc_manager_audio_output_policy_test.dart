import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/state_emitter.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockStreamPeerConnectionFactory extends Mock
    implements StreamPeerConnectionFactory {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  RtcManager createManager({
    required AudioConfigurationPolicy? callPolicy,
    AudioConfigurationPolicy? clientPolicy,
  }) {
    final streamVideo = MockStreamVideo();
    when(() => streamVideo.options).thenReturn(
      StreamVideoOptions(
        clientEventsReportingEnabled: false,
        audioConfigurationPolicy: clientPolicy,
      ),
    );

    return RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: null,
      subscriber: _MockTracedPeerConnection(),
      publishOptions: [],
      stateManager: createTestCallStateManager(
        callState: MutableStateEmitterImpl<CallState>(
          createTestCallState(
            preferences: DefaultCallPreferences(
              audioConfigurationPolicy: callPolicy,
            ),
          ),
          sync: true,
        ),
      ),
      streamVideo: streamVideo,
      pcFactory: _MockStreamPeerConnectionFactory(),
    );
  }

  // `setAudioOutputDevice` applies this policy to the iOS audio session. The
  // session call itself is gated on the host platform inside the WebRTC
  // plugin, so the policy it is given is checked here instead.
  group('RtcManager.effectiveAudioConfigurationPolicy', () {
    test("is the call's own policy when it has one", () {
      final manager = createManager(
        callPolicy: const AudioConfigurationPolicy.hiFi(),
        clientPolicy: const AudioConfigurationPolicy.broadcaster(),
      );

      expect(manager.effectiveAudioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });

    test('falls back to the client policy when the call has none', () {
      final manager = createManager(
        callPolicy: null,
        clientPolicy: const AudioConfigurationPolicy.viewer(),
      );

      expect(
        manager.effectiveAudioConfigurationPolicy,
        isA<ViewerAudioPolicy>(),
      );
    });
  });
}
