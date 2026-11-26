import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';
import 'fake_livestream_call.dart';

void main() {
  final liveCall = CallState(
    currentUserId: 'viewer',
    callCid: StreamCallCid(cid: 'livestream:test'),
    preferences: DefaultCallPreferences(),
  ).copyWith(status: CallStatus.connected());

  Future<void> pumpWidget(
    WidgetTester tester,
    Widget player, {
    TextDirection textDirection = TextDirection.ltr,
    EdgeInsets padding = EdgeInsets.zero,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: padding),
            child: Directionality(textDirection: textDirection, child: player),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> pumpPlayer(
    WidgetTester tester, {
    Call? call,
    bool startInFullscreenMode = false,
    VideoFit videoFit = VideoFit.adaptive,
    VideoFit fullscreenVideoFit = VideoFit.adaptive,
    TextDirection textDirection = TextDirection.ltr,
    VoidCallback? onFullscreenTapped,
    WidgetBuilder? backButtonBuilder,
    LivestreamControlsWidgetBuilder? controlsBuilder,
  }) => pumpWidget(
    tester,
    LivestreamPlayer(
      call: call ?? FakeLivestreamCall(liveCall),
      joinBehaviour: LivestreamJoinBehaviour.manualJoin,
      startInFullscreenMode: startInFullscreenMode,
      videoFit: videoFit,
      fullscreenVideoFit: fullscreenVideoFit,
      onFullscreenTapped: onFullscreenTapped,
      backButtonBuilder: backButtonBuilder,
      livestreamControlsWidgetBuilder: controlsBuilder,
    ),
    textDirection: textDirection,
  );

  VideoFit contentFit(WidgetTester tester) =>
      tester.widget<LivestreamContent>(find.byType(LivestreamContent)).videoFit;

  Finder fullscreenButton() => find
      .descendant(
        of: find.byType(StreamLivestreamTile),
        matching: find.byType(StreamButton),
      )
      // The fullscreen button closes the toolbar's row.
      .last;

  Future<void> tapFullscreen(WidgetTester tester) async {
    await tester.tap(fullscreenButton());
    // The player's double-tap detector holds a single tap until the
    // double-tap timeout passes.
    await tester.pump(kDoubleTapTimeout);
  }

  Widget backButton(BuildContext context) =>
      const SizedBox.square(key: ValueKey('back'), dimension: 40);

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
      await pumpPlayer(
        tester,
        startInFullscreenMode: true,
        videoFit: VideoFit.contain,
      );

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

  group('fullscreen', () {
    testWidgets('drops the app bar and the back button', (tester) async {
      await pumpPlayer(tester, backButtonBuilder: backButton);
      expect(find.byType(CallAppBar), findsOneWidget);
      expect(find.byKey(const ValueKey('back')), findsOneWidget);

      await tapFullscreen(tester);

      expect(find.byType(CallAppBar), findsNothing);
      expect(find.byKey(const ValueKey('back')), findsNothing);
      expect(
        tester
            .widget<StreamLivestreamTile>(
              find.byType(StreamLivestreamTile),
            )
            .props
            .isFullscreen,
        isTrue,
      );

      await tapFullscreen(tester);

      expect(find.byType(CallAppBar), findsOneWidget);
      expect(find.byKey(const ValueKey('back')), findsOneWidget);
    });

    testWidgets('keeps the video content when it toggles', (tester) async {
      await pumpPlayer(tester);
      final inline = tester.state(find.byType(LivestreamContent));

      await tapFullscreen(tester);

      expect(tester.state(find.byType(LivestreamContent)), same(inline));

      await tapFullscreen(tester);

      expect(tester.state(find.byType(LivestreamContent)), same(inline));
    });

    testWidgets('back leaves fullscreen before it leaves the screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LivestreamPlayer(
                    call: FakeLivestreamCall(liveCall),
                    joinBehaviour: LivestreamJoinBehaviour.manualJoin,
                    startInFullscreenMode: true,
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(CallAppBar), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(LivestreamPlayer), findsOneWidget);
      expect(find.byType(CallAppBar), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(LivestreamPlayer), findsNothing);
    });

    testWidgets('a disconnect in fullscreen still closes the screen', (
      tester,
    ) async {
      final call = FakeLivestreamCall(liveCall);
      when(
        () => call.leave(reason: any(named: 'reason')),
      ).thenAnswer((_) async => const Result.success(none));
      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LivestreamPlayer(
                    call: call,
                    joinBehaviour: LivestreamJoinBehaviour.manualJoin,
                    startInFullscreenMode: true,
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      call.callState = liveCall.copyWith(
        status: CallStatus.disconnected(DisconnectReason.reconnectionFailed()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LivestreamPlayer), findsNothing);
    });

    testWidgets('onFullscreenTapped is called once and does not toggle', (
      tester,
    ) async {
      var taps = 0;
      await pumpPlayer(tester, onFullscreenTapped: () => taps++);

      await tapFullscreen(tester);

      expect(taps, 1);
      expect(find.byType(CallAppBar), findsOneWidget);
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
      final button = tester.getRect(fullscreenButton());
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
      final button = tester.getRect(fullscreenButton());
      expect(screen.right - indicator.right, spacing);
      expect(button.left + tapPadding - screen.left, spacing);
    });
  });

  group('toolbar toggles', () {
    testWidgets('the tile theme hides the viewer count', (tester) async {
      await pumpWidget(
        tester,
        StreamLivestreamTileTheme(
          data: const StreamLivestreamTileThemeData(
            style: StreamLivestreamTileStyle(showSpectatorsIndicator: false),
          ),
          child: LivestreamPlayer(
            call: FakeLivestreamCall(liveCall),
            joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          ),
        ),
      );

      expect(find.byType(StreamSpectatorsIndicator), findsNothing);
    });

    testWidgets('showParticipantCount wins over the tile theme', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        StreamLivestreamTileTheme(
          data: const StreamLivestreamTileThemeData(
            style: StreamLivestreamTileStyle(showSpectatorsIndicator: false),
          ),
          child: LivestreamPlayer(
            call: FakeLivestreamCall(liveCall),
            joinBehaviour: LivestreamJoinBehaviour.manualJoin,
            showParticipantCount: true,
          ),
        ),
      );

      expect(find.byType(StreamSpectatorsIndicator), findsOneWidget);
    });
  });

  group('custom controls', () {
    Widget controls(BuildContext context, Call call) => const Text('controls');

    testWidgets('replace the toolbar', (tester) async {
      await pumpPlayer(tester, controlsBuilder: controls);

      expect(find.text('controls'), findsOneWidget);
      expect(find.byType(StreamLivestreamTile), findsNothing);
      expect(find.byType(LivestreamContent), findsOneWidget);
    });

    testWidgets('stay in fullscreen', (tester) async {
      await pumpPlayer(
        tester,
        controlsBuilder: controls,
        startInFullscreenMode: true,
      );

      expect(find.text('controls'), findsOneWidget);
    });
  });

  group('space under the tile', () {
    Future<double> gapUnderTile(
      WidgetTester tester, {
      required double bottomInset,
    }) async {
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: FakeLivestreamCall(liveCall),
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
      );

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

  group('call phases', () {
    testWidgets('goes from backstage to live to ended', (tester) async {
      final call = FakeLivestreamCall(liveCall.copyWith(isBackstage: true));
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          showRecordingsWhenEnded: false,
          onCallDisconnected: (_) {},
        ),
      );
      expect(find.byType(LivestreamBackstageContent), findsOneWidget);

      call.callState = call.callState.copyWith(isBackstage: false);
      await tester.pump();
      expect(find.byType(LivestreamBackstageContent), findsNothing);
      expect(find.byType(StreamLivestreamTile), findsOneWidget);

      call.callState = call.callState.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );
      await tester.pump();
      expect(find.byType(LivestreamEndedContent), findsOneWidget);
    });

    testWidgets('an ended call shows the ended screen, even in backstage', (
      tester,
    ) async {
      final call = FakeLivestreamCall(
        liveCall.copyWith(isBackstage: true, endedAt: DateTime(2026)),
      );
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          showRecordingsWhenEnded: false,
        ),
      );

      expect(find.byType(LivestreamEndedContent), findsOneWidget);
      expect(find.byType(LivestreamBackstageContent), findsNothing);
    });

    testWidgets('a disconnect for another reason is not the ended screen', (
      tester,
    ) async {
      final call = FakeLivestreamCall(
        liveCall.copyWith(
          status: CallStatus.disconnected(
            DisconnectReason.reconnectionFailed(),
          ),
        ),
      );
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          onCallDisconnected: (_) {},
        ),
      );

      expect(find.byType(LivestreamEndedContent), findsNothing);
    });

    testWidgets('the widget builders win over the default screens', (
      tester,
    ) async {
      final call = FakeLivestreamCall(liveCall.copyWith(isBackstage: true));
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          onCallDisconnected: (_) {},
          livestreamBackstageWidgetBuilder: (_, _) => const Text('backstage'),
          livestreamEndedWidgetBuilder: (_, _) => const Text('ended'),
        ),
      );
      expect(find.text('backstage'), findsOneWidget);

      call.callState = call.callState.copyWith(endedAt: DateTime(2026));
      await tester.pump();
      expect(find.text('ended'), findsOneWidget);
    });
  });

  group('hosts', () {
    MockCallParticipantState participant(
      String userId, {
      bool video = false,
      List<String> roles = const ['user'],
    }) {
      final participant = MockCallParticipantState();
      when(() => participant.userId).thenReturn(userId);
      when(() => participant.isVideoEnabled).thenReturn(video);
      when(() => participant.roles).thenReturn(roles);
      return participant;
    }

    Future<List<String>?> shownHosts(
      WidgetTester tester,
      List<CallParticipantState> participants,
    ) async {
      List<String>? hosts;
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: FakeLivestreamCall(liveCall, participants: participants),
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          livestreamHostsParticipantBuilder: (context, properties) {
            hosts = [for (final host in properties.hosts) host.userId];
            return const SizedBox();
          },
          livestreamHostsUnavailableBuilder: (_, _) => const Text('no hosts'),
        ),
      );
      await tester.pump();
      return hosts;
    }

    testWidgets('are the participants with video', (tester) async {
      final hosts = await shownHosts(tester, [
        participant('host', roles: ['host']),
        participant('cohost', video: true),
      ]);

      expect(hosts, ['cohost']);
    });

    testWidgets('fall back to the host role while nobody has video', (
      tester,
    ) async {
      final hosts = await shownHosts(tester, [
        participant('viewer'),
        participant('host', roles: ['host']),
      ]);

      expect(hosts, ['host']);
    });

    testWidgets('are unavailable while only viewers are in the call', (
      tester,
    ) async {
      final hosts = await shownHosts(tester, [participant('viewer')]);

      expect(hosts, isNull);
      expect(find.text('no hosts'), findsOneWidget);
    });
  });

  testWidgets('the backstage countdown ticks down to starting soon', (
    tester,
  ) async {
    final call = FakeLivestreamCall(
      liveCall.copyWith(
        isBackstage: true,
        startsAt: DateTime.now().toUtc().add(
          const Duration(seconds: 1, milliseconds: 500),
        ),
      ),
    );
    await pumpWidget(
      tester,
      LivestreamPlayer(
        call: call,
        joinBehaviour: LivestreamJoinBehaviour.manualJoin,
      ),
    );
    Finder inCard(String text) => find.descendant(
      of: find.byType(LivestreamBackstageContent),
      matching: find.text(text),
    );
    expect(inCard('Livestream will start in:'), findsOneWidget);
    expect(inCard('00:01'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(inCard('00:00'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(inCard('Livestream will start soon'), findsOneWidget);
    expect(inCard('00:00'), findsNothing);
  });

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

  group('the call ends', () {
    late FakeLivestreamCall call;

    setUp(() {
      // In backstage, with no `endedAt`: only the disconnect says it ended.
      call = FakeLivestreamCall(liveCall.copyWith(isBackstage: true));
      when(
        () => call.leave(reason: any(named: 'reason')),
      ).thenAnswer((_) async => const Result.success(none));
    });

    testWidgets('by default, it stays on the ended view', (tester) async {
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          showRecordingsWhenEnded: false,
        ),
      );
      expect(find.byType(LivestreamEndedContent), findsNothing);

      call.callState = call.callState.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );
      await tester.pump();

      expect(find.byType(LivestreamEndedContent), findsOneWidget);
      verifyNever(() => call.leave(reason: any(named: 'reason')));
    });

    testWidgets('the ended view has a back button that leaves', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          showRecordingsWhenEnded: false,
        ),
      );
      final backButton = find.byTooltip('Back');
      expect(backButton, findsNothing);

      call.callState = call.callState.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );
      await tester.pump();

      await tester.tap(backButton);
      await tester.pump();

      verify(
        () => call.leave(
          reason: const DisconnectReason.left(initiator: LeaveInitiator.app),
        ),
      ).called(1);
    });

    testWidgets('a backButtonBuilder replaces the default back button', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          showRecordingsWhenEnded: false,
          backButtonBuilder: (_) => const Text('custom back'),
        ),
      );

      call.callState = call.callState.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );
      await tester.pump();

      expect(find.text('custom back'), findsOneWidget);
      expect(find.byTooltip('Back'), findsNothing);
    });

    testWidgets('a custom onCallDisconnected gets the ended reason', (
      tester,
    ) async {
      final disconnects = <CallDisconnectedProperties>[];
      await pumpWidget(
        tester,
        LivestreamPlayer(
          call: call,
          joinBehaviour: LivestreamJoinBehaviour.manualJoin,
          onCallDisconnected: disconnects.add,
          showRecordingsWhenEnded: false,
        ),
      );

      call.callState = call.callState.copyWith(
        status: CallStatus.disconnected(const DisconnectReason.ended()),
      );
      await tester.pump();

      expect(disconnects.single.reason, isA<DisconnectReasonEnded>());
      verifyNever(() => call.leave(reason: any(named: 'reason')));
    });
  });
}
