import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  late MockCall call;

  setUp(() {
    final state = MockCallState();
    when(() => state.isBackstage).thenReturn(false);
    when(() => state.participantCount).thenReturn(1);
    when(() => state.anonymousParticipantCount).thenReturn(0);

    call = MockCall();
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(() => call.partialState<bool>(any())).thenAnswer((invocation) {
      final CallStateSelector<bool> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
    when(() => call.partialState<int>(any())).thenAnswer((invocation) {
      final CallStateSelector<int> selector = invocation.positionalArguments[0];
      return Stream.value(selector(state));
    });
  });

  Future<void> pump(WidgetTester tester, StreamLivestreamTile tile) async {
    await tester.pumpWidget(
      TestWrapper(child: SizedBox(width: 280, height: 482, child: tile)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows both indicators over its child', (tester) async {
    await pump(
      tester,
      StreamLivestreamTile(
        call: call,
        showSpeakerphoneToggle: false,
        child: const Text('video'),
      ),
    );

    expect(find.text('video'), findsOneWidget);
    expect(find.byType(StreamLiveIndicator), findsOneWidget);
    expect(find.byType(StreamSpectatorsIndicator), findsOneWidget);
  });

  testWidgets('leaves the fullscreen button out without a callback', (
    tester,
  ) async {
    await pump(
      tester,
      StreamLivestreamTile(
        call: call,
        showSpeakerphoneToggle: false,
        child: const SizedBox(),
      ),
    );

    expect(find.byType(StreamButton), findsNothing);
  });

  testWidgets('the fullscreen button calls back', (tester) async {
    var taps = 0;
    await pump(
      tester,
      StreamLivestreamTile(
        call: call,
        showSpeakerphoneToggle: false,
        onFullscreenTapped: () => taps++,
        child: const SizedBox(),
      ),
    );

    await tester.tap(find.byType(StreamButton));
    expect(taps, 1);
  });

  testWidgets('hides the indicators when asked', (tester) async {
    await pump(
      tester,
      StreamLivestreamTile(
        call: call,
        showLiveIndicator: false,
        showSpectatorsIndicator: false,
        showSpeakerphoneToggle: false,
        child: const SizedBox(),
      ),
    );

    expect(find.byType(StreamLiveIndicator), findsNothing);
    expect(find.byType(StreamSpectatorsIndicator), findsNothing);
  });
}
