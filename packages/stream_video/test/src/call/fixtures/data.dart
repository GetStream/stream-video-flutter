import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/call/call_events.dart';
import 'package:stream_video/src/call/call_type.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/models/models.dart';
import 'package:stream_video/src/webrtc/rtc_media_device/rtc_media_device.dart';

class SampleCallData {
  SampleCallData._();

  static StreamCallCid get defaultCid => StreamCallCid.from(
    type: StreamCallType.defaultType(),
    id: 'test-cid',
  );

  static CallCredentials get defaultCredentials => const CallCredentials(
    sfuToken: 'test-token',
    iceServers: [],
    sfuServer: CallSfuServer(
      name: 'test',
      url: 'https://test.com',
      wsEndpoint: 'wss://test.com',
    ),
  );

  static RtcMediaDevice get defaultMediaDevice => const RtcMediaDevice(
    id: 'fallback-device',
    label: 'Fallback Device',
    kind: RtcMediaDeviceKind.audioInput,
    groupId: 'fallback-group',
  );

  static UserInfo get defaultUserInfo => const UserInfo(id: 'testUserId');

  static CallUser get defaultCallUser => const CallUser(
    id: 'testUserId',
    name: 'test-name',
    roles: ['test-role'],
    image: 'test-image',
  );

  static CallMetadata get defaultCallMetadata => CallMetadata(
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
  );

  static CoordinatorJoined get coordinatorJoinedSuccess => CoordinatorJoined(
    wasCreated: true,
    members: const {},
    users: const {},
    duration: '0',
    statsOptions: StatsOptions(
      enableRtcStats: true,
      reportingIntervalMs: 5000,
    ),
    ownCapabilities: const [],
    metadata: defaultCallMetadata,
    credentials: defaultCredentials,
  );

  static CallReceivedOrCreatedData createCallReceivedOrCreatedData({
    Map<String, CallParticipant> participants = const {},
    Map<String, DateTime>? rejectedBy,
    Map<String, CallMember> members = const {},
    CallUser? createdByUser,
  }) => CallReceivedOrCreatedData(
    wasCreated: true,
    data: CallCreatedData(
      callCid: defaultCid,
      metadata: createCallMetadata(
        rejectedBy: rejectedBy,
        members: members,
        participants: participants,
        createdByUser: createdByUser,
      ),
    ),
  );

  static CallUser get testCallUser1 => const CallUser(
    id: 'user1',
    name: 'User One',
    roles: ['user'],
    image: 'user1-image',
  );

  static CallUser get testCallUser2 => const CallUser(
    id: 'user2',
    name: 'User Two',
    roles: ['user'],
    image: 'user2-image',
  );

  static CallUser get testCallUser3 => const CallUser(
    id: 'user3',
    name: 'User Three',
    roles: ['user'],
    image: 'user3-image',
  );

  static CallMember createCallMember({
    required String userId,
    String? name,
  }) {
    return CallMember(
      userId: userId,
      roles: const ['user'],
      custom: const <String, Object>{},
    );
  }

  static CallMetadata createCallMetadata({
    Map<String, DateTime>? rejectedBy,
    Map<String, CallMember> members = const {},
    Map<String, CallParticipant> participants = const {},
    CallUser? createdByUser,
    bool recording = false,
    bool broadcasting = false,
  }) {
    return CallMetadata(
      session: CallSessionData(
        rejectedBy: rejectedBy ?? const {},
        participants: participants,
      ),
      users: const {},
      members: members,
      cid: defaultCid,
      details: CallDetails(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        endedAt: DateTime.now(),
        createdBy:
            createdByUser ??
            const CallUser(
              id: 'creator-id',
              name: 'creator-name',
              roles: ['creator'],
              image: 'creator-image',
            ),
        team: 'test-team',
        ownCapabilities: const [],
        blockedUserIds: const [],
        broadcasting: broadcasting,
        recording: recording,
        backstage: false,
        transcribing: false,
        captioning: false,
        custom: const {},
        egress: const CallEgress(),
        rtmpIngress: '',
      ),
      settings: const CallSettings(),
    );
  }

  static StreamCallRejectedEvent createRejectedEvent({
    required StreamCallCid callCid,
    required CallUser rejectedBy,
    required CallMetadata metadata,
  }) {
    return StreamCallRejectedEvent(
      callCid,
      rejectedBy: rejectedBy,
      createdAt: DateTime.now(),
      metadata: metadata,
    );
  }

  static StreamCallClosedCaptionsEvent createClosedCaptionEvent({
    required StreamCallCid callCid,
    required String speakerId,
    required String text,
    DateTime? startTime,
    DateTime? endTime,
    CallUser? user,
  }) {
    final now = DateTime.now();
    return StreamCallClosedCaptionsEvent(
      callCid,
      createdAt: now,
      startTime: startTime ?? now,
      endTime: endTime ?? now.add(const Duration(seconds: 3)),
      speakerId: speakerId,
      text: text,
      user: user ?? testCallUser1,
      language: 'en',
      service: 'default',
      translated: false,
    );
  }
}
