import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/media/local_media_filters.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../webrtc/fixtures/rtc_manager_fakes.dart';

void main() {
  late List<String> log;
  late LocalMediaFilters filters;

  setUp(() {
    log = [];
    filters = LocalMediaFilters();
  });

  RtcLocalTrack camera(String id) => _track(id, SfuTrackType.video, 'video');

  group('a new capture', () {
    test('runs the chain of its kind on it', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));

      await filters.apply(camera('cam-1'));

      expect(log, ['blur apply cam-1']);
    });

    test('stops the filters of the capture it replaces', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));

      await filters.apply(camera('cam-1'));
      await filters.apply(camera('cam-2'));

      expect(log, ['blur apply cam-1', 'blur stop cam-1', 'blur apply cam-2']);
    });

    test('is not filtered again when it is published later', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      final preview = camera('cam-1');

      await filters.apply(preview);
      final published = await filters.apply(preview.copyWith());

      expect(log, ['blur apply cam-1']);
      expect(published.mediaTrack, same(preview.mediaTrack));
    });

    test('is sent as the stream the chain made of it', () async {
      final output = _FakeStream([
        FakeMediaStreamTrack('out', kind: 'video'),
      ]);
      await filters.setVideoFilter(_ReplacingFilter(output));

      final filtered = await filters.apply(camera('cam-1'));

      expect(filtered.mediaStream, same(output));
      expect(filtered.mediaTrack.id, 'out');
    });

    test('skips a filter that fails', () async {
      await filters.setVideoFilter(_FailingFilter());
      await filters.setModerationFilter(_LoggingFilter('mod', log));

      final filtered = await filters.apply(camera('cam-1'));

      expect(log, ['mod apply cam-1']);
      expect(filtered.mediaTrack.id, 'cam-1');
    });

    test('of the screen share audio is not filtered', () async {
      await filters.setAudioFilter(_LoggingAudioFilter('nc', log));

      await filters.apply(
        _track('share-audio', SfuTrackType.screenShareAudio, 'audio'),
      );
      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      expect(log, ['nc apply mic']);
    });

    test('of another kind keeps the camera filters', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setScreenShareFilter(_LoggingFilter('share', log));

      await filters.apply(camera('cam-1'));
      await filters.apply(_track('screen', SfuTrackType.screenShare, 'video'));

      expect(log, ['blur apply cam-1', 'share apply screen']);
    });
  });

  group('a change of filter', () {
    test('applies to the capture in use', () async {
      await filters.apply(camera('cam-1'));

      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setVideoFilter(_LoggingFilter('image', log));
      await filters.setVideoFilter(null);

      expect(log, [
        'blur apply cam-1',
        'blur stop cam-1',
        'image apply cam-1',
        'image stop cam-1',
      ]);
      expect(filters.videoFilter, isNull);
    });

    test('before any capture applies to the first one', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      expect(log, isEmpty);

      await filters.apply(camera('cam-1'));

      expect(log, ['blur apply cam-1']);
    });

    test(
      'to one that replaces the stream waits for the next capture',
      () async {
        await filters.apply(camera('cam-1'));

        await filters.setVideoFilter(_ReplacingFilter(_FakeStream([])));
        await filters.setVideoFilter(_LoggingFilter('blur', log));

        expect(log, ['blur apply cam-1']);
      },
    );
  });

  group('the moderation filter', () {
    test('runs after the app filter', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setModerationFilter(_LoggingFilter('mod', log));

      await filters.apply(camera('cam-1'));

      expect(log, ['blur apply cam-1', 'mod apply cam-1']);
    });

    test('leaves the app filter alone once removed', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(camera('cam-1'));
      await filters.setModerationFilter(_LoggingFilter('mod', log));
      log.clear();

      await filters.setModerationFilter(null);

      expect(log, ['mod stop cam-1', 'blur stop cam-1', 'blur apply cam-1']);
    });

    test('keeps a filter picked while it is on', () async {
      await filters.apply(camera('cam-1'));
      await filters.setModerationFilter(_LoggingFilter('mod', log));
      await filters.setVideoFilter(_LoggingFilter('image', log));
      log.clear();

      await filters.setModerationFilter(null);

      expect(log, ['mod stop cam-1', 'image stop cam-1', 'image apply cam-1']);
      expect(filters.videoFilter, isA<_LoggingFilter>());
    });
  });

  test('stopAll stops every applied filter and keeps the chains', () async {
    await filters.setVideoFilter(_LoggingFilter('blur', log));
    await filters.setAudioFilter(_LoggingAudioFilter('nc', log));
    await filters.apply(camera('cam-1'));
    await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));
    log.clear();

    await filters.stopAll();
    await filters.apply(camera('cam-1'));

    expect(log, ['blur stop cam-1', 'nc stop mic', 'blur apply cam-1']);
  });

  test('a failing stop is logged and the next capture still applies', () async {
    await filters.setVideoFilter(_FailingStopFilter(log));

    await filters.apply(camera('cam-1'));
    await filters.apply(camera('cam-2'));

    expect(log, ['apply cam-1', 'apply cam-2']);
  });
}

RtcLocalTrack _track(String id, SfuTrackType trackType, String kind) {
  final track = FakeMediaStreamTrack(id, kind: kind);
  return RtcLocalTrack(
    trackIdPrefix: 'test',
    trackType: trackType,
    mediaStream: _FakeStream([track]),
    mediaTrack: track,
    mediaConstraints: const AudioConstraints(),
  );
}

String _firstTrackId(rtc.MediaStream stream) => stream.getTracks().first.id!;

class _LoggingFilter extends VideoFilter {
  _LoggingFilter(this.name, this.log);

  final String name;
  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    final id = _firstTrackId(input);
    log.add('$name apply $id');
    return MediaStreamFilterResult(
      input,
      stop: () => log.add('$name stop $id'),
    );
  }
}

class _LoggingAudioFilter extends AudioFilter {
  _LoggingAudioFilter(this.name, this.log);

  final String name;
  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    final id = _firstTrackId(input);
    log.add('$name apply $id');
    return MediaStreamFilterResult(
      input,
      stop: () => log.add('$name stop $id'),
    );
  }
}

class _ReplacingFilter extends VideoFilter {
  _ReplacingFilter(this.output);

  final rtc.MediaStream output;

  @override
  Future<MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    return MediaStreamFilterResult(output);
  }
}

class _FailingFilter extends VideoFilter {
  @override
  Future<MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    throw Exception('filter failed');
  }
}

class _FailingStopFilter extends VideoFilter {
  _FailingStopFilter(this.log);

  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    log.add('apply ${_firstTrackId(input)}');
    return MediaStreamFilterResult(
      input,
      stop: () => throw Exception('stop failed'),
    );
  }
}

class _FakeStream extends Fake implements rtc.MediaStream {
  _FakeStream(this._tracks);

  final List<rtc.MediaStreamTrack> _tracks;

  @override
  List<rtc.MediaStreamTrack> getTracks() => _tracks;

  @override
  List<rtc.MediaStreamTrack> getVideoTracks() =>
      _tracks.where((it) => it.kind == 'video').toList();

  @override
  List<rtc.MediaStreamTrack> getAudioTracks() =>
      _tracks.where((it) => it.kind == 'audio').toList();
}
