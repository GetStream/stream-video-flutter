import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/goldens.dart';
import '../mocks.dart';

void main() {
  MockCall call() {
    final state = MockCallState();
    when(() => state.isBackstage).thenReturn(false);
    when(() => state.participantCount).thenReturn(1);
    when(() => state.anonymousParticipantCount).thenReturn(0);

    final it = MockCall();
    when(() => it.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(() => it.partialState<bool>(any())).thenAnswer((invocation) {
      final CallStateSelector<bool> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    when(() => it.partialState<int>(any())).thenAnswer((invocation) {
      final CallStateSelector<int> selector = invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    return it;
  }

  MockCallParticipantState host({required bool video}) {
    final it = MockCallParticipantState();
    when(() => it.uniqueParticipantKey).thenReturn('host-$video');
    when(() => it.userId).thenReturn('katie');
    when(it.toUserInfo).thenReturn(
      const UserInfo(id: 'katie', name: 'Katie Miler'),
    );
    when(() => it.name).thenReturn('Katie Miler');
    when(() => it.image).thenReturn(null);
    when(() => it.isSpeaking).thenReturn(false);
    when(() => it.isAudioEnabled).thenReturn(true);
    when(() => it.isVideoEnabled).thenReturn(video);
    when(() => it.connectionQuality).thenReturn(SfuConnectionQuality.excellent);
    when(() => it.reaction).thenReturn(null);
    return it;
  }

  Widget tile({required bool video}) {
    final it = call();
    return StreamLivestreamTile(
      call: it,
      onFullscreenTapped: () {},
      child: StreamParticipantTile(
        call: it,
        participant: host(video: video),
        showParticipantLabel: false,
        showConnectionQualityIndicator: false,
        showSpeakerBorder: false,
        // A real renderer needs a live call. A flat fill stands in for video.
        // With video off it draws what the renderer would: the placeholder.
        videoRendererBuilder: video
            ? (_, _, _) => const ColoredBox(color: Color(0xFF6E7A8A))
            : (_, call, participant) => StreamParticipantPlaceholder(
                call: call,
                participant: participant,
              ),
      ),
    );
  }

  const webrtcMethods = MethodChannel('FlutterWebRTC.Method');
  const webrtcEvents = EventChannel('FlutterWebRTC.Event');

  setUp(() {
    // The speakerphone toggle only shows where playout can be paused.
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(webrtcMethods, (_) async => null)
      ..setMockStreamHandler(
        webrtcEvents,
        MockStreamHandler.inline(onListen: (_, _) {}),
      );
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(webrtcMethods, null)
      ..setMockStreamHandler(webrtcEvents, null);
  });

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamLivestreamTile with video on and off',
      fileName: 'stream_livestream_tile',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 280,
          height: 482,
        ),
        children: [
          GoldenTestScenario(name: 'video on', child: tile(video: true)),
          GoldenTestScenario(name: 'video off', child: tile(video: false)),
        ],
      ),
    );
  }
}
