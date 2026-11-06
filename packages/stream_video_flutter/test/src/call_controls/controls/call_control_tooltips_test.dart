import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  late MockCall call;
  late MockCallState callState;
  late MockCallParticipantState localParticipant;

  // Process-wide, so it goes back to what it was for whatever runs next.
  late Duration updateInterval;

  void stubPartialState<T>() {
    when(() => call.partialState<T>(any())).thenAnswer((invocation) {
      final CallStateSelector<T> selector = invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
  }

  setUp(() {
    updateInterval = VisibilityDetectorController.instance.updateInterval;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    call = MockCall();
    callState = MockCallState();
    localParticipant = MockCallParticipantState();

    when(() => localParticipant.publishedTracks).thenReturn({
      SfuTrackType.audio: TrackState.local(),
      SfuTrackType.video: TrackState.local(),
    });
    when(() => localParticipant.videoTrack).thenReturn(TrackState.local());
    when(() => localParticipant.isScreenShareEnabled).thenReturn(false);

    when(() => callState.isCaptioning).thenReturn(false);
    when(() => callState.isRecording).thenReturn(false);
    when(() => callState.audioOutputDevice).thenReturn(null);
    when(() => callState.localParticipant).thenReturn(localParticipant);

    final emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    stubPartialState<bool>();
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval = updateInterval;
  });

  final buttons = <String, Widget Function()>{
    'Toggle microphone': () => StreamMicrophoneButton(
      call: call,
      localParticipant: localParticipant,
    ),
    'Toggle camera': () =>
        StreamCameraButton(call: call, localParticipant: localParticipant),
    'Toggle captions': () => StreamClosedCaptionsButton(call: call),
    'Toggle screen sharing': () => StreamScreenShareButton(
      call: call,
      localParticipant: localParticipant,
    ),
    'Toggle recording': () => StreamRecordingButton(call: call),
    'Toggle speakerphone': () => StreamSpeakerphoneButton(call: call),
    'Flip camera': () =>
        StreamFlipCameraButton(call: call, localParticipant: localParticipant),
    'Send a reaction': () => StreamAddReactionButton(call: call),
    'Leave call': () => StreamLeaveCallButton(call: call),
  };

  for (final MapEntry(key: tooltip, value: build) in buttons.entries) {
    testWidgets('shows "$tooltip" as its tooltip', (tester) async {
      await tester.pumpWidget(TestWrapper(child: build()));
      await tester.pumpAndSettle();

      expect(find.byTooltip(tooltip), findsOneWidget);
    });
  }
}
