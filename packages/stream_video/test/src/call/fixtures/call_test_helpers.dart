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
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/src/models/call_member_state.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/src/state_emitter.dart';
import 'package:stream_video/src/webrtc/sdp/policy/sdp_policy.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import 'data.dart';

void registerMockFallbackValues() {
  registerFallbackValue(SampleCallData.defaultCid);
  registerFallbackValue(createStubCall());
  registerFallbackValue(SampleCallData.defaultCredentials);
  registerFallbackValue(CallStateNotifier(createTestCallState()));
  registerFallbackValue(
    DynascaleManager(stateManager: CallStateNotifier(createTestCallState())),
  );
  registerFallbackValue(InternetConnection());
  registerFallbackValue(
    StatsOptions(enableRtcStats: false, reportingIntervalMs: 500),
  );
  registerFallbackValue(SfuReconnectionStrategy.fast);
  registerFallbackValue(SampleCallData.defaultMediaDevice);
  registerFallbackValue(MockStreamVideo());
  registerFallbackValue(sfu_events.ReconnectDetails());
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
    credentials: credentials ?? SampleCallData.defaultCredentials,
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
    stateManager:
        stateManager ??
        CallStateNotifier(
          CallState(
            preferences: DefaultCallPreferences(),
            currentUserId: SampleCallData.defaultUserInfo.id,
            callCid: SampleCallData.defaultCid,
          ),
        ),
    permissionManager: permissionManager ?? MockPermissionsManager(),
    networkMonitor: networkMonitor ?? setupMockInternetConnection(),
    retryPolicy: retryPolicy ?? setupMockRetryPolicy(),
    sdpPolicy: sdpPolicy ?? const SdpPolicy(),
    rtcMediaDeviceNotifier:
        rtcMediaDeviceNotifier ?? setupMockRtcMediaDeviceNotifier(),
    credentials: credentials ?? SampleCallData.defaultCredentials,
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
    callCid: callCid ?? SampleCallData.defaultCid,
  );
}

MockCallStateNotifier createTestCallStateManager({
  MutableStateEmitterImpl<CallState>? callState,
}) {
  final callStateStream =
      callState ??
      MutableStateEmitterImpl<CallState>(createTestCallState(), sync: true);

  final stateManager = MockCallStateNotifier();

  // Setup CallStateNotifier
  when(() => stateManager.callState).thenReturn(callStateStream.value);
  when(() => stateManager.callStateStream).thenAnswer(
    (_) => callStateStream,
  );
  when(
    () => stateManager.validateUserId(any()),
  ).thenAnswer((_) => Future.value(const Result.success(none)));
  return stateManager;
}

MockClientState setupMockClientState() {
  final userStateEmitter = MutableStateEmitterImpl<User>(
    User(info: SampleCallData.defaultUserInfo),
    sync: true,
  );
  final activeCallsEmitter = MutableStateEmitterImpl<List<Call>>(
    [],
    sync: true,
  );
  final outgoingCallEmitter = MutableStateEmitterImpl<Call?>(null, sync: true);

  final clientState = MockClientState();
  when(() => clientState.user).thenAnswer((_) => userStateEmitter);
  when(() => clientState.currentUser).thenReturn(userStateEmitter.value);
  when(() => clientState.activeCalls).thenAnswer((_) => activeCallsEmitter);
  when(
    () => clientState.setActiveCall(any()),
  ).thenAnswer((_) => Future.value());
  when(
    () => clientState.removeActiveCall(any()),
  ).thenAnswer((_) => Future.value());
  when(() => clientState.outgoingCall).thenAnswer((_) => outgoingCallEmitter);

  return clientState;
}

MockStreamVideo setupMockStreamVideo({ClientState? clientState}) {
  final streamVideo = MockStreamVideo();
  final effectiveClientState = clientState ?? setupMockClientState();

  when(() => streamVideo.state).thenReturn(effectiveClientState);
  when(() => streamVideo.options).thenReturn(const StreamVideoOptions());
  when(
    () => streamVideo.currentUser,
  ).thenReturn(SampleCallData.defaultUserInfo);
  when(streamVideo.isAudioProcessorConfigured).thenReturn(false);

  return streamVideo;
}

MockCoordinatorClient setupMockCoordinatorClient({
  SharedEmitter<CoordinatorEvent>? events,
  CallReceivedOrCreatedData? getOrCreateCallResult,
}) {
  final coordinatorClient = MockCoordinatorClient();
  final coordinatorEventStream =
      events ?? MutableSharedEmitterImpl<CoordinatorEvent>();
  when(() => coordinatorClient.events).thenAnswer(
    (_) => coordinatorEventStream,
  );

  when(
    () => coordinatorClient.getOrCreateCall(
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
  ).thenAnswer(
    (_) => Future.value(
      Result.success(
        getOrCreateCallResult ??
            SampleCallData.createCallReceivedOrCreatedData(),
      ),
    ),
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
        SampleCallData.coordinatorJoinedSuccess,
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
  when(
    rtcMediaDeviceNotifier.enumerateDevices,
  ).thenAnswer((_) => Future.value(const Result.success([])));
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
      capabilities: any(named: 'capabilities'),
      unifiedSessionId: any(named: 'unifiedSessionId'),
    ),
  ).thenAnswer(
    (_) => Future.value(
      Result.success(
        (
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
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
      sfuName: SampleCallData.defaultCredentials.sfuServer.name,
      sfuUrl: SampleCallData.defaultCredentials.sfuServer.url,
      sfuWsEndpoint: SampleCallData.defaultCredentials.sfuServer.wsEndpoint,
      sfuToken: SampleCallData.defaultCredentials.sfuToken,
      rtcConfig: const RTCConfiguration(),
    ),
  );
  when(
    callSession.getTrace,
  ).thenReturn(
    [
      TraceSlice(
        snapshot: [],
        rollback: () {},
      ),
    ],
  );

  when(
    () => callSession.getReconnectDetails(
      any(),
      migratingFromSfuId: any(named: 'migratingFromSfuId'),
      reconnectAttempts: any(named: 'reconnectAttempts'),
      reason: any(named: 'reason'),
    ),
  ).thenAnswer((_) => Future.value(sfu_events.ReconnectDetails()));

  when(
    () => callSession.fastReconnect(
      reconnectDetails: any(named: 'reconnectDetails'),
      capabilities: any(named: 'capabilities'),
      unifiedSessionId: any(named: 'unifiedSessionId'),
    ),
  ).thenAnswer(
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
      streamVideo: any(named: 'streamVideo'),
    ),
  ).thenAnswer(
    (_) => Future.value(callSession ?? setupMockCallSession()),
  );

  return sessionFactory;
}

Call createTestCallWithState({
  required CallState initialState,
  CoordinatorClient? coordinatorClient,
  StreamVideo? streamVideo,
}) {
  final stateManager = CallStateNotifier(initialState);

  final call = createTestCall(
    coordinatorClient: coordinatorClient,
    streamVideo: streamVideo,
    stateManager: stateManager,
  );

  return call;
}

CallState createActiveCallState({
  CallUser? currentByUser,
  List<CallMemberState>? members,
  CallStatus? status,
}) {
  final createdBy = currentByUser ?? SampleCallData.defaultCallUser;
  final baseState = CallState(
    preferences: DefaultCallPreferences(),
    currentUserId: createdBy.id,
    callCid: SampleCallData.defaultCid,
  );

  return baseState.copyWith(
    callMembers: members,
    status: status ?? CallStatus.connected(),
    createdByUser: createdBy,
    sessionId: 'test-session-id',
  );
}
