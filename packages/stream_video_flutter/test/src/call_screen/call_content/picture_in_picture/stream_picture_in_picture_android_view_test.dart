import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/src/renderer/rendered_video_sizes.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

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

void main() {
  late List<Object?> sentAspectRatios;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    sentAspectRatios = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pipChannel, (call) async {
          if (call.method == 'setPictureInPictureAspectRatio') {
            sentAspectRatios.add(call.arguments);
          }
          return null;
        });
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pipChannel, null);
    RenderedVideoSizes.instance.reset();
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
    await tester.pump(settle);

    expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});
  });

  testWidgets('follows the video when its size changes', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';

    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await tester.pump(settle);
    RenderedVideoSizes.instance.report(trackId, renderer, landscape);
    await tester.pump(settle);

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
    await tester.pump(settle);

    expect(sentAspectRatios, [
      null,
      {'width': 1080, 'height': 1920},
    ]);
  });

  testWidgets('ignores a size that briefly goes away', (tester) async {
    await pumpView(tester, fakeCall([participant('alice')]));
    final trackId = 'alice:${SfuTrackType.video}';
    RenderedVideoSizes.instance.report(trackId, renderer, portrait);
    await tester.pump(settle);

    RenderedVideoSizes.instance
      ..remove(trackId, renderer)
      ..report(trackId, renderer, portrait);
    await tester.pump(settle);

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
    await tester.pump(settle);

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
    await tester.pump(settle);

    // Screen sharing sorts bob first.
    call.participants = [
      participant('alice'),
      participant('bob', screenSharing: true, video: false),
    ];
    await tester.pump(settle);

    expect(sentAspectRatios.last, isNull);

    RenderedVideoSizes.instance.report(
      'bob:${SfuTrackType.screenShare}',
      renderer,
      landscape,
    );
    await tester.pump(settle);

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
    await tester.pump(settle);

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
      await tester.pump(settle);

      expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});

      await enterPictureInPicture(tester, false);
      await tester.pump(settle);

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
      await tester.pump(settle);

      expect(sentAspectRatios.last, {'width': 1080, 'height': 1920});

      await enterPictureInPicture(tester, false);
    });
  });
}
