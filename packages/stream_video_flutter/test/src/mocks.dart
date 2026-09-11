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
