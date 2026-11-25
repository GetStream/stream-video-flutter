import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/media/local_media_filters.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../logger/impl/test_logger.dart';
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

      expect(log, ['blur apply cam-1 camera']);
    });

    test('stops the filters of the capture it replaces', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));

      await filters.apply(camera('cam-1'));
      await filters.apply(camera('cam-2'));

      expect(log, [
        'blur apply cam-1 camera',
        'blur stop cam-1 captureReplaced',
        'blur apply cam-2 camera',
      ]);
    });

    test('is not filtered again when it is published later', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      final preview = camera('cam-1');

      await filters.apply(preview);
      final published = await filters.apply(preview.copyWith());

      expect(log, ['blur apply cam-1 camera']);
      expect(published.mediaTrack, same(preview.mediaTrack));
    });

    test('is sent as the stream the chain made of it', () async {
      final output = _stream('out', 'video');
      await filters.setVideoFilter(_ReplacingFilter(output, log));
      final capture = camera('cam-1');

      final filtered = await filters.apply(capture);

      expect(filtered.mediaStream, same(output));
      expect(filtered.mediaTrack.id, 'out');
      expect(filtered.capturedStream, same(capture.mediaStream));
      expect(filtered.capturedTrack, same(capture.mediaTrack));
    });

    test('published again as the capture is sent as the output', () async {
      final output = _stream('out', 'video');
      await filters.setVideoFilter(_ReplacingFilter(output, log));
      final capture = camera('cam-1');
      await filters.apply(capture);

      final again = await filters.apply(capture);

      expect(again.mediaStream, same(output));
      expect(log, ['replace apply cam-1']);
    });

    test('skips a filter that fails and runs the rest of the chain', () async {
      await filters.setVideoFilter(_FailingFilter());
      await filters.setModerationFilter(_LoggingFilter('mod', log));

      final filtered = await filters.apply(camera('cam-1'));

      expect(filtered.mediaTrack.id, 'cam-1');
      expect(log, ['mod apply cam-1 camera']);
    });

    test('skips a filter whose output has no track of its kind', () async {
      await filters.setVideoFilter(
        _ReplacingFilter(_stream('out', 'audio'), log),
      );

      final filtered = await filters.apply(camera('cam-1'));

      expect(filtered.mediaTrack.id, 'cam-1');
      expect(log, ['replace apply cam-1', 'replace stop rejected']);
    });

    test('is not sent while the moderation filter fails on it', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setModerationFilter(_FailingFilter());

      await expectLater(filters.apply(camera('cam-1')), throwsException);
      expect(log, [
        'blur apply cam-1 camera',
        'blur stop cam-1 rejected',
      ]);
    });

    test('that no longer replaces the held one leaves it alone', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(camera('cam-1'));

      await expectLater(
        filters.apply(camera('cam-2'), isCurrent: () => false),
        throwsStateError,
      );
      expect(log, ['blur apply cam-1 camera']);
    });

    test('of the screen share audio is not filtered', () async {
      await filters.setAudioFilter(_LoggingAudioFilter('nc', log));

      await filters.apply(
        _track('share-audio', SfuTrackType.screenShareAudio, 'audio'),
      );
      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      expect(log, ['nc apply mic microphone']);
    });

    test('of another kind keeps the camera filters', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setScreenShareFilter(_LoggingFilter('share', log));

      await filters.apply(camera('cam-1'));
      await filters.apply(_track('screen', SfuTrackType.screenShare, 'video'));

      expect(log, [
        'blur apply cam-1 camera',
        'share apply screen screenShare',
      ]);
    });
  });

  group('a change of filter', () {
    test('applies the new chain before stopping the old one', () async {
      await filters.apply(camera('cam-1'));

      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setVideoFilter(_LoggingFilter('image', log));
      await filters.setVideoFilter(null);

      expect(log, [
        'blur apply cam-1 camera',
        'image apply cam-1 camera',
        'blur stop cam-1 chainChanged',
        'image stop cam-1 chainChanged',
      ]);
      expect(filters.videoFilter, isNull);
    });

    test('reports it applied to the capture in use', () async {
      await filters.apply(camera('cam-1'));

      final result = await filters.setVideoFilter(_LoggingFilter('b', log));

      expect(result, const Result.success(LocalFilterChange.applied));
    });

    test('before any capture applies to the first one', () async {
      final result = await filters.setVideoFilter(_LoggingFilter('b', log));
      expect(result, const Result.success(LocalFilterChange.deferred));
      expect(log, isEmpty);

      await filters.apply(camera('cam-1'));

      expect(log, ['b apply cam-1 camera']);
    });

    test('fails when a filter of the chain fails, keeping the previous '
        'filter', () async {
      final blur = _LoggingFilter('blur', log);
      await filters.setVideoFilter(blur);
      await filters.apply(camera('cam-1'));

      final result = await filters.setVideoFilter(_FailingFilter());

      expect(result.isFailure, isTrue);
      expect(filters.videoFilter, same(blur));
      expect(log, ['blur apply cam-1 camera']);
    });

    test('to one that replaces the stream sends the new stream', () async {
      final sent = <SfuTrackType>[];
      filters.onOutputChanged = (kind) async {
        sent.add(kind);
        log.add('send');
        return const Result.success(none);
      };
      final capture = camera('cam-1');
      final output = _stream('out', 'video');
      await filters.apply(capture);

      await filters.setVideoFilter(_ReplacingFilter(output, log));
      final held = await filters.apply(capture);
      await filters.setVideoFilter(null);
      final restored = await filters.apply(held);

      expect(sent, [SfuTrackType.video, SfuTrackType.video]);
      expect(held.mediaStream, same(output));
      expect(restored.mediaTrack, same(capture.mediaTrack));
      expect(restored.capturedStream, isNull);
      expect(log, [
        'replace apply cam-1',
        'send',
        'send',
        'replace stop chainChanged',
      ]);
    });

    test('in place does not send a new stream', () async {
      var sent = 0;
      filters.onOutputChanged = (_) async {
        sent++;
        return const Result.success(none);
      };
      await filters.apply(camera('cam-1'));

      await filters.setVideoFilter(_LoggingFilter('blur', log));

      expect(sent, 0);
    });

    test('keeps the old chain when the new stream cannot be sent', () async {
      filters.onOutputChanged = (_) async => failureWithError('not sent');
      final capture = camera('cam-1');
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(capture);

      final result = await filters.setVideoFilter(
        _ReplacingFilter(_stream('out', 'video'), log),
      );
      final held = await filters.apply(capture);

      expect(result.isFailure, isTrue);
      expect(held.mediaStream, same(capture.mediaStream));
      expect(filters.videoFilter, isA<_LoggingFilter>());
      expect(log, [
        'blur apply cam-1 camera',
        'replace apply cam-1',
        'replace stop rejected',
      ]);
    });

    test('overlapping with another whose stream cannot be sent either keeps '
        'the old chain', () async {
      filters.onOutputChanged = (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return failureWithError('not sent');
      };
      final capture = camera('cam-1');
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(capture);

      final results = await Future.wait([
        filters.setVideoFilter(
          _ReplacingFilter(_stream('out-1', 'video'), log),
        ),
        filters.setVideoFilter(
          _ReplacingFilter(_stream('out-2', 'video'), log),
        ),
      ]);
      final held = await filters.apply(capture);

      expect(results.every((result) => result.isFailure), isTrue);
      expect(held.mediaStream, same(capture.mediaStream));
      expect(log, [
        'blur apply cam-1 camera',
        'replace apply cam-1',
        'replace stop rejected',
        'replace apply cam-1',
        'replace stop rejected',
      ]);
    });

    test('a failed change queued behind another keeps the filter of the one '
        'before it', () async {
      final blur = _LoggingFilter('blur', log);
      await filters.apply(camera('cam-1'));

      // The first change holds the lock, so the other two wait for it.
      final results = await Future.wait([
        filters.setVideoFilter(_LoggingFilter('image', log)),
        filters.setVideoFilter(blur),
        filters.setVideoFilter(_FailingFilter()),
      ]);

      expect(results[1].isSuccess, isTrue);
      expect(results[2].isFailure, isTrue);
      expect(filters.videoFilter, same(blur));
    });

    test(
      'a capture during a rejected change runs the previous filter',
      () async {
        final blur = _LoggingFilter('blur', log);
        await filters.setVideoFilter(blur);
        await filters.apply(camera('cam-1'));

        final changing = filters.setVideoFilter(_FailingFilter());
        final next = filters.apply(camera('cam-2'));
        await changing;
        await next;

        expect(filters.videoFilter, same(blur));
        expect(log.last, 'blur apply cam-2 camera');
      },
    );

    test('a send that fails after the capture is released reverts the '
        'filter', () async {
      final sending = Completer<Result<None>>();
      filters.onOutputChanged = (_) => sending.future;
      final blur = _LoggingFilter('blur', log);
      final capture = camera('cam-1');
      await filters.setVideoFilter(blur);
      await filters.apply(capture);

      final changing = filters.setVideoFilter(
        _ReplacingFilter(_stream('out', 'video'), log),
      );
      await pumpEventQueue();
      await filters.release(capture);
      sending.complete(failureWithError('not sent'));

      expect((await changing).isFailure, isTrue);
      expect(filters.videoFilter, same(blur));
    });

    test('keeps the old chain when the moderation filter fails', () async {
      final capture = camera('cam-1');
      final moderation = _FlakyFilter('mod', log);
      await filters.setModerationFilter(moderation);
      await filters.apply(capture);
      moderation.fails = true;

      final result = await filters.setVideoFilter(_LoggingFilter('img', log));
      await filters.setModerationFilter(null);

      expect(result.isFailure, isTrue);
      expect(filters.videoFilter, isNull);
      expect(log, [
        'mod apply cam-1 camera',
        'img apply cam-1 camera',
        'img stop cam-1 rejected',
        'mod stop cam-1 chainChanged',
      ]);
    });

    test('after the capture is released waits for the next one', () async {
      final capture = camera('cam-1');
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(capture);

      await filters.release(capture);
      final result = await filters.setVideoFilter(_LoggingFilter('img', log));

      expect(result, const Result.success(LocalFilterChange.deferred));
      expect(log, [
        'blur apply cam-1 camera',
        'blur stop cam-1 captureReleased',
      ]);
    });
  });

  group('the moderation filter', () {
    test('runs after the app filter', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.setModerationFilter(_LoggingFilter('mod', log));

      await filters.apply(camera('cam-1'));

      expect(log, ['blur apply cam-1 camera', 'mod apply cam-1 camera']);
    });

    test('applies when only the app filter fails', () async {
      await filters.setVideoFilter(_FailingFilter());
      await filters.apply(camera('cam-1'));

      final result = await filters.setModerationFilter(
        _LoggingFilter('mod', log),
      );

      expect(result, const Result.success(LocalFilterChange.applied));
      expect(log, ['mod apply cam-1 camera']);
    });

    test('leaves the app filter applied once removed', () async {
      await filters.setVideoFilter(_LoggingFilter('blur', log));
      await filters.apply(camera('cam-1'));
      await filters.setModerationFilter(_LoggingFilter('mod', log));
      log.clear();

      await filters.setModerationFilter(null);

      expect(log, [
        'blur apply cam-1 camera',
        'mod stop cam-1 chainChanged',
        'blur stop cam-1 chainChanged',
      ]);
    });

    test('keeps a filter picked while it is on', () async {
      await filters.apply(camera('cam-1'));
      await filters.setModerationFilter(_LoggingFilter('mod', log));
      await filters.setVideoFilter(_LoggingFilter('image', log));

      await filters.setModerationFilter(null);

      expect(filters.videoFilter, isA<_LoggingFilter>());
      expect(filters.moderationFilter, isNull);
    });

    test('with a replacing app filter runs on its output', () async {
      final output = _stream('out', 'video');
      await filters.setVideoFilter(_ReplacingFilter(output, log));
      await filters.setModerationFilter(_LoggingFilter('mod', log));

      final sent = await filters.apply(camera('cam-1'));

      expect(log, ['replace apply cam-1', 'mod apply out camera']);
      expect(sent.mediaStream, same(output));
    });
  });

  group('the audio processor filter', () {
    test('runs after the app filter', () async {
      filters = LocalMediaFilters(
        audioProcessorFilter: () => _LoggingAudioFilter('nc', log),
      );
      await filters.setAudioFilter(_LoggingAudioFilter('app', log));

      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      expect(log, ['app apply mic microphone', 'nc apply mic microphone']);
    });

    test('that throws leaves the rest of the chain applied', () async {
      filters = LocalMediaFilters(
        audioProcessorFilter: () => throw Exception('no filter'),
      );
      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      final result = await filters.setAudioFilter(
        _LoggingAudioFilter('app', log),
      );

      expect(result, const Result.success(LocalFilterChange.applied));
      expect(log, ['app apply mic microphone']);
    });
  });

  group('the audio processor filter', () {
    test('runs on the microphone after the app filter', () async {
      filters = LocalMediaFilters(
        audioProcessorFilter: () => _LoggingAudioFilter('nc', log),
      );
      await filters.setAudioFilter(_LoggingAudioFilter('app', log));

      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      expect(log, ['app apply mic', 'nc apply mic']);
    });

    test('is left out when the processor has none', () async {
      filters = LocalMediaFilters(audioProcessorFilter: () => null);
      await filters.setAudioFilter(_LoggingAudioFilter('app', log));

      await filters.apply(_track('mic', SfuTrackType.audio, 'audio'));

      expect(log, ['app apply mic']);
    });

    test('does not run on the camera', () async {
      filters = LocalMediaFilters(
        audioProcessorFilter: () => _LoggingAudioFilter('nc', log),
      );

      await filters.apply(camera('cam-1'));

      expect(log, isEmpty);
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

    expect(log, [
      'blur stop cam-1 captureReleased',
      'nc stop mic captureReleased',
      'blur apply cam-1 camera',
    ]);
  });

  test('a failing stop is logged and the next capture still applies', () async {
    final logger = installRecordingLogger();
    await filters.setVideoFilter(_FailingStopFilter(log));

    await filters.apply(camera('cam-1'));
    await filters.apply(camera('cam-2'));

    expect(log, ['apply cam-1', 'apply cam-2']);
    expect(logger.warnings, [contains('stop')]);
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

rtc.MediaStream _stream(String trackId, String kind) {
  return _FakeStream([FakeMediaStreamTrack(trackId, kind: kind)]);
}

String _firstTrackId(rtc.MediaStream stream) => stream.getTracks().first.id!;

final class _LoggingFilter extends VideoFilter {
  _LoggingFilter(this.name, this.log);

  final String name;
  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    final id = _firstTrackId(input.stream);
    log.add('$name apply $id ${input.source.name}');
    return MediaStreamFilterResult(
      input.stream,
      stop: (details) => log.add('$name stop $id ${details.reason.name}'),
    );
  }
}

final class _LoggingAudioFilter extends AudioFilter {
  _LoggingAudioFilter(this.name, this.log);

  final String name;
  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    final id = _firstTrackId(input.stream);
    log.add('$name apply $id ${input.source.name}');
    return MediaStreamFilterResult(
      input.stream,
      stop: (details) => log.add('$name stop $id ${details.reason.name}'),
    );
  }
}

final class _ReplacingFilter extends VideoFilter {
  _ReplacingFilter(this.output, this.log);

  final rtc.MediaStream output;
  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    log.add('replace apply ${_firstTrackId(input.stream)}');
    return MediaStreamFilterResult(
      output,
      stop: (details) => log.add('replace stop ${details.reason.name}'),
    );
  }
}

final class _FailingFilter extends VideoFilter {
  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    throw Exception('filter failed');
  }
}

final class _FlakyFilter extends VideoFilter {
  _FlakyFilter(this.name, this.log);

  final String name;
  final List<String> log;
  bool fails = false;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    if (fails) throw Exception('$name failed');
    final id = _firstTrackId(input.stream);
    log.add('$name apply $id ${input.source.name}');
    return MediaStreamFilterResult(
      input.stream,
      stop: (details) => log.add('$name stop $id ${details.reason.name}'),
    );
  }
}

final class _FailingStopFilter extends VideoFilter {
  _FailingStopFilter(this.log);

  final List<String> log;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    log.add('apply ${_firstTrackId(input.stream)}');
    return MediaStreamFilterResult(
      input.stream,
      stop: (_) => throw Exception('stop failed'),
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
