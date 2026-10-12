@TestOn('browser')
library;

// ignore_for_file: implementation_imports

import 'dart:js_interop';

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:flutter_test/flutter_test.dart';
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

String? _playingTrackId(String id) {
  final stream = _element(id)?.srcObject as web.MediaStream?;
  return stream?.getAudioTracks().toDart.single.id;
}

void main() {
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

      // A migration: the new session binds the same id before the old one is
      // disposed.
      startAudio(id, oldTrack);
      startAudio(id, newTrack);
      stopAudio(id, oldTrack);

      expect(_element(id), isNotNull);
      expect(_playingTrackId(id), newTrack.jsTrack.id);

      stopAudio(id, newTrack);

      expect(_element(id), isNull);
    },
  );
}
