@TestOn('browser')
library;

// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_dart_webrtc/src/third_party/dart_webrtc/media_stream_track_impl.dart';
import 'package:stream_dart_webrtc/src/web_audio_renderer.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

/// A live remote-like audio track, generated so no device is needed.
MediaStreamTrackWeb _audioTrack() {
  final destination = web.AudioContext().createMediaStreamDestination();
  return MediaStreamTrackWeb(destination.stream.getAudioTracks().toDart.first);
}

web.HTMLAudioElement? _element(String id) {
  return web.document.getElementById(audioElementPrefix + id)
      as web.HTMLAudioElement?;
}

String? _playingTrackId(String id) {
  final stream = _element(id)?.srcObject as web.MediaStream?;
  return stream?.getAudioTracks().toDart.single.id;
}

void main() {
  const id = 'participant:TrackType.audio';

  late WebAudioRenderer renderer;

  setUp(() => renderer = WebAudioRenderer(id));
  tearDown(() async {
    await renderer.dispose();
    await setAudioPlayoutPaused(false);
  });

  test('attaching creates the element in the container', () {
    final track = _audioTrack();

    renderer.attach(track);

    expect(_element(id)!.parentElement!.id, audioContainerId);
    expect(_playingTrackId(id), track.jsTrack.id);
    expect(renderer.isAttached, isTrue);
  });

  test('detaching empties the element and attaching fills it again', () {
    final track = _audioTrack();
    renderer
      ..attach(track)
      ..detach();

    expect(_element(id)!.srcObject, isNull);
    expect(renderer.isAttached, isFalse);
    expect(renderer.track, same(track));

    renderer.attach(track);
    expect(_playingTrackId(id), track.jsTrack.id);
  });

  test('isAttachedTo compares the underlying track', () {
    final track = _audioTrack();
    renderer.attach(track);

    expect(renderer.isAttachedTo(MediaStreamTrackWeb(track.jsTrack)), isTrue);
    expect(renderer.isAttachedTo(_audioTrack()), isFalse);
  });

  test('dispose removes the element', () async {
    renderer.attach(_audioTrack());

    await renderer.dispose();

    expect(_element(id), isNull);
  });

  test('paused playout mutes live renderers and new ones', () async {
    renderer.attach(_audioTrack());

    await setAudioPlayoutPaused(true);
    expect(_element(id)!.muted, isTrue);

    final other = WebAudioRenderer('other')..attach(_audioTrack());
    addTearDown(other.dispose);
    expect(_element('other')!.muted, isTrue);

    await setAudioPlayoutPaused(false);
    expect(_element(id)!.muted, isFalse);
  });

  test('reports its state as it attaches and detaches', () {
    final states = <AudioRendererState>[];
    renderer.stateChanges.listen(states.add);

    renderer.attach(_audioTrack());
    expect(renderer.state, AudioRendererState.playing);
    renderer.detach();

    expect(states, [AudioRendererState.playing, AudioRendererState.detached]);
  });

  test('a mute set before attaching is kept', () {
    renderer
      ..muted = true
      ..attach(_audioTrack());

    expect(_element(id)!.muted, isTrue);
    expect(renderer.muted, isTrue);
  });

  test('attaching a track of another implementation throws', () {
    expect(() => renderer.attach(_OtherTrack()), throwsArgumentError);
  });

  // Chrome, which runs these tests, has `setSinkId`.
  test('an output picked before attaching is not refused', () async {
    await renderer.setSinkId('default');
    renderer.attach(_audioTrack());

    expect(_element(id), isNotNull);
  });
}

class _OtherTrack extends Fake implements MediaStreamTrack {}
