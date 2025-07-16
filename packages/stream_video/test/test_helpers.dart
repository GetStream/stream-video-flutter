import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/permissions/permissions_manager.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_factory.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:stream_video/src/webrtc/sdp/editor/sdp_editor.dart';
import 'package:stream_video/stream_video.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockCoordinatorClient extends Mock implements CoordinatorClient {}

class MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}

class MockStreamVideo extends Mock implements StreamVideo {}

class MockCallStateNotifier extends Mock implements CallStateNotifier {}

class MockPermissionsManager extends Mock implements PermissionsManager {}

class MockInternetConnection extends Mock implements InternetConnection {}

class MockRetryPolicy extends Mock implements RetryPolicy {}

class MockSessionFactory extends Mock implements CallSessionFactory {}

class MockDynascaleManager extends Mock implements DynascaleManager {}

class MockSdpEditor extends Mock implements SdpEditor {}

class MockTracer extends Mock implements Tracer {}

class MockCallSession extends Mock implements CallSession {}

class MockSfuClient extends Mock implements SfuClient {}

class MockClientState extends Mock implements ClientState {}

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

class MockRtcLocalTrack extends Mock implements RtcLocalTrack {}

/// Helper function to create CallDetails for testing
CallDetails createTestCallDetails({
  required String createdByUserId,
  String createdByName = 'Test User',
  String team = '',
  List<CallPermission> ownCapabilities = const [],
  List<String> blockedUserIds = const [],
  bool broadcasting = false,
  bool recording = false,
  bool backstage = false,
  bool transcribing = false,
  bool captioning = false,
  CallEgress egress = const CallEgress(),
  Map<String, Object> custom = const {},
  String rtmpIngress = '',
}) {
  return CallDetails(
    createdBy: CallUser(
      id: createdByUserId,
      name: createdByName,
      roles: const [],
      image: '',
    ),
    team: team,
    ownCapabilities: ownCapabilities,
    blockedUserIds: blockedUserIds,
    broadcasting: broadcasting,
    recording: recording,
    backstage: backstage,
    transcribing: transcribing,
    captioning: captioning,
    egress: egress,
    custom: custom,
    rtmpIngress: rtmpIngress,
  );
}

/// Helper function to create a Call with mocked coordinator client response
Call createCallWithMockedResponse(
  StreamVideo streamVideo,
  MockCoordinatorClient mockCoordinatorClient,
  CallSettings callSettings, {
  required MockRtcMediaDeviceNotifier rtcMediaDeviceNotifier,
}) {
  // Create call metadata with the desired settings
  final callCid = StreamCallCid.from(
    type: StreamCallType.defaultType(),
    id: 'test-call',
  );

  final callMetadata = CallMetadata(
    cid: callCid,
    details: createTestCallDetails(createdByUserId: 'test-user'),
    settings: callSettings,
    session: const CallSessionData(),
    users: const {},
    members: const {},
  );

  final callCreatedData = CallCreatedData(
    callCid: callCid,
    metadata: callMetadata,
  );

  final responseData = CallReceivedOrCreatedData(
    wasCreated: true,
    data: callCreatedData,
  );

  // Mock the getOrCreateCall method to return our test data
  when(
    () => mockCoordinatorClient.getOrCreateCall(
      callCid: any(named: 'callCid'),
      ringing: any(named: 'ringing'),
      members: any(named: 'members'),
      team: any(named: 'team'),
      notify: any(named: 'notify'),
      video: any(named: 'video'),
      startsAt: any(named: 'startsAt'),
      membersLimit: any(named: 'membersLimit'),
      settingsOverride: any(named: 'settingsOverride'),
      custom: any(named: 'custom'),
    ),
  ).thenAnswer((_) async => Result.success(responseData));

  // Create a call instance with the mocked coordinator client
  return Call(
    callCid: callCid,
    coordinatorClient: mockCoordinatorClient,
    streamVideo: streamVideo,
    networkMonitor: InternetConnection.createInstance(),
    rtcMediaDeviceNotifier: rtcMediaDeviceNotifier,
  );
}

/// Pre-defined device lists for testing different scenarios
mixin TestDeviceScenarios {
  /// Built-in devices only (no external devices)
  static List<RtcMediaDevice> get builtInDevicesOnly => [
        const RtcMediaDevice(
          id: 'built-in-mic',
          label: 'Built-in Microphone',
          kind: RtcMediaDeviceKind.audioInput,
          groupId: 'builtin-group',
        ),
        const RtcMediaDevice(
          id: 'speaker',
          label: 'Speaker',
          kind: RtcMediaDeviceKind.audioOutput,
          groupId: 'builtin-group',
        ),
        const RtcMediaDevice(
          id: 'earpiece',
          label: 'Earpiece',
          kind: RtcMediaDeviceKind.audioOutput,
          groupId: 'builtin-group',
        ),
        const RtcMediaDevice(
          id: 'front-camera',
          label: 'Front Camera',
          kind: RtcMediaDeviceKind.videoInput,
          groupId: 'builtin-group',
        ),
        const RtcMediaDevice(
          id: 'back-camera',
          label: 'Back Camera',
          kind: RtcMediaDeviceKind.videoInput,
          groupId: 'builtin-group',
        ),
      ];

  /// Devices with Bluetooth headphones connected
  static List<RtcMediaDevice> get withBluetoothHeadphones => [
        ...builtInDevicesOnly,
        const RtcMediaDevice(
          id: 'bluetooth-headphones',
          label: 'Bluetooth Headphones',
          kind: RtcMediaDeviceKind.audioOutput,
          groupId: 'bluetoothA2DP',
        ),
        const RtcMediaDevice(
          id: 'bluetooth-headphones-mic',
          label: 'Bluetooth Headphones Microphone',
          kind: RtcMediaDeviceKind.audioInput,
          groupId: 'bluetoothA2DP',
        ),
      ];

  /// Devices with external webcam
  static List<RtcMediaDevice> get withExternalWebcam => [
        ...builtInDevicesOnly,
        const RtcMediaDevice(
          id: 'external-webcam',
          label: 'USB Camera',
          kind: RtcMediaDeviceKind.videoInput,
          groupId: 'usb-group',
        ),
      ];
}
