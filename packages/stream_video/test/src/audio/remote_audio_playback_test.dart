import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/audio/remote_audio_playback.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../fixtures/webrtc_capabilities.dart';

class _MockTrack extends Mock implements rtc.MediaStreamTrack {}

void main() {
  const alice = 'alice:TrackType.audio';
  const bob = 'bob:TrackType.audio';

  late Map<String, _FakeRenderer> renderers;
  late List<(String, Object?)> traces;
  late RemoteAudioPlayback playback;

  setUp(() {
    overrideWebRtcCapabilities(platform: PlatformType.web);
    renderers = {};
    traces = [];
    playback = RemoteAudioPlayback(
      traceHandler: (tag, data) => traces.add((tag, data)),
      createRenderer: (id, {onTrace}) => renderers[id] = _FakeRenderer(id),
    );
  });

  List<Object?> tracesOf(String tag) => [
    for (final (t, data) in traces)
      if (t == tag) data,
  ];

  void onWebKit() {
    overrideWebRtcCapabilities(
      capabilities: webRtcCapabilitiesOf(
        PlatformType.web,
      ).copyWith(needsRemoteAudioReattach: true),
    );
  }

  group('start and stop', () {
    test('a renderer per track id plays the track', () {
      final track = _MockTrack();

      playback.start(alice, track);

      expect(renderers[alice]!.track, same(track));
      expect(renderers[alice]!.isAttached, isTrue);
    });

    test('stopping a track disposes its renderer', () {
      final track = _MockTrack();
      playback
        ..start(alice, track)
        ..stop(alice, track);

      expect(renderers[alice]!.disposed, isTrue);
    });

    test(
      'a superseded session stopping its track leaves the renderer the new '
      'session took over',
      () {
        final oldTrack = _MockTrack();
        final newTrack = _MockTrack();

        // A migration: the new session binds the same id before the old one
        // is disposed.
        playback
          ..start(alice, oldTrack)
          ..start(alice, newTrack)
          ..stop(alice, oldTrack);

        expect(renderers[alice]!.disposed, isFalse);
        expect(renderers[alice]!.track, same(newTrack));

        playback.stop(alice, newTrack);
        expect(renderers[alice]!.disposed, isTrue);
      },
    );
  });

  group('blocked playback', () {
    test('reports whether any renderer is blocked', () async {
      final changes = <bool>[];
      final subscription = playback.blockedChanges.listen(changes.add);
      addTearDown(subscription.cancel);
      playback
        ..start(alice, _MockTrack())
        ..start(bob, _MockTrack());

      renderers[alice]!.setBlocked(true);
      renderers[bob]!.setBlocked(true);
      renderers[alice]!.setBlocked(false);
      renderers[bob]!.setBlocked(false);
      await pumpEventQueue();

      expect(changes, [false, true, false]);
    });

    test('stopping a blocked track unblocks', () async {
      final track = _MockTrack();
      playback.start(alice, track);
      renderers[alice]!.setBlocked(true);
      await pumpEventQueue();

      playback.stop(alice, track);

      expect(await playback.blockedChanges.first, isFalse);
    });

    test('resume retries the blocked and recovering renderers', () async {
      playback
        ..start(alice, _MockTrack())
        ..start(bob, _MockTrack())
        ..start('carol', _MockTrack());
      renderers[alice]!.setBlocked(true);
      renderers[bob]!.recovering = true;

      await playback.resume();

      expect(renderers[alice]!.resumeCount, 1);
      expect(renderers[bob]!.resumeCount, 1);
      expect(renderers['carol']!.resumeCount, 0);
      expect(tracesOf(TraceTag.resumeAudio), [
        {'blockedTracks': 1, 'recoveringTracks': 1},
      ]);
    });
  });

  group('setSinkId', () {
    test('applies the output to the renderer and traces it', () async {
      playback.start(alice, _MockTrack());

      await playback.setSinkId(alice, 'speaker');

      expect(renderers[alice]!.sinkId, 'speaker');
      expect(tracesOf(TraceTag.setSinkId), [
        {'trackId': alice, 'deviceId': 'speaker'},
      ]);
    });

    test('is deferred for a track that has not started', () async {
      await playback.setSinkId(alice, 'speaker');

      expect(tracesOf(TraceTag.setSinkId), [
        {'trackId': alice, 'deviceId': 'speaker', 'deferred': true},
      ]);
    });

    test('throws once traced where the browser cannot select it', () async {
      overrideWebRtcCapabilities(
        capabilities: webRtcCapabilitiesOf(
          PlatformType.web,
        ).copyWith(supportsAudioOutputSelection: false),
      );
      playback.start(alice, _MockTrack());

      await expectLater(
        playback.setSinkId(alice, 'speaker'),
        throwsUnsupportedError,
      );
      await expectLater(
        playback.setSinkId(alice, 'speaker'),
        throwsUnsupportedError,
      );

      expect(tracesOf(TraceTag.setSinkId), hasLength(1));
    });

    test(
      'a renderer without sink selection traces it as unsupported',
      () async {
        playback.start(alice, _MockTrack());
        renderers[alice]!.sinkError = UnsupportedError('no setSinkId');

        await expectLater(
          playback.setSinkId(alice, 'speaker'),
          throwsUnsupportedError,
        );
        expect(tracesOf(TraceTag.setSinkId), [
          {'trackId': alice, 'deviceId': 'speaker', 'error': 'unsupported'},
        ]);
      },
    );

    test('does nothing where the platform selects the output', () async {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      playback.start(alice, _MockTrack());

      await playback.setSinkId(alice, 'speaker');

      expect(renderers[alice]!.sinkId, isNull);
      expect(traces, isEmpty);
    });
  });

  group('reattach on WebKit', () {
    setUp(onWebKit);

    test('attaches every renderer again to the track it played', () async {
      final aliceTrack = _MockTrack();
      final bobTrack = _MockTrack();
      playback
        ..start(alice, aliceTrack)
        ..start(bob, bobTrack);

      await playback.reattach(reason: 'subscriberOffer');

      expect(renderers[alice]!.attached, [aliceTrack, aliceTrack]);
      expect(renderers[bob]!.attached, [bobTrack, bobTrack]);
      expect(tracesOf(TraceTag.audioPlaybackReattach), [
        {'reason': 'subscriberOffer', 'tracks': 2, 'blockedTracks': 0},
      ]);
    });

    // A detach and re-attach in one task is seen by the element as one swap,
    // which is the case this works around.
    test('leaves the renderers detached while it waits', () async {
      playback.start(alice, _MockTrack());

      final reattach = playback.reattach(reason: 'subscriberOffer');

      expect(renderers[alice]!.isAttached, isFalse);
      await reattach;
      expect(renderers[alice]!.isAttached, isTrue);
    });

    test('a call made while one waits joins it', () async {
      playback.start(alice, _MockTrack());

      final first = playback.reattach(reason: 'subscriberOffer');
      final second = playback.reattach(reason: 'subscriberOffer');

      expect(second, same(first));
      await second;
      expect(tracesOf(TraceTag.audioPlaybackReattach), hasLength(1));
    });

    test('a call made once the wait is over starts its own', () async {
      playback.start(alice, _MockTrack());

      await playback.reattach(reason: 'subscriberOffer');
      await playback.reattach(reason: 'subscriberOffer');

      expect(tracesOf(TraceTag.audioPlaybackReattach), hasLength(2));
    });

    // Joining a failed re-attach would turn re-attach off for the rest of the
    // page.
    test('a call after one that failed starts its own', () async {
      var failTrace = true;
      playback = RemoteAudioPlayback(
        traceHandler: (tag, data) {
          if (failTrace) throw StateError('tracer failed');
          traces.add((tag, data));
        },
        createRenderer: (id, {onTrace}) => renderers[id] = _FakeRenderer(id),
      );
      final track = _MockTrack();
      playback.start(alice, track);

      await expectLater(
        playback.reattach(reason: 'subscriberOffer'),
        throwsStateError,
      );

      failTrace = false;
      await playback.reattach(reason: 'subscriberOffer');

      expect(tracesOf(TraceTag.audioPlaybackReattach), hasLength(1));
      expect(renderers[alice]!.attached, [track, track]);
    });

    test('a track stopped while it waits stays stopped', () async {
      final aliceTrack = _MockTrack();
      playback
        ..start(alice, aliceTrack)
        ..start(bob, _MockTrack());

      final reattach = playback.reattach(reason: 'subscriberOffer');
      playback.stop(alice, aliceTrack);
      await reattach;

      expect(renderers[alice]!.attached, hasLength(1));
      expect(renderers[bob]!.isAttached, isTrue);
    });

    test('a track started while it waits keeps its own attach', () async {
      final replacement = _MockTrack();
      playback.start(alice, _MockTrack());

      final reattach = playback.reattach(reason: 'subscriberOffer');
      playback.start(alice, replacement);
      await reattach;

      expect(renderers[alice]!.attached.last, same(replacement));
      expect(renderers[alice]!.attached, hasLength(2));
    });

    test('does nothing with no audio playing', () async {
      await playback.reattach(reason: 'subscriberOffer');

      expect(tracesOf(TraceTag.audioPlaybackReattach), isEmpty);
    });
  });

  test('reattach leaves other browsers alone', () async {
    playback.start(alice, _MockTrack());

    final reattach = playback.reattach(reason: 'subscriberOffer');

    expect(renderers[alice]!.isAttached, isTrue);
    await reattach;
    expect(renderers[alice]!.attached, hasLength(1));
    expect(tracesOf(TraceTag.audioPlaybackReattach), isEmpty);
  });

  test('needsReattach holds where the capability says so', () {
    expect(playback.needsReattach, isFalse);

    onWebKit();
    expect(playback.needsReattach, isTrue);
  });
}

class _FakeRenderer implements rtc.RTCAudioRenderer {
  _FakeRenderer(this.id);

  @override
  final String id;

  /// Every track [attach] was called with.
  final attached = <rtc.MediaStreamTrack>[];

  bool disposed = false;
  int resumeCount = 0;
  String? sinkId;
  Error? sinkError;

  bool recovering = false;

  bool _attached = false;
  bool _blocked = false;
  final _blockedController = StreamController<bool>.broadcast(sync: true);

  void setBlocked(bool blocked) {
    _blocked = blocked;
    _blockedController.add(blocked);
  }

  @override
  rtc.MediaStreamTrack? get track => attached.lastOrNull;

  @override
  bool get isAttached => _attached;

  @override
  void attach(rtc.MediaStreamTrack track) {
    attached.add(track);
    _attached = true;
  }

  @override
  void detach() => _attached = false;

  @override
  bool isAttachedTo(rtc.MediaStreamTrack track) => identical(this.track, track);

  @override
  bool muted = false;

  @override
  Future<void> setSinkId(String deviceId) async {
    if (sinkError case final error?) throw error;
    sinkId = deviceId;
  }

  @override
  bool get isBlocked => _blocked;

  @override
  Stream<bool> get playbackBlocked => _blockedController.stream;

  @override
  bool get isRecovering => recovering;

  @override
  Future<void> resume() async => resumeCount++;

  @override
  Future<void> dispose() async {
    disposed = true;
    _attached = false;
    if (_blocked) setBlocked(false);
  }
}
