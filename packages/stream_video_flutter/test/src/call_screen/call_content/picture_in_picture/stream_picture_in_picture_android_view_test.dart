import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/src/renderer/rendered_video_sizes.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../mocks.dart';

class _MockRtcTrack extends Mock implements RtcTrack {}

// A call whose participants can be changed from the test. Every published
// track can be looked up, with the id the real call would give it.
class _FakeCall extends Mock implements Call {
  _FakeCall(CallState callState)
    : _changes = BehaviorSubject.seeded(callState, sync: true) {
    when(
      () => _emitter.value,
    ).thenAnswer((_) => _silentState ?? _changes.value);
  }

  final BehaviorSubject<CallState> _changes;
  final _emitter = MockStateEmitter<CallState>();

  CallState? _silentState;

  set participants(List<CallParticipantState> value) {
    _silentState = null;
    _changes.add(_changes.value.copyWith(callParticipants: value));
  }

  /// Changes the current state without the streams emitting it.
  void setStateWithoutEmitting(List<CallParticipantState> value) {
    _silentState = _changes.value.copyWith(callParticipants: value);
  }

  @override
  StateEmitter<CallState> get state => _emitter;

  @override
  Stream<T> partialState<T>(CallStateSelector<T> selector) =>
      _changes.stream.map(selector).distinct();

  @override
  Stream<List<CallParticipantState>> get participantsStream =>
      _changes.stream.map((state) => state.callParticipants);

  @override
  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    final track = _MockRtcTrack();
    when(() => track.trackId).thenReturn('$trackIdPrefix:$trackType');
    return track;
  }
}

const _pipChannel = MethodChannel('stream_video_flutter_android_pip');

bool _mapEquals(Object? a, Object? b) =>
    a is Map && b is Map ? mapEquals(a, b) : a == b;

void main() {
  late List<Object?> sentAspectRatios;
  late List<Object?> sentSourceRects;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    sentAspectRatios = [];
    sentSourceRects = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pipChannel, (call) async {
          if (call.method != 'setPictureInPictureParams') return null;

          // Both go together; each is recorded when it changes.
          final params = call.arguments as Map;
          final aspectRatio = params.containsKey('width')
              ? {'width': params['width'], 'height': params['height']}
              : null;
          final sourceRect = params.containsKey('left')
              ? {
                  'left': params['left'],
                  'top': params['top'],
                  'right': params['right'],
                  'bottom': params['bottom'],
                }
              : null;
          if (sentAspectRatios.isEmpty ||
              !_mapEquals(sentAspectRatios.last, aspectRatio)) {
            sentAspectRatios.add(aspectRatio);
          }
          if (sentSourceRects.isEmpty ||
              !_mapEquals(sentSourceRects.last, sourceRect)) {
            sentSourceRects.add(sourceRect);
          }
          return null;
        });
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pipChannel, null);
    RenderedVideoSizes.instance.reset();
    AndroidPipManager.instance().resetPictureInPictureParams();
  });

  CallParticipantState participant(
    String userId, {
    bool screenSharing = false,
    bool video = true,
    bool dominantSpeaker = false,
  }) {
    return CallParticipantState(
      isDominantSpeaker: dominantSpeaker,
      name: userId,
      userId: userId,
      sessionId: '$userId-session',
      custom: const {},
      roles: const [],
      trackIdPrefix: userId,
      publishedTracks: {
        if (video) SfuTrackType.video: TrackState.remote(),
        if (screenSharing) SfuTrackType.screenShare: TrackState.remote(),
      },
    );
  }

  _FakeCall fakeCall(List<CallParticipantState> participants) {
    return _FakeCall(
      CallState(
        currentUserId: 'me',
        callCid: StreamCallCid(cid: 'default:test'),
        preferences: DefaultCallPreferences(),
      ).copyWith(callParticipants: participants),
    );
  }

  Future<void> pumpView(
    WidgetTester tester,
    Call call, {
    PictureInPictureConfiguration configuration =
        const PictureInPictureConfiguration(enablePictureInPicture: true),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamPictureInPictureAndroidView(
          call: call,
          configuration: configuration,
        ),
      ),
    );
    await tester.pump();
  }

  // Longer than the view waits for a new size to settle.
  const settle = Duration(milliseconds: 200);

  // The frame the params are checked after, then the wait for them to settle.
  Future<void> settleParams(WidgetTester tester) async {
    tester.binding.scheduleFrame();
    await tester.pump();
    await tester.pump(settle);
  }

  Future<void> enterPictureInPicture(WidgetTester tester, bool isInPip) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _pipChannel.name,
          _pipChannel.codec.encodeMethodCall(
            MethodCall('onPictureInPictureModeChanged', isInPip),
          ),
          (_) {},
        );
    await tester.pump();
  }

  const landscape = Size(1920, 1080);
  const portrait = Size(1080, 1920);
  final renderer = Object();

  testWidgets('falls back to the orientation while the size is unknown', (
    tester,
  ) async {
    await pumpView(tester, fakeCall([participant('alice')]));

    expect(sentAspectRatios, [null]);
  });

  testWidgets('sends the size of the video picture-in-picture shows', (
    tester,
  ) async {
    await pumpView(tester, fakeCall([participant('alice')]));

    RenderedVideoSizes.instance.report(
      'alice:${SfuTrackType.video}',
      renderer,
      portrait,
    );
    await settleParams(tester);

    expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});
  });

  testWidgets('follows the video when its size changes', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';

    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await settleParams(tester);
    RenderedVideoSizes.instance.report(trackId, renderer, landscape);
    await settleParams(tester);

    expect(sentAspectRatios, [
      null,
      {'width': 1080, 'height': 1920},
      {'width': 1920, 'height': 1080},
    ]);
  });

  testWidgets('sends only the size a video settles on', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';

    // A renderer that has just mounted reports the unrotated size first.
    RenderedVideoSizes.instance.report(trackId, renderer, landscape);
    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await settleParams(tester);

    expect(sentAspectRatios, [
      null,
      {'width': 1080, 'height': 1920},
    ]);
  });

  testWidgets('ignores a size that briefly goes away', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';
    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await settleParams(tester);

    RenderedVideoSizes.instance
      ..remove(trackId, renderer)
      ..report(trackId, renderer, portrait);
    await settleParams(tester);

    expect(sentAspectRatios, [
      null,
      {'width': 1080, 'height': 1920},
    ]);
  });

  testWidgets('ignores the size of videos picture-in-picture does not show', (
    tester,
  ) async {
    await pumpView(tester, fakeCall([participant('alice')]));

    RenderedVideoSizes.instance.report(
      'bob:${SfuTrackType.video}',
      renderer,
      portrait,
    );

    expect(sentAspectRatios, [null]);
  });

  testWidgets('uses the screen share when the participant shares a screen', (
    tester,
  ) async {
    await pumpView(
      tester,
      fakeCall([participant('alice', screenSharing: true)]),
    );

    RenderedVideoSizes.instance
      ..report('alice:${SfuTrackType.video}', renderer, portrait)
      ..report('alice:${SfuTrackType.screenShare}', Object(), landscape);
    await settleParams(tester);

    expect(sentAspectRatios.last, {'width': 1920, 'height': 1080});
  });

  testWidgets('switches to the size of a new participant shown', (
    tester,
  ) async {
    final call = fakeCall([participant('alice')]);
    await pumpView(tester, call);
    RenderedVideoSizes.instance
      ..report('alice:${SfuTrackType.video}', renderer, portrait)
      ..report('bob:${SfuTrackType.video}', Object(), landscape);
    await settleParams(tester);

    // Screen sharing sorts bob first.
    call.participants = [
      participant('alice'),
      participant('bob', screenSharing: true, video: false),
    ];
    await settleParams(tester);

    expect(sentAspectRatios.last, isNull);

    RenderedVideoSizes.instance.report(
      'bob:${SfuTrackType.screenShare}',
      renderer,
      landscape,
    );
    await settleParams(tester);

    expect(sentAspectRatios.last, {'width': 1920, 'height': 1080});
  });

  testWidgets('sends no size when a custom builder decides what is shown', (
    tester,
  ) async {
    await pumpView(
      tester,
      fakeCall([participant('alice')]),
      configuration: PictureInPictureConfiguration(
        enablePictureInPicture: true,
        androidPiPConfiguration: AndroidPictureInPictureConfiguration(
          callPictureInPictureWidgetBuilder: (context, call) =>
              const SizedBox.shrink(),
        ),
      ),
    );

    RenderedVideoSizes.instance.report(
      'alice:${SfuTrackType.video}',
      renderer,
      portrait,
    );

    expect(sentAspectRatios, [null]);
  });

  testWidgets('sends nothing when picture-in-picture is disabled', (
    tester,
  ) async {
    await pumpView(
      tester,
      fakeCall([participant('alice')]),
      configuration: const PictureInPictureConfiguration(),
    );

    RenderedVideoSizes.instance.report(
      'alice:${SfuTrackType.video}',
      renderer,
      portrait,
    );

    expect(sentAspectRatios, isEmpty);
  });

  testWidgets('clears the size when removed', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    RenderedVideoSizes.instance.report(
      'alice:${SfuTrackType.video}',
      renderer,
      portrait,
    );
    await settleParams(tester);

    await tester.pumpWidget(const SizedBox.shrink());

    expect(sentAspectRatios.last, isNull);
  });

  testWidgets('keeps the size a newer view set when an older one goes', (
    tester,
  ) async {
    RenderedVideoSizes.instance
      ..report('alice:${SfuTrackType.video}', renderer, portrait)
      ..report('bob:${SfuTrackType.video}', Object(), landscape);
    const configuration = PictureInPictureConfiguration(
      enablePictureInPicture: true,
    );

    // Two screens, as during a route replacement: the newer one, keyed so
    // it isn't the same state, sets its size before the older one goes.
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            StreamPictureInPictureAndroidView(
              key: const ValueKey('old'),
              call: fakeCall([participant('alice')]),
              configuration: configuration,
            ),
            StreamPictureInPictureAndroidView(
              key: const ValueKey('new'),
              call: fakeCall([participant('bob')]),
              configuration: configuration,
            ),
          ],
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            StreamPictureInPictureAndroidView(
              key: const ValueKey('new'),
              call: fakeCall([participant('bob')]),
              configuration: configuration,
            ),
          ],
        ),
      ),
    );

    expect(sentAspectRatios.last, {'width': 1920, 'height': 1080});
  });

  testWidgets('keeps the size while the track has no renderer for a while', (
    tester,
  ) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';
    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await settleParams(tester);

    // Entering picture-in-picture: the call's tile goes, and the overlay's
    // renderer only reports after its first frame, longer than the wait.
    RenderedVideoSizes.instance.remove(trackId, renderer);
    await tester.pump(settle * 3);
    RenderedVideoSizes.instance.report(trackId, Object(), portrait);
    await settleParams(tester);

    expect(sentAspectRatios, [
      null,
      {'width': 1080, 'height': 1920},
    ]);
  });

  group('while in picture-in-picture', () {
    testWidgets('keeps the participant order the overlay keeps', (
      tester,
    ) async {
      RenderedVideoSizes.instance
        ..report('alice:${SfuTrackType.video}', renderer, portrait)
        ..report('bob:${SfuTrackType.video}', Object(), landscape);
      // Nothing sets the two apart, so the order they arrive in decides.
      final call = fakeCall([participant('alice'), participant('bob')]);
      await pumpView(tester, call);
      await enterPictureInPicture(tester, true);

      call.participants = [participant('bob'), participant('alice')];
      await settleParams(tester);

      expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});

      await enterPictureInPicture(tester, false);
      await settleParams(tester);

      // Outside it, the view sorts afresh, as a new overlay would.
      expect(sentAspectRatios.last, {'width': 1920, 'height': 1080});
    });

    testWidgets('does not re-sort when the parent rebuilds', (tester) async {
      RenderedVideoSizes.instance
        ..report('alice:${SfuTrackType.video}', renderer, portrait)
        ..report('bob:${SfuTrackType.video}', Object(), landscape);
      final call = fakeCall([
        participant('alice', dominantSpeaker: true),
        participant('bob'),
      ]);
      await pumpView(tester, call);
      await enterPictureInPicture(tester, true);

      // Bob briefly becomes the dominant speaker in a state the overlay never
      // sees, as when the participants stream throttles it away.
      call.setStateWithoutEmitting([
        participant('alice'),
        participant('bob', dominantSpeaker: true),
      ]);
      await pumpView(tester, call);
      // Then nobody is, so the overlay keeps alice first.
      call.participants = [participant('alice'), participant('bob')];
      await settleParams(tester);

      expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});

      await enterPictureInPicture(tester, false);
    });
  });

  group('the area the window animates in from', () {
    late BuildContext tileContext;

    // The view, with a tile drawing alice's video at [tile].
    Future<void> pumpWithTile(WidgetTester tester, Call call, Rect tile) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              StreamPictureInPictureAndroidView(
                call: call,
                configuration: const PictureInPictureConfiguration(
                  enablePictureInPicture: true,
                ),
              ),
              Positioned.fromRect(
                rect: tile,
                child: Builder(
                  builder: (context) {
                    tileContext = context;
                    return const SizedBox.expand();
                  },
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
    }

    // A frame to measure in, as the renderer reporting its size schedules
    // one by rebuilding, then one for the channel to deliver what was sent.
    Future<void> measure(WidgetTester tester) => settleParams(tester);

    void reportTile() {
      RenderedVideoSizes.instance.report(
        'alice:${SfuTrackType.video}',
        renderer,
        portrait,
        context: tileContext,
      );
    }

    Map<String, int> physical(WidgetTester tester, Rect logical) {
      final ratio = tester.view.devicePixelRatio;
      return {
        'left': (logical.left * ratio).round(),
        'top': (logical.top * ratio).round(),
        'right': (logical.right * ratio).round(),
        'bottom': (logical.bottom * ratio).round(),
      };
    }

    const tile = Rect.fromLTWH(10, 20, 100, 200);

    testWidgets('of a view that goes is handed to the one left', (
      tester,
    ) async {
      late BuildContext aliceTile;
      late BuildContext bobTile;
      const configuration = PictureInPictureConfiguration(
        enablePictureInPicture: true,
      );
      final aliceCall = fakeCall([participant('alice')]);
      final bobCall = fakeCall([participant('bob')]);
      const bobRect = Rect.fromLTWH(200, 20, 100, 200);

      // Two call screens, as during a route replacement, each with a tile.
      Widget screens({required bool withAlice, required Rect aliceRect}) {
        return MaterialApp(
          home: Stack(
            children: [
              if (withAlice)
                StreamPictureInPictureAndroidView(
                  key: const ValueKey('alice'),
                  call: aliceCall,
                  configuration: configuration,
                ),
              StreamPictureInPictureAndroidView(
                key: const ValueKey('bob'),
                call: bobCall,
                configuration: configuration,
              ),
              Positioned.fromRect(
                rect: aliceRect,
                child: Builder(
                  builder: (context) {
                    aliceTile = context;
                    return const SizedBox.expand();
                  },
                ),
              ),
              Positioned.fromRect(
                rect: bobRect,
                child: Builder(
                  builder: (context) {
                    bobTile = context;
                    return const SizedBox.expand();
                  },
                ),
              ),
            ],
          ),
        );
      }

      await tester.pumpWidget(screens(withAlice: true, aliceRect: tile));
      RenderedVideoSizes.instance
        ..report(
          'alice:${SfuTrackType.video}',
          renderer,
          portrait,
          context: aliceTile,
        )
        ..report(
          'bob:${SfuTrackType.video}',
          Object(),
          landscape,
          context: bobTile,
        );
      await settleParams(tester);
      await measure(tester);

      // The older screen's tile moves as it leaves, so it sends last.
      await tester.pumpWidget(
        screens(
          withAlice: true,
          aliceRect: const Rect.fromLTWH(30, 40, 100, 200),
        ),
      );
      await measure(tester);
      expect(sentSourceRects.last, isNot(physical(tester, bobRect)));

      await tester.pumpWidget(screens(withAlice: false, aliceRect: tile));
      await measure(tester);
      await settleParams(tester);

      expect(sentSourceRects.last, physical(tester, bobRect));
      expect(sentAspectRatios.last, {'width': 1920, 'height': 1080});
    });

    testWidgets('is where the video it will show is drawn', (tester) async {
      await pumpWithTile(tester, fakeCall([participant('alice')]), tile);
      reportTile();
      await measure(tester);

      expect(sentSourceRects.last, physical(tester, tile));
    });

    testWidgets('follows the tile when it moves, only then', (tester) async {
      final call = fakeCall([participant('alice')]);
      await pumpWithTile(tester, call, tile);
      reportTile();
      await measure(tester);
      await tester.pump();
      final sent = sentSourceRects.length;

      const moved = Rect.fromLTWH(50, 60, 100, 200);
      await pumpWithTile(tester, call, moved);
      reportTile();
      await measure(tester);

      expect(sentSourceRects.length, sent + 1);
      expect(sentSourceRects.last, physical(tester, moved));
    });

    testWidgets('is cleared once the video is not drawn', (tester) async {
      await pumpWithTile(tester, fakeCall([participant('alice')]), tile);
      reportTile();
      await measure(tester);

      RenderedVideoSizes.instance.remove(
        'alice:${SfuTrackType.video}',
        renderer,
      );
      await measure(tester);

      expect(sentSourceRects.last, isNull);
    });

    testWidgets('is clipped to the screen', (tester) async {
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      final overhanging = Rect.fromLTWH(-50, 20, 100, 200);
      await pumpWithTile(tester, fakeCall([participant('alice')]), overhanging);
      reportTile();
      await measure(tester);

      expect(
        sentSourceRects.last,
        physical(tester, Rect.fromLTRB(0, 20, 50, 220)),
      );
      expect(screen.width, greaterThan(50));
    });

    testWidgets('is kept while in picture-in-picture', (tester) async {
      final call = fakeCall([participant('alice')]);
      await pumpWithTile(tester, call, tile);
      reportTile();
      await measure(tester);
      await enterPictureInPicture(tester, true);
      final sent = sentSourceRects.length;

      // Laid out inside the small window.
      await pumpWithTile(tester, call, const Rect.fromLTWH(0, 0, 30, 60));
      reportTile();
      await measure(tester);

      expect(sentSourceRects.length, sent);

      await enterPictureInPicture(tester, false);
    });
  });

  testWidgets('shows the overlay above everything, past a nested navigator', (
    tester,
  ) async {
    final call = _FakeCall(
      CallState(
        currentUserId: 'me',
        callCid: StreamCallCid(cid: 'default:test'),
        preferences: DefaultCallPreferences(),
      ).copyWith(
        status: CallStatus.connected(),
        callParticipants: [participant('alice')],
      ),
    );
    final configuration = PictureInPictureConfiguration(
      enablePictureInPicture: true,
      androidPiPConfiguration: AndroidPictureInPictureConfiguration(
        callPictureInPictureWidgetBuilder: (context, call) =>
            const Text('pip content'),
      ),
    );

    // The call screen inside a nested navigator, as in an app with tabs.
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => StreamPictureInPictureAndroidView(
              call: call,
              configuration: configuration,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await enterPictureInPicture(tester, true);

    final rootOverlay = tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .overlay;
    final overlayOfContent = tester.state<OverlayState>(
      find
          .ancestor(
            of: find.text('pip content'),
            matching: find.byType(Overlay),
          )
          .first,
    );
    expect(overlayOfContent, same(rootOverlay));

    await enterPictureInPicture(tester, false);
  });
}
