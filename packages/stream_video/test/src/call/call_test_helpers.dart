import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/call/permissions/permissions_manager.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/session/call_session_factory.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/src/state_emitter.dart';
import 'package:stream_video/src/webrtc/sdp/policy/sdp_policy.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

final defaultCid = StreamCallCid.from(
  type: StreamCallType.defaultType(),
  id: 'test-cid',
);

const defaultCredentials = CallCredentials(
  sfuToken: 'test-token',
  iceServers: [],
  sfuServer: CallSfuServer(
    name: 'test',
    url: 'https://test.com',
    wsEndpoint: 'wss://test.com',
  ),
);

const defaultUserInfo = UserInfo(id: 'testUserId');

void registerMockFallbackValues() {
  registerFallbackValue(defaultCid);
  registerFallbackValue(createStubCall());
  registerFallbackValue(defaultCredentials);
  registerFallbackValue(CallStateNotifier(createTestCallState()));
  registerFallbackValue(
    DynascaleManager(stateManager: CallStateNotifier(createTestCallState())),
  );
  registerFallbackValue(InternetConnection());
  registerFallbackValue(
    StatsOptions(enableRtcStats: false, reportingIntervalMs: 500),
  );
  registerFallbackValue(SfuReconnectionStrategy.fast);
}

Call createStubCall({
  CoordinatorClient? coordinatorClient,
  StreamVideo? streamVideo,
  CallStateNotifier? stateManager,
  PermissionsManager? permissionManager,
  InternetConnection? networkMonitor,
  RetryPolicy? retryPolicy,
  SdpPolicy? sdpPolicy,
  RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  CallCredentials? credentials,
  CallSessionFactory? sessionFactory,
}) {
  return BaseCallFactory.makeCall(
    coordinatorClient: coordinatorClient ?? MockCoordinatorClient(),
    streamVideo: streamVideo ?? MockStreamVideo(),
    stateManager: stateManager ?? createTestCallStateManager(),
    permissionManager: permissionManager ?? MockPermissionsManager(),
    networkMonitor: networkMonitor ?? MockInternetConnection(),
    retryPolicy: retryPolicy ?? MockRetryPolicy(),
    sdpPolicy: sdpPolicy ?? const SdpPolicy(),
    rtcMediaDeviceNotifier:
        rtcMediaDeviceNotifier ?? MockRtcMediaDeviceNotifier(),
    credentials: credentials ?? defaultCredentials,
    sessionFactory: sessionFactory ?? MockSessionFactory(),
  );
}

Call createTestCall({
  CoordinatorClient? coordinatorClient,
  StreamVideo? streamVideo,
  CallStateNotifier? stateManager,
  PermissionsManager? permissionManager,
  InternetConnection? networkMonitor,
  RetryPolicy? retryPolicy,
  SdpPolicy? sdpPolicy,
  RtcMediaDeviceNotifier? rtcMediaDeviceNotifier,
  CallCredentials? credentials,
  CallSessionFactory? sessionFactory,
}) {
  return BaseCallFactory.makeCall(
    coordinatorClient: coordinatorClient ?? setupMockCoordinatorClient(),
    streamVideo: streamVideo ?? setupMockStreamVideo(),
    stateManager: stateManager ??
        CallStateNotifier(
          CallState(
            preferences: DefaultCallPreferences(),
            currentUserId: defaultUserInfo.id,
            callCid: defaultCid,
          ),
        ),
    permissionManager: permissionManager ?? MockPermissionsManager(),
    networkMonitor: networkMonitor ?? setupMockInternetConnection(),
    retryPolicy: retryPolicy ?? setupMockRetryPolicy(),
    sdpPolicy: sdpPolicy ?? const SdpPolicy(),
    rtcMediaDeviceNotifier:
        rtcMediaDeviceNotifier ?? setupMockRtcMediaDeviceNotifier(),
    credentials: credentials ?? defaultCredentials,
    sessionFactory: sessionFactory ?? setupMockSessionFactory(),
  );
}

CallState createTestCallState({
  CallPreferences? preferences,
  StreamCallCid? callCid,
  String? currentUserId,
}) {
  return CallState(
    preferences: preferences ?? DefaultCallPreferences(),
    currentUserId: currentUserId ?? 'test',
    callCid: callCid ?? defaultCid,
  );
}

MockCallStateNotifier createTestCallStateManager({
  MutableStateEmitterImpl<CallState>? callState,
}) {
  final callStateStream = callState ??
      MutableStateEmitterImpl<CallState>(createTestCallState(), sync: true);

  final stateManager = MockCallStateNotifier();

  // Setup CallStateNotifier
  when(() => stateManager.callState).thenReturn(callStateStream.value);
  when(() => stateManager.callStateStream).thenAnswer(
    (_) => callStateStream,
  );
  when(() => stateManager.validateUserId(any()))
      .thenAnswer((_) => Future.value(const Result.success(none)));
  return stateManager;
}

MockClientState setupMockClientState() {
  final userStateEmitter = MutableStateEmitterImpl<User>(
    const User(info: defaultUserInfo),
    sync: true,
  );
  final activeCallsEmitter =
      MutableStateEmitterImpl<List<Call>>([], sync: true);
  final outgoingCallEmitter = MutableStateEmitterImpl<Call?>(null, sync: true);

  final clientState = MockClientState();
  when(() => clientState.user).thenAnswer((_) => userStateEmitter);
  when(() => clientState.currentUser).thenReturn(userStateEmitter.value);
  when(() => clientState.activeCalls).thenAnswer((_) => activeCallsEmitter);
  when(() => clientState.setActiveCall(any()))
      .thenAnswer((_) => Future.value());
  when(() => clientState.removeActiveCall(any()))
      .thenAnswer((_) => Future.value());
  when(() => clientState.outgoingCall).thenAnswer((_) => outgoingCallEmitter);

  return clientState;
}

MockStreamVideo setupMockStreamVideo({ClientState? clientState}) {
  final streamVideo = MockStreamVideo();
  final effectiveClientState = clientState ?? setupMockClientState();

  when(() => streamVideo.state).thenReturn(effectiveClientState);
  when(() => streamVideo.currentUser).thenReturn(defaultUserInfo);
  when(streamVideo.isAudioProcessorConfigured).thenReturn(false);

  return streamVideo;
}

MockCoordinatorClient setupMockCoordinatorClient() {
  final coordinatorClient = MockCoordinatorClient();
  final coordinatorEventStream = MutableSharedEmitterImpl<CoordinatorEvent>();
  when(() => coordinatorClient.events).thenAnswer(
    (_) => coordinatorEventStream,
  );

  when(
    () => coordinatorClient.joinCall(
      callCid: any(named: 'callCid'),
      create: any(named: 'create'),
      migratingFrom: any(named: 'migratingFrom'),
      video: any(named: 'video'),
      membersLimit: any(named: 'membersLimit'),
    ),
  ).thenAnswer(
    (_) => Future.value(
      Result.success(
        CoordinatorJoined(
          wasCreated: true,
          members: const {},
          users: const {},
          duration: '0',
          statsOptions: StatsOptions(
            enableRtcStats: true,
            reportingIntervalMs: 5000,
          ),
          ownCapabilities: const [],
          metadata: CallMetadata(
            session: const CallSessionData(),
            users: const {},
            members: const {},
            cid: StreamCallCid.from(
              type: StreamCallType.defaultType(),
              id: 'testCallId',
            ),
            details: CallDetails(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              endedAt: DateTime.now(),
              createdBy: const CallUser(
                id: 'test-id',
                name: 'test-name',
                roles: ['test-role'],
                image: 'test-image',
              ),
              team: 'test-team',
              ownCapabilities: const [],
              blockedUserIds: const [],
              broadcasting: false,
              recording: false,
              backstage: false,
              transcribing: false,
              captioning: false,
              custom: const {},
              egress: const CallEgress(),
              rtmpIngress: '',
            ),
            settings: const CallSettings(),
          ),
          credentials: defaultCredentials,
        ),
      ),
    ),
  );

  return coordinatorClient;
}

MockInternetConnection setupMockInternetConnection({
  BehaviorSubject<InternetStatus>? statusStream,
}) {
  final internetConnection = MockInternetConnection();
  when(() => internetConnection.onStatusChange).thenAnswer(
    (_) => statusStream?.stream ?? Stream.value(InternetStatus.connected),
  );
  when(() => internetConnection.checkInterval).thenReturn(Duration.zero);
  when(() => internetConnection.internetStatus).thenAnswer(
    (_) async => statusStream?.value ?? InternetStatus.connected,
  );
  return internetConnection;
}

MockRtcMediaDeviceNotifier setupMockRtcMediaDeviceNotifier() {
  final rtcMediaDeviceNotifier = MockRtcMediaDeviceNotifier();
  when(rtcMediaDeviceNotifier.enumerateDevices)
      .thenAnswer((_) => Future.value(const Result.success([])));
  return rtcMediaDeviceNotifier;
}

MockRetryPolicy setupMockRetryPolicy() {
  final retryPolicy = MockRetryPolicy();
  when(() => retryPolicy.backoff(any())).thenReturn(Duration.zero);
  when(() => retryPolicy.config).thenReturn(const RetryConfig());
  return retryPolicy;
}

SfuCallState createTestSfuCallState() {
  return SfuCallState(
    participants: const [],
    participantCount: SfuParticipantCount(total: 0, anonymous: 0),
    startedAt: DateTime.now(),
    pins: const [],
  );
}

MockCallSession setupMockCallSession() {
  final sfuClient = MockSfuClient();

  final callSession = MockCallSession();

  when(
    () => callSession.start(
      reconnectDetails: any(named: 'reconnectDetails'),
      onRtcManagerCreatedCallback: any(named: 'onRtcManagerCreatedCallback'),
      isAnonymousUser: any(named: 'isAnonymousUser'),
    ),
  ).thenAnswer(
    (_) => Future.value(
      Result.success(
        (
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero
        ),
      ),
    ),
  );

  when(() => callSession.sfuClient).thenReturn(sfuClient);
  when(() => callSession.sessionId).thenReturn('test-session-id');
  final callSessionEvents = MutableSharedEmitterImpl<SfuEvent>();
  when(() => callSession.events).thenReturn(callSessionEvents);
  when(() => callSession.config).thenReturn(
    CallSessionConfig(
      sfuName: defaultCredentials.sfuServer.name,
      sfuUrl: defaultCredentials.sfuServer.url,
      sfuWsEndpoint: defaultCredentials.sfuServer.wsEndpoint,
      sfuToken: defaultCredentials.sfuToken,
      rtcConfig: const RTCConfiguration(),
    ),
  );

  when(
    () => callSession.getReconnectDetails(
      any(),
      migratingFromSfuId: any(named: 'migratingFromSfuId'),
      reconnectAttempts: any(named: 'reconnectAttempts'),
    ),
  ).thenAnswer((_) => Future.value(sfu_events.ReconnectDetails()));

  when(callSession.fastReconnect).thenAnswer(
    (_) => Future.value(
      Result.success(
        (
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        ),
      ),
    ),
  );

  return callSession;
}

MockSessionFactory setupMockSessionFactory({MockCallSession? callSession}) {
  final sessionFactory = MockSessionFactory();

  when(() => sessionFactory.sdpEditor).thenReturn(MockSdpEditor());
  when(
    () => sessionFactory.makeCallSession(
      sessionId: any(named: 'sessionId'),
      sessionSeq: any(named: 'sessionSeq'),
      credentials: any(named: 'credentials'),
      stateManager: any(named: 'stateManager'),
      dynascaleManager: any(named: 'dynascaleManager'),
      networkMonitor: any(named: 'networkMonitor'),
      statsOptions: any(named: 'statsOptions'),
      onReconnectionNeeded: any(named: 'onReconnectionNeeded'),
      clientPublishOptions: any(named: 'clientPublishOptions'),
    ),
  ).thenAnswer(
    (_) => Future.value(callSession ?? setupMockCallSession()),
  );

  return sessionFactory;
}
