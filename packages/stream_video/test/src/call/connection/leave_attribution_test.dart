import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/connection/leave_attribution.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  test('a leave for an unsupported network is the SDK giving up on ICE', () {
    final attribution = LeaveAttribution.of(
      DisconnectReason.unsupportedNetwork(),
      currentUserId: 'alice',
    );

    expect(attribution.initiator, LeaveInitiator.sdkError);
    expect(attribution.code, 'webrtc_unsupported_network');
    expect(
      attribution.abortCode,
      ClientEventStandardCode.iceConnectivityFailed,
    );
  });
}
