import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// Answers every partial-state request from one fixed call state.
class _FakeCall extends Mock implements Call {
  _FakeCall(this._callState)
    : _emitter = MutableStateEmitter<CallState>(_callState, sync: true);

  final CallState _callState;
  final MutableStateEmitter<CallState> _emitter;

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      Stream.value(selector(_callState));

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      Stream.value(const []);

  @override
  Stream<Duration> get callDurationStream =>
      Stream.value(const Duration(seconds: 5));
}

void main() {
  final liveCall = CallState(
    currentUserId: 'viewer',
    callCid: StreamCallCid(cid: 'livestream:test'),
    preferences: DefaultCallPreferences(),
  ).copyWith(status: CallStatus.connected());

  Future<void> pumpPlayer(
    WidgetTester tester, {
    bool startInFullscreenMode = false,
    VideoFit videoFit = VideoFit.adaptive,
    VideoFit fullscreenVideoFit = VideoFit.adaptive,
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) =>
            Directionality(textDirection: textDirection, child: child!),
        home: LivestreamPlayer(
          call: _FakeCall(liveCall),
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          startInFullscreenMode: startInFullscreenMode,
          videoFit: videoFit,
          fullscreenVideoFit: fullscreenVideoFit,
        ),
      ),
    );
    await tester.pump();
  }

  VideoFit contentFit(WidgetTester tester) =>
      tester.widget<LivestreamContent>(find.byType(LivestreamContent)).videoFit;

  Future<void> tapFullscreen(WidgetTester tester) async {
    await tester.tap(
      // The fullscreen button closes the toolbar's row.
      find
          .descendant(
            of: find.byType(StreamLivestreamTile),
            matching: find.byType(StreamButton),
          )
          .last,
    );
    // The player's double-tap detector holds a single tap until the
    // double-tap timeout passes.
    await tester.pump(kDoubleTapTimeout);
  }

  group('fullscreen video fit', () {
    testWidgets('inline the video fits by orientation', (tester) async {
      await pumpPlayer(tester);

      expect(contentFit(tester), VideoFit.adaptive);
    });

    testWidgets('switches between the inline and fullscreen fits', (
      tester,
    ) async {
      await pumpPlayer(
        tester,
        videoFit: VideoFit.contain,
        fullscreenVideoFit: VideoFit.cover,
      );
      await tapFullscreen(tester);

      expect(contentFit(tester), VideoFit.cover);

      await tapFullscreen(tester);

      expect(contentFit(tester), VideoFit.contain);
    });

    testWidgets('startInFullscreenMode uses the fullscreen fit', (
      tester,
    ) async {
      await pumpPlayer(tester, startInFullscreenMode: true);

      expect(contentFit(tester), VideoFit.adaptive);
    });

    testWidgets('fullscreenVideoFit overrides the fullscreen fit', (
      tester,
    ) async {
      await pumpPlayer(
        tester,
        startInFullscreenMode: true,
        fullscreenVideoFit: VideoFit.cover,
      );

      expect(contentFit(tester), VideoFit.cover);
    });
  });

  group('fullscreen toolbar', () {
    // The fullscreen button's 48 tap target pads its 32 visual by 8.
    const tapPadding = 8.0;

    testWidgets('is inset by md on both sides', (tester) async {
      final spacing = const StreamSpacing().md;
      await pumpPlayer(tester, startInFullscreenMode: true);

      final screen = tester.getRect(find.byType(Scaffold));
      final indicator = tester.getRect(find.byType(StreamLiveIndicator));
      final button = tester.getRect(
        find
            .descendant(
              of: find.byType(StreamLivestreamTile),
              matching: find.byType(StreamButton),
            )
            .last,
      );
      expect(indicator.left - screen.left, spacing);
      expect(screen.right - (button.right - tapPadding), spacing);
    });

    testWidgets('mirrors right to left', (tester) async {
      final spacing = const StreamSpacing().md;
      await pumpPlayer(
        tester,
        startInFullscreenMode: true,
        textDirection: TextDirection.rtl,
      );

      final screen = tester.getRect(find.byType(Scaffold));
      final indicator = tester.getRect(find.byType(StreamLiveIndicator));
      final button = tester.getRect(
        find
            .descendant(
              of: find.byType(StreamLivestreamTile),
              matching: find.byType(StreamButton),
            )
            .last,
      );
      expect(screen.right - indicator.right, spacing);
      expect(button.left + tapPadding - screen.left, spacing);
    });
  });

  group('space under the tile', () {
    Future<double> gapUnderTile(
      WidgetTester tester, {
      required double bottomInset,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: EdgeInsets.only(bottom: bottomInset),
            ),
            child: child!,
          ),
          home: LivestreamPlayer(
            call: _FakeCall(liveCall),
            joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          ),
        ),
      );
      await tester.pump();

      final screenHeight = tester.getSize(find.byType(Scaffold)).height;
      final tileBottom = tester
          .getBottomLeft(find.byType(StreamLivestreamTile))
          .dy;
      return screenHeight - tileBottom;
    }

    testWidgets('is nothing without a safe area', (tester) async {
      expect(await gapUnderTile(tester, bottomInset: 0), 0);
    });

    testWidgets('is the safe area', (tester) async {
      expect(await gapUnderTile(tester, bottomInset: 34), 34);
    });
  });

  testWidgets(
    'LivestreamPlayer shows the ended screen once the host ends the call',
    (tester) async {
      // The host ending the call disconnects the viewer before `endedAt`
      // reaches them.
      final ended = liveCall.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: LivestreamPlayer(
            call: _FakeCall(ended),
            joinBehaviour: LivestreamJoinBehaviour.manualJoin,
            showRecordingsWhenEnded: false,
            onCallDisconnected: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LivestreamEndedContent), findsOneWidget);
    },
  );

  testWidgets('LivestreamPlayer paints inside its own repaint boundary', (
    tester,
  ) async {
    await pumpPlayer(tester);

    final boundary = find.ancestor(
      of: find.byType(Scaffold),
      matching: find.byType(RepaintBoundary),
    );
    expect(
      find.descendant(of: find.byType(LivestreamPlayer), matching: boundary),
      findsWidgets,
    );
  });

  testWidgets(
    'LivestreamPlayer paints the call duration apart from the video content',
    (tester) async {
      await pumpPlayer(tester);

      final aroundControls = find
          .ancestor(
            of: find.byType(StreamCallDurationBadge),
            matching: find.byType(RepaintBoundary),
          )
          .evaluate()
          .toSet();
      final aroundContent = find
          .ancestor(
            of: find.byType(LivestreamContent),
            matching: find.byType(RepaintBoundary),
          )
          .evaluate()
          .toSet();
      expect(aroundControls.difference(aroundContent), isNotEmpty);
    },
  );
}
