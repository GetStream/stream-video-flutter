import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../../test_utils/goldens.dart';
import '../../../mocks.dart';

MockCallParticipantState _participant({
  String name = 'Katie Miler',
  bool isAudioEnabled = true,
  bool isVideoEnabled = true,
  SfuConnectionQuality quality = SfuConnectionQuality.excellent,
}) {
  final participant = MockCallParticipantState();
  when(() => participant.userId).thenReturn('katie');
  when(() => participant.uniqueParticipantKey).thenReturn('katie-session');
  when(() => participant.name).thenReturn(name);
  when(() => participant.image).thenReturn(null);
  when(() => participant.isLocal).thenReturn(false);
  when(() => participant.isSpeaking).thenReturn(false);
  when(() => participant.isAudioEnabled).thenReturn(isAudioEnabled);
  when(() => participant.isVideoEnabled).thenReturn(isVideoEnabled);
  when(() => participant.isScreenShareEnabled).thenReturn(false);
  when(() => participant.screenShareTrack).thenReturn(null);
  when(() => participant.connectionQuality).thenReturn(quality);
  when(() => participant.reaction).thenReturn(null);
  // What the avatar placeholder draws from.
  when(participant.toUserInfo).thenReturn(UserInfo(id: 'katie', name: name));
  return participant;
}

Widget _window(CallParticipantState participant) {
  final call = MockCall();
  final state = MockCallState();

  when(() => state.callParticipants).thenReturn([participant]);
  when(
    () => call.state,
  ).thenAnswer((_) => MutableStateEmitter<CallState>(state, sync: true));
  when(() => call.partialState<List<CallParticipantState>>(any())).thenAnswer((
    invocation,
  ) {
    final CallStateSelector<List<CallParticipantState>> selector =
        invocation.positionalArguments[0];
    return Stream.value(selector(state));
  });

  return StreamComponentFactory(
    builders: StreamComponentBuilders(
      extensions: streamVideoComponentBuilders(
        // A real renderer needs a live call. A flat fill stands in for video,
        // and keeps the snapshot off a decoded frame. The placeholder is the
        // real one: replacing the renderer wholesale would take it with it,
        // and it is what the window shows with the camera off.
        participantVideo: (context, props) => props.participant.isVideoEnabled
            ? const ColoredBox(color: Color(0xFF6E7A8A))
            : StreamParticipantPlaceholder(
                call: props.call,
                participant: props.participant,
              ),
      ),
    ),
    child: AndroidPipOverlay(call: call),
  );
}

// The window as Android draws it, at the size it gave the dogfooding app on a
// Pixel 8: 128x228dp, which is `full` density on the tile's ladder.
//
// What cannot be snapshotted: the pill's backdrop filter is a no-op under
// `flutter test`, so its fill comes out flat rather than blurred, and the
// window's own rounded corners belong to the system rather than to this
// subtree — the tile deliberately draws square into them.
void main() {
  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'AndroidPipOverlay renders the window',
      fileName: 'android_pip_overlay',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 4,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 128,
          height: 228,
        ),
        children: [
          GoldenTestScenario(
            name: 'video on',
            child: _window(_participant()),
          ),
          GoldenTestScenario(
            name: 'camera off',
            child: _window(_participant(isVideoEnabled: false)),
          ),
          GoldenTestScenario(
            name: 'muted',
            child: _window(_participant(isAudioEnabled: false)),
          ),
          GoldenTestScenario(
            name: 'poor connection',
            child: _window(
              _participant(quality: SfuConnectionQuality.poor),
            ),
          ),
        ],
      ),
    );
  }
}
