@TestOn('browser')
library;

// ignore_for_file: implementation_imports

import 'dart:js_interop';

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/webrtc/rtc_audio_api/rtc_audio_html.dart';
import 'package:web/web.dart' as web;

/// A live remote-like audio track, generated so no device is needed.
MediaStreamTrackWeb _audioTrack() {
  final destination = web.AudioContext().createMediaStreamDestination();
  return MediaStreamTrackWeb(destination.stream.getAudioTracks().toDart.first);
}

web.HTMLAudioElement? _element(String id) {
  return web.document.getElementById(audioPrefix + id) as web.HTMLAudioElement?;
}

web.MediaStream? _stream(String id) =>
    _element(id)?.srcObject as web.MediaStream?;

String? _playingTrackId(String id) {
  return _stream(id)?.getAudioTracks().toDart.single.id;
}

void main() {
  const alice = 'alice:TrackType.audio';
  const bob = 'bob:TrackType.audio';

  late List<Map<String, Object?>> reattachTraces;

  // The track each id was last started with, which is the one [stopAudio]
  // has to be handed to remove the element.
  final started = <String, MediaStreamTrackWeb>{};

  void start(String id, MediaStreamTrackWeb track) {
    started[id] = track;
    startAudio(id, track);
  }

  setUp(() {
    reattachTraces = [];
    setAudioTraceHandler((tag, data) {
      if (tag != TraceTag.audioPlaybackReattach) return;
      reattachTraces.add((data! as Map).cast<String, Object?>());
    });
  });

  tearDown(() {
    for (final MapEntry(key: id, value: track) in started.entries) {
      stopAudio(id, track);
    }
    started.clear();
    setAudioTraceHandler(null);
    debugOverrideIsWebKit(null);
  });

  group('reattachRemoteAudio on WebKit', () {
    setUp(() => debugOverrideIsWebKit(true));

    test('gives every element a fresh stream of the track it played', () async {
      final aliceTrack = _audioTrack();
      final bobTrack = _audioTrack();
      start(alice, aliceTrack);
      start(bob, bobTrack);
      final aliceStream = _stream(alice)!.id;
      final bobStream = _stream(bob)!.id;

      await reattachRemoteAudio(reason: 'subscriberOffer');

      expect(_stream(alice)!.id, isNot(aliceStream));
      expect(_stream(bob)!.id, isNot(bobStream));
      expect(_playingTrackId(alice), aliceTrack.jsTrack.id);
      expect(_playingTrackId(bob), bobTrack.jsTrack.id);
      expect(reattachTraces, [
        {'reason': 'subscriberOffer', 'tracks': 2, 'blockedTracks': 0},
      ]);
    });

    // A detach and re-attach in one task is seen by the element as one swap,
    // which is the case this works around.
    test('leaves the elements empty while it waits', () async {
      start(alice, _audioTrack());

      final reattach = reattachRemoteAudio(reason: 'subscriberOffer');

      expect(_stream(alice), isNull);
      await reattach;
      expect(_stream(alice), isNotNull);
    });

    test('a call made while one waits joins it', () async {
      final track = _audioTrack();
      start(alice, track);

      final first = reattachRemoteAudio(reason: 'subscriberOffer');
      final second = reattachRemoteAudio(reason: 'subscriberOffer');

      expect(second, same(first));
      await second;
      expect(_playingTrackId(alice), track.jsTrack.id);
      expect(reattachTraces, hasLength(1));
    });

    test('a call made once the wait is over starts its own', () async {
      start(alice, _audioTrack());

      await reattachRemoteAudio(reason: 'subscriberOffer');
      await reattachRemoteAudio(reason: 'subscriberOffer');

      expect(reattachTraces, hasLength(2));
    });

    // Joining a failed re-attach would turn re-attach off for the rest of the
    // page.
    test('a call after one that failed starts its own', () async {
      final track = _audioTrack();
      start(alice, track);
      setAudioTraceHandler((_, _) => throw StateError('tracer failed'));

      await expectLater(
        reattachRemoteAudio(reason: 'subscriberOffer'),
        throwsStateError,
      );

      setAudioTraceHandler((tag, data) {
        if (tag != TraceTag.audioPlaybackReattach) return;
        reattachTraces.add((data! as Map).cast<String, Object?>());
      });
      await reattachRemoteAudio(reason: 'subscriberOffer');

      expect(reattachTraces, hasLength(1));
      expect(_playingTrackId(alice), track.jsTrack.id);
    });

    test('a track stopped while it waits stays stopped', () async {
      start(alice, _audioTrack());
      start(bob, _audioTrack());

      final reattach = reattachRemoteAudio(reason: 'subscriberOffer');
      stopAudio(alice, started[alice]!);
      await reattach;

      expect(_element(alice), isNull);
      expect(_stream(bob), isNotNull);
    });

    test('a track started while it waits keeps its own stream', () async {
      start(alice, _audioTrack());
      final replacement = _audioTrack();

      final reattach = reattachRemoteAudio(reason: 'subscriberOffer');
      start(alice, replacement);
      final started = _stream(alice)!.id;
      await reattach;

      expect(_stream(alice)!.id, started);
      expect(_playingTrackId(alice), replacement.jsTrack.id);
    });

    test('does nothing with no audio playing', () async {
      await reattachRemoteAudio(reason: 'subscriberOffer');

      expect(reattachTraces, isEmpty);
    });
  });

  test('reattachRemoteAudio leaves other browsers alone', () async {
    debugOverrideIsWebKit(false);
    start(alice, _audioTrack());
    final stream = _stream(alice)!.id;

    final reattach = reattachRemoteAudio(reason: 'subscriberOffer');

    expect(_stream(alice)!.id, stream);
    await reattach;
    expect(_stream(alice)!.id, stream);
    expect(reattachTraces, isEmpty);
  });

  test('needsRemoteAudioReattach holds on WebKit only', () {
    debugOverrideIsWebKit(true);
    expect(needsRemoteAudioReattach(), isTrue);

    debugOverrideIsWebKit(false);
    expect(needsRemoteAudioReattach(), isFalse);
  });

  group('checkIfAudioOutputChangeSupported', () {
    test('is false on WebKit', () {
      debugOverrideIsWebKit(true);

      expect(checkIfAudioOutputChangeSupported(), isFalse);
    });

    // Chrome, which runs these tests, has `setSinkId`.
    test('is true elsewhere where the browser has setSinkId', () {
      debugOverrideIsWebKit(false);

      expect(checkIfAudioOutputChangeSupported(), isTrue);
    });
  });

  group('stopAudio', () {
    const id = 'participant:TrackType.audio';

    tearDown(() {
      _element(id)?.remove();
    });

    test('stopping a track removes its audio element', () {
      final track = _audioTrack();
      startAudio(id, track);

      stopAudio(id, track);

      expect(_element(id), isNull);
    });

    test(
      'a superseded session stopping its track leaves the element the new '
      'session took over',
      () {
        final oldTrack = _audioTrack();
        final newTrack = _audioTrack();

        // A migration: the new session binds the same id before the old one
        // is disposed.
        startAudio(id, oldTrack);
        startAudio(id, newTrack);
        stopAudio(id, oldTrack);

        expect(_element(id), isNotNull);
        expect(_playingTrackId(id), newTrack.jsTrack.id);

        stopAudio(id, newTrack);

        expect(_element(id), isNull);
      },
    );
  });
}
