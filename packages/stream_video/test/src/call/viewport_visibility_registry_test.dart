import 'package:fake_async/fake_async.dart';
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

  /// The viewports most of these are about: a grid tile and an overlay.
  late ViewportHandle grid;
  late ViewportHandle pip;

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
    grid = registry.attach();
    pip = registry.attach();
  });

  test('one viewport speaks for the track', () {
    grid.report(track, showing(640, 360));

    expect(aggregates.single.visibility, ViewportVisibility.visible);
    expect(
      aggregates.single.dimension,
      const RtcVideoDimension(width: 640, height: 360),
    );
  });

  test('a viewport saying the same thing again is not passed on', () {
    grid
      ..report(track, showing(640, 360))
      ..report(track, showing(640, 360));

    expect(aggregates, hasLength(1));
  });

  test('a track stays visible while any viewport still shows it', () {
    grid.report(track, showing(640, 360));
    pip.report(track, hidden);

    // What the off-screen overlay measures is true of the overlay, not of the
    // participant: they are still on screen in the grid.
    expect(
      aggregates.map((aggregate) => aggregate.visibility),
      [ViewportVisibility.visible],
    );
  });

  test('a track goes hidden once the last viewport showing it stops', () {
    grid.report(track, showing(640, 360));
    pip.report(track, hidden);
    grid.report(track, hidden);

    expect(aggregates.last.visibility, ViewportVisibility.hidden);
    expect(aggregates.last.dimension.isEmpty, isTrue);
  });

  test('the track is sized for the largest viewport showing it', () {
    // The largest speaks first, so the answer is not simply the last one in.
    grid.report(track, showing(1280, 720));
    pip.report(track, showing(320, 180));

    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 1280, height: 720),
    );
  });

  test('a viewport that is not showing the track does not size it', () {
    grid.report(track, showing(1280, 720));
    pip
      ..report(track, showing(320, 180))
      ..report(track, hidden);

    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 1280, height: 720),
    );
  });

  test('releasing the largest viewport drops the track to the next one', () {
    grid.report(track, showing(1280, 720));
    pip.report(track, showing(320, 180));
    grid.release();

    expect(aggregates.last.visibility, ViewportVisibility.visible);
    expect(
      aggregates.last.dimension,
      const RtcVideoDimension(width: 320, height: 180),
    );
  });

  test('a track no viewport draws any more is reported hidden once', () {
    fakeAsync((async) {
      grid
        ..report(track, showing(640, 360))
        ..release()
        ..release();
      async.elapse(registry.releaseGrace);

      expect(aggregates.last.visibility, ViewportVisibility.hidden);
      expect(aggregates, hasLength(2));
    });
  });

  // A participant moving between layouts is a viewport torn down and another
  // built, and nothing measures their track in between. Reported hidden there,
  // the track is unsubscribed and resubscribed a moment later, which costs the
  // tile its picture.
  test('a track another viewport picks up within the grace is not dropped', () {
    fakeAsync((async) {
      grid.report(track, showing(1280, 720));
      grid.release();
      async.elapse(registry.releaseGrace - const Duration(milliseconds: 1));

      expect(
        aggregates.last.visibility,
        ViewportVisibility.visible,
        reason: 'the handover has not been given up on yet',
      );
      expect(aggregates, hasLength(1));

      // The tile the participant moved into, now that it has measured itself.
      registry.attach().report(track, showing(320, 180));
      async.elapse(registry.releaseGrace);

      expect(
        aggregates.map((aggregate) => aggregate.visibility),
        everyElement(ViewportVisibility.visible),
        reason: 'the track was on screen throughout, at two sizes',
      );
      expect(
        aggregates.last.dimension,
        const RtcVideoDimension(width: 320, height: 180),
      );
    });
  });

  test('the grace runs from the release, not from the report before it', () {
    fakeAsync((async) {
      grid.report(track, showing(640, 360));
      async.elapse(const Duration(seconds: 5));
      grid.release();
      async.elapse(registry.releaseGrace - const Duration(milliseconds: 1));

      expect(aggregates, hasLength(1));

      async.elapse(const Duration(milliseconds: 1));

      expect(aggregates.last.visibility, ViewportVisibility.hidden);
    });
  });

  test('a grace of zero reports the track hidden at once', () {
    final immediate = ViewportVisibilityRegistry(
      onAggregate: (aggregate) async {
        aggregates.add(aggregate);
        return true;
      },
      releaseGrace: Duration.zero,
    );

    immediate.attach()
      ..report(track, showing(640, 360))
      ..release();

    expect(aggregates.last.visibility, ViewportVisibility.hidden);
  });

  test('a call cleared mid-grace never reports the track hidden', () {
    fakeAsync((async) {
      grid
        ..report(track, showing(640, 360))
        ..release();
      registry.clear();
      async.elapse(registry.releaseGrace * 2);

      expect(aggregates, hasLength(1));
      expect(aggregates.single.visibility, ViewportVisibility.visible);
    });
  });

  test('a viewport that wants the track kept while hidden says so for all', () {
    grid.report(track, hidden);
    pip.report(
      track,
      const ViewportMeasurement(
        visibility: ViewportVisibility.hidden,
        persistWhenHidden: true,
      ),
    );

    expect(aggregates.last.persistWhenHidden, isTrue);
  });

  test('tracks are kept apart', () {
    grid.report(track, showing(640, 360));
    pip.report(otherTrack, showing(320, 180));

    expect(aggregates.map((aggregate) => aggregate.track), [track, otherTrack]);
  });

  // A handle is one viewport, and a viewport draws one track at a time. Left
  // behind, the track it drew before would still be counted as on screen.
  test('a viewport reporting a new track lets go of the one before', () {
    fakeAsync((async) {
      grid.report(track, showing(640, 360));
      aggregates.clear();

      grid.report(otherTrack, showing(320, 180));
      async.elapse(registry.releaseGrace);

      expect(
        aggregates.map((aggregate) => (aggregate.track, aggregate.visibility)),
        [
          (otherTrack, ViewportVisibility.visible),
          (track, ViewportVisibility.hidden),
        ],
        reason: 'the track it left is held for the grace, the new one is not',
      );
    });
  });

  test('a viewport that has been disposed of says nothing more', () {
    grid.report(track, showing(640, 360));
    grid.dispose();
    aggregates.clear();

    grid.report(track, showing(640, 360));

    expect(grid.isDisposed, isTrue);
    expect(aggregates, isEmpty);
  });

  test(
    'reapply says a standing answer again, for a track only now published',
    () {
      grid.report(track, showing(640, 360));
      registry.reapply(track);

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
    grid.report(track, showing(640, 360));
    pip.report(otherTrack, showing(320, 180));

    aggregates.clear();
    registry.reapplyAll();

    expect(aggregates.map((aggregate) => aggregate.track), [track, otherTrack]);
  });

  test('a cleared registry has nothing left to say', () {
    grid.report(track, showing(640, 360));

    aggregates.clear();
    registry
      ..clear()
      ..reapplyAll();

    expect(aggregates, isEmpty);
  });

  test('an answer the call acted on is not offered again', () async {
    grid.report(track, showing(640, 360));
    await pumpEventQueue();

    // A smaller viewport does not move the answer: the largest one showing the
    // track still sizes it.
    pip.report(track, showing(320, 180));
    await pumpEventQueue();

    expect(aggregates, hasLength(1));
  });

  test('an answer the call could not act on is offered again', () async {
    applied = false;
    grid.report(track, showing(640, 360));
    await pumpEventQueue();

    expect(aggregates, hasLength(1));

    applied = true;
    pip.report(track, showing(320, 180));
    await pumpEventQueue();

    expect(
      aggregates,
      hasLength(2),
      reason: 'the first answer never landed, so it was not said again',
    );
    expect(aggregates.last, aggregates.first);
  });

  test('a track every viewport released is forgotten', () async {
    grid
      ..report(track, showing(640, 360))
      ..release();
    await pumpEventQueue();

    aggregates.clear();
    registry.reapplyAll();

    expect(aggregates, isEmpty);
  });
}
