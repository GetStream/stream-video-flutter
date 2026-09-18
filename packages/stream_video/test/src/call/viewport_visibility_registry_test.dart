import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/viewport_visibility_registry.dart';
import 'package:stream_video/src/models/viewport_measurement.dart';
import 'package:stream_video/src/models/viewport_visibility.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';

// A participant can be on screen in more than one place at once — a tile in
// the grid, a picture-in-picture overlay, a livestream's host strip — while
// the call has one visibility and one subscription for their track. The
// registry is what turns the several measurements into the one answer.

void main() {
  final track = ViewportTrack(
    userId: 'alice',
    sessionId: 'alice-session',
    trackIdPrefix: 'alice',
    trackType: SfuTrackType.video,
  );

  final otherTrack = ViewportTrack(
    userId: 'bob',
    sessionId: 'bob-session',
    trackIdPrefix: 'bob',
    trackType: SfuTrackType.video,
  );

  ViewportMeasurement showing(int width, int height) {
    return ViewportMeasurement(
      visibility: ViewportVisibility.visible,
      dimension: RtcVideoDimension(width: width, height: height),
    );
  }

  const hidden = ViewportMeasurement(visibility: ViewportVisibility.hidden);

  late List<ViewportAggregate> aggregates;
  late ViewportVisibilityRegistry registry;

  /// What the call answers for an aggregate: whether it acted on it.
  late bool applied;

  setUp(() {
    aggregates = [];
    applied = true;
    registry = ViewportVisibilityRegistry(
      onAggregate: (aggregate) async {
        aggregates.add(aggregate);
        return applied;
      },
    );
  });

  test('every viewport gets a name of its own', () {
    final ids = List.generate(3, (_) => registry.nextViewportId());

    expect(ids.toSet(), hasLength(3));
  });

  test('one viewport speaks for the track', () {
    registry.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );

    expect(aggregates.single.visibility, ViewportVisibility.visible);
    expect(
      aggregates.single.dimension,
      const RtcVideoDimension(width: 640, height: 360),
    );
  });

  test('a viewport saying the same thing again is not passed on', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..report(
        viewportId: 'grid',
        track: track,
        measurement: showing(640, 360),
      );

    expect(aggregates, hasLength(1));
  });

  test('a track stays visible while any viewport still shows it', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..report(viewportId: 'pip', track: track, measurement: hidden);

    // What the off-screen overlay measures is true of the overlay, not of the
    // participant: they are still on screen in the grid.
    expect(
      aggregates.map((aggregate) => aggregate.visibility),
      [ViewportVisibility.visible],
    );
  });

  test('a track goes hidden once the last viewport showing it stops', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..report(viewportId: 'pip', track: track, measurement: hidden)
      ..report(viewportId: 'grid', track: track, measurement: hidden);

    expect(aggregates.last.visibility, ViewportVisibility.hidden);
    expect(aggregates.last.dimension.isEmpty, isTrue);
  });

  test('the track is sized for the largest viewport showing it', () {
    registry
      ..report(viewportId: 'pip', track: track, measurement: showing(320, 180))
      ..report(
        viewportId: 'spotlight',
        track: track,
        measurement: showing(1280, 720),
      );

    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 1280, height: 720),
    );
  });

  test('a viewport that is not showing the track does not size it', () {
    registry
      ..report(
        viewportId: 'spotlight',
        track: track,
        measurement: showing(1280, 720),
      )
      ..report(viewportId: 'pip', track: track, measurement: showing(320, 180))
      ..report(viewportId: 'pip', track: track, measurement: hidden);

    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 1280, height: 720),
    );
  });

  test('releasing the largest viewport drops the track to the next one', () {
    registry
      ..report(
        viewportId: 'spotlight',
        track: track,
        measurement: showing(1280, 720),
      )
      ..report(viewportId: 'pip', track: track, measurement: showing(320, 180))
      ..release(viewportId: 'spotlight', track: track);

    expect(aggregates.last.visibility, ViewportVisibility.visible);
    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 320, height: 180),
    );
  });

  test('a track no viewport draws any more is reported hidden once', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..release(viewportId: 'grid', track: track)
      ..release(viewportId: 'grid', track: track);

    expect(aggregates.last.visibility, ViewportVisibility.hidden);
    expect(aggregates, hasLength(2));
  });

  test('a viewport that wants the track kept while hidden says so for all', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: hidden)
      ..report(
        viewportId: 'screenshare',
        track: track,
        measurement: const ViewportMeasurement(
          visibility: ViewportVisibility.hidden,
          persistWhenHidden: true,
        ),
      );

    expect(aggregates.last.persistWhenHidden, isTrue);
  });

  test('tracks are kept apart', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..report(
        viewportId: 'grid',
        track: otherTrack,
        measurement: showing(320, 180),
      );

    expect(aggregates.map((aggregate) => aggregate.track), [track, otherTrack]);
  });

  test(
    'reapply says a standing answer again, for a track only now published',
    () {
      registry
        ..report(
          viewportId: 'grid',
          track: track,
          measurement: showing(640, 360),
        )
        ..reapply(track);

      expect(aggregates, hasLength(2));
      expect(aggregates.last, aggregates.first);
    },
  );

  test('reapply has nothing to say about a track nobody draws', () {
    registry.reapply(track);

    expect(aggregates, isEmpty);
  });

  // A viewport reports what changes about itself, so a new session would never
  // be told about a tile that has been sitting on screen throughout.
  test('a new session is told every track again', () {
    registry
      ..report(viewportId: 'grid', track: track, measurement: showing(640, 360))
      ..report(
        viewportId: 'pip',
        track: otherTrack,
        measurement: showing(320, 180),
      );

    aggregates.clear();
    registry.reapplyAll();

    expect(aggregates.map((aggregate) => aggregate.track), [track, otherTrack]);
  });

  test('a cleared registry has nothing left to say', () {
    registry.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );

    aggregates.clear();
    registry
      ..clear()
      ..reapplyAll();

    expect(aggregates, isEmpty);
  });

  test('an answer the call acted on is not offered again', () async {
    registry.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    await pumpEventQueue();

    // A smaller viewport does not move the answer: the largest one showing the
    // track still sizes it.
    registry.report(
      viewportId: 'strip',
      track: track,
      measurement: showing(320, 180),
    );
    await pumpEventQueue();

    expect(aggregates, hasLength(1));
  });

  test('an answer the call could not act on is offered again', () async {
    applied = false;
    registry.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    await pumpEventQueue();

    expect(aggregates, hasLength(1));

    applied = true;
    registry.report(
      viewportId: 'strip',
      track: track,
      measurement: showing(320, 180),
    );
    await pumpEventQueue();

    expect(
      aggregates,
      hasLength(2),
      reason: 'the first answer never landed, so it was not said again',
    );
    expect(aggregates.last, aggregates.first);
  });

  test('a track every viewport released is forgotten', () async {
    registry.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    registry.release(viewportId: 'grid', track: track);
    await pumpEventQueue();

    aggregates.clear();
    registry.reapplyAll();

    expect(aggregates, isEmpty);
  });
}
