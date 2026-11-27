// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/native_audio_renderer.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

void main() {
  test('isAttachedTo compares the track id', () {
    final renderer = NativeAudioRenderer('alice')..attach(_Track('a'));

    expect(renderer.isAttachedTo(_Track('a')), isTrue);
    expect(renderer.isAttachedTo(_Track('b')), isFalse);
  });

  test('reports its state as it attaches and detaches', () async {
    final renderer = NativeAudioRenderer('alice');
    final states = <AudioRendererState>[];
    renderer.stateChanges.listen(states.add);

    renderer
      ..attach(_Track('a'))
      ..detach();
    await renderer.dispose();

    expect(states, [AudioRendererState.playing, AudioRendererState.detached]);
    expect(renderer.state, AudioRendererState.detached);
  });
}

class _Track extends Fake implements MediaStreamTrack {
  _Track(this.id);

  @override
  final String id;
}
