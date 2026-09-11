// ignore_for_file: avoid_implementing_value_types

import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class MockCall extends Mock implements Call {}

class MockCallState extends Mock implements CallState {}

class MockCallParticipantState extends Mock implements CallParticipantState {
  MockCallParticipantState() {
    // Whether the SFU has paused a track is asked of every participant the
    // tile draws, but it is an inbound-bandwidth state almost no test is
    // about. Default it to "not paused" so only the tests that exercise
    // pausing have to say anything; `when` in a test still overrides this.
    // The tile reads this to notice a recycled element pointing at somebody
    // new. Tests about that override it; the rest just need it non-null.
    when(() => sessionId).thenReturn('session');

    for (final trackType in [
      SfuTrackType.video,
      SfuTrackType.audio,
      SfuTrackType.screenShare,
      SfuTrackType.screenShareAudio,
      SfuTrackType.unspecified,
    ]) {
      when(() => isTrackPaused(trackType)).thenReturn(false);
    }
  }
}

class MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}

class MockStreamVideo extends Mock implements StreamVideo {
  // StreamVideo marks dispose as @mustBeOverridden.
  @override
  Future<Result<None>> dispose() async => const Result.success(none);
}

class MockCallCreatedData extends Mock implements CallCreatedData {}

class MockCallMetadata extends Mock implements CallMetadata {}

class MockCallSettings extends Mock implements CallSettings {}

class MockRtcLocalAudioTrack extends Mock implements RtcLocalAudioTrack {}

class MockRtcLocalVideoTrack extends Mock implements RtcLocalVideoTrack {}

class MockRtcLocalCameraTrack extends Mock implements RtcLocalCameraTrack {}

/// Stubs what [StreamLobbyController] reads off a call: the state it takes its
/// defaults and the local user id from, the user it draws the preview for, and
/// the events it follows while nobody has joined yet.
///
/// Returns the emitter behind [Call.callEvents], so a test can make someone
/// arrive or leave.
MutableSharedEmitter<StreamCallEvent> stubLobbyCall(
  MockCall call,
  MockCallState state, {
  UserInfo currentUser = const UserInfo(id: 'local'),
  StreamCallCid? callCid,
}) {
  final events = MutableSharedEmitter<StreamCallEvent>(sync: true);

  when(() => state.currentUserId).thenReturn(currentUser.id);
  when(() => call.currentUser).thenReturn(currentUser);
  when(
    () => call.callCid,
  ).thenReturn(callCid ?? StreamCallCid(cid: 'default:lobby'));
  when(() => call.callEvents).thenAnswer((_) => events);
  when(() => call.state).thenAnswer(
    (_) => MutableStateEmitter<CallState>(state, sync: true),
  );

  return events;
}

/// Stubs what the ringing screens read off a call: the members being rung, the
/// microphone and camera the call would be placed with, and the state stream
/// [PartialCallStateBuilder] follows.
///
/// [MockCallState.ringingMembers] is a getter over `callMembers`, which a mock
/// does not compute — it is stubbed directly instead.
void stubRingingCall(
  MockCall call,
  MockCallState state, {
  List<CallMemberState> ringingMembers = const [],
  CallConnectOptions connectOptions = const CallConnectOptions(),
  CallStatus? status,
  UserInfo currentUser = const UserInfo(id: 'local'),
}) {
  when(() => state.currentUserId).thenReturn(currentUser.id);
  when(() => state.ringingMembers).thenReturn(ringingMembers);
  when(() => state.status).thenReturn(status ?? CallStatus.idle());
  when(() => call.currentUser).thenReturn(currentUser);
  when(() => call.callCid).thenReturn(StreamCallCid(cid: 'default:ringing'));
  when(() => call.connectOptions).thenReturn(connectOptions);
  when(() => call.state).thenAnswer(
    (_) => MutableStateEmitter<CallState>(state, sync: true),
  );
  // Runs the real selector against the stubbed state, so a screen selecting
  // something other than the ringing members still gets what it asked for.
  when(() => call.partialState<List<UserInfo>>(any())).thenAnswer((invocation) {
    final selector =
        invocation.positionalArguments.first
            as CallStateSelector<List<UserInfo>>;
    return Stream.value(selector(state));
  });
}

/// A member of a ringing call, named [name] and with no picture.
CallMemberState ringingMember(String name) => CallMemberState(
  userId: name.toLowerCase(),
  name: name,
  roles: const [],
  custom: const {},
);

/// A camera track that answers the questions a renderer asks of it.
///
/// [RtcLocalCameraTrack.mediaConstraints] is what a preview reads the facing
/// mode off, and a bare mock returns null for it.
MockRtcLocalCameraTrack mockCameraTrack({
  FacingMode facingMode = FacingMode.user,
}) {
  final track = MockRtcLocalCameraTrack();
  when(
    () => track.mediaConstraints,
  ).thenReturn(CameraConstraints(facingMode: facingMode));
  when(track.stop).thenAnswer((_) async {});
  return track;
}
