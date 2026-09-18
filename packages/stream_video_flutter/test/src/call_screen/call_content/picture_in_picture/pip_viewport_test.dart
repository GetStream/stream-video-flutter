import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../../test_utils/test_wrapper.dart';
import '../../../mocks.dart';

// The native picture-in-picture window draws a participant's track, so it is a
// viewport like a grid tile: it reports what it draws to the call's registry
// rather than subscribing behind the registry's back.

void main() {
  const channel = MethodChannel('stream_video_flutter_pip');

  late MockCall call;
  late MockCallState callState;
  late MockCallParticipantState participant;
  late MutableStateEmitter<CallState> emitter;
  late List<ViewportAggregate> aggregates;

  setUpAll(() {
    registerFallbackValue(SfuTrackType.video);
  });

  setUp(() {
    aggregates = [];
    call = MockCall();
    callState = MockCallState();
    participant = MockCallParticipantState();

    when(() => participant.userId).thenReturn('alice');
    when(() => participant.sessionId).thenReturn('alice-session');
    when(() => participant.trackIdPrefix).thenReturn('alice');
    when(() => participant.name).thenReturn('Alice');
    when(() => participant.image).thenReturn(null);
    when(() => participant.isLocal).thenReturn(false);
    when(() => participant.isSpeaking).thenReturn(false);
    when(() => participant.isAudioEnabled).thenReturn(true);
    when(() => participant.isVideoEnabled).thenReturn(true);
    when(() => participant.isScreenShareEnabled).thenReturn(false);
    when(() => participant.screenShareTrack).thenReturn(null);
    when(() => participant.publishedTracks).thenReturn(const {});
    when(
      () => participant.connectionQuality,
    ).thenReturn(SfuConnectionQuality.excellent);

    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => callState.callParticipants).thenReturn([participant]);
    when(() => callState.iOSMultitaskingCameraAccessEnabled).thenReturn(true);

    emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    when(() => call.viewportVisibility).thenReturn(
      ViewportVisibilityRegistry(
        onAggregate: (aggregate) async {
          aggregates.add(aggregate);
          return true;
        },
      ),
    );
    // The track has not arrived: what the window wants is exactly what the
    // report is for.
    when(() => call.getTrack(any(), any())).thenReturn(null);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> pumpPip(WidgetTester tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamPictureInPictureUiKitView(
          call: call,
          pictureInPictureConfiguration: const PictureInPictureConfiguration(
            enablePictureInPicture: true,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('the window reports the track it draws, kept while hidden', (
    tester,
  ) async {
    await pumpPip(tester);

    // The window only draws once the app is backgrounded, which is when it
    // starts following the participants.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    emitter.value = callState;
    // Past the delay backgrounding schedules to re-check the call status.
    await tester.pump(const Duration(milliseconds: 200));

    expect(aggregates, isNotEmpty);
    expect(aggregates.last.track.sessionId, 'alice-session');
    expect(aggregates.last.track.trackType, SfuTrackType.video);
    expect(aggregates.last.visibility, ViewportVisibility.visible);
    expect(
      aggregates.last.persistWhenHidden,
      isTrue,
      reason:
          'the tiles go hidden when the app is backgrounded, and the '
          'window would lose the track it is drawing',
    );
    expect(
      aggregates.last.dimension,
      RtcVideoDimensionPresets.h360_169,
    );
  });

  testWidgets('the window lets go of the track once nobody is left to draw', (
    tester,
  ) async {
    await pumpPip(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    emitter.value = callState;
    // Past the delay backgrounding schedules to re-check the call status.
    await tester.pump(const Duration(milliseconds: 200));
    expect(aggregates, isNotEmpty, reason: 'precondition: the window reported');
    aggregates.clear();

    final empty = MockCallState();
    when(() => empty.status).thenReturn(CallStatus.connected());
    when(() => empty.callParticipants).thenReturn([]);
    when(() => empty.iOSMultitaskingCameraAccessEnabled).thenReturn(true);
    emitter.value = empty;
    await tester.pump();

    expect(
      aggregates.single.visibility,
      ViewportVisibility.hidden,
      reason: 'the window held a track nobody is drawing any more',
    );
  });
}
