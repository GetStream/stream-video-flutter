import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_video_moderation.dart';
import 'package:stream_video/src/call/media/local_media_filters.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../logger/impl/test_logger.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  final currentUserId = SampleCallData.defaultCallUser.id;

  late CallStateNotifier stateManager;
  late CallVideoModeration moderation;
  late List<String> toggles;
  late List<VideoFilter?> moderationFilters;

  void setUpModeration(
    VideoModerationConfig config, {
    Result<None> microphoneResult = const Result.success(none),
    Result<None> cameraResult = const Result.success(none),
    Result<LocalFilterChange> filterResult = const Result.success(
      LocalFilterChange.applied,
    ),
  }) {
    toggles = [];
    moderationFilters = [];
    stateManager = CallStateNotifier(
      createActiveCallState().copyWith(
        preferences: DefaultCallPreferences(videoModerationConfig: config),
      ),
    );
    moderation = CallVideoModeration(
      stateManager: stateManager,
      currentUserId: () => currentUserId,
      setMicrophoneEnabled: ({required enabled}) async {
        toggles.add('microphone: $enabled');
        return microphoneResult;
      },
      setCameraEnabled: ({required enabled}) async {
        toggles.add('camera: $enabled');
        return cameraResult;
      },
      setModerationFilter: (filter) async {
        moderationFilters.add(filter);
        return filterResult;
      },
      logger: taggedLogger(tag: 'SV:CallVideoModerationTest'),
    );
  }

  StreamCallModerationBlurEvent blur({String? userId}) {
    return StreamCallModerationBlurEvent(
      SampleCallData.defaultCid,
      createdAt: DateTime.now(),
      userId: userId ?? currentUserId,
    );
  }

  group('muting', () {
    test('a muting blur turns the microphone and camera off', () async {
      setUpModeration(const VideoModerationConfig.mute());

      await moderation.onBlur(blur());

      expect(toggles, ['microphone: false', 'camera: false']);
    });

    for (final track in ['microphone', 'camera']) {
      test(
        'a failed $track mute is logged and the moderation still applies',
        () async {
          final logger = installRecordingLogger();
          var applied = false;
          final failure = failureWithError<None>('Session is null');
          setUpModeration(
            VideoModerationConfig(
              muteAudio: true,
              muteVideo: true,
              onApply: () => applied = true,
            ),
            microphoneResult: track == 'microphone'
                ? failure
                : const Result.success(none),
            cameraResult: track == 'camera'
                ? failure
                : const Result.success(none),
          );

          await moderation.onBlur(blur());

          expect(logger.warnings, [contains(track)]);
          expect(toggles, ['microphone: false', 'camera: false']);
          expect(stateManager.callState.isVideoModerated, isTrue);
          expect(applied, isTrue);
        },
      );
    }

    test('a blur-only config leaves the microphone and camera alone', () async {
      setUpModeration(const VideoModerationConfig.blur(filter: _blur));

      await moderation.onBlur(blur());

      expect(toggles, isEmpty);
    });

    test('a blur for another user mutes nothing', () async {
      setUpModeration(const VideoModerationConfig.mute());

      await moderation.onBlur(blur(userId: 'someone-else'));

      expect(toggles, isEmpty);
      expect(stateManager.callState.isVideoModerated, isFalse);
    });

    test('a disabled config mutes nothing', () async {
      setUpModeration(const VideoModerationConfig.disabled());

      await moderation.onBlur(blur());

      expect(toggles, isEmpty);
      expect(stateManager.callState.isVideoModerated, isFalse);
    });
  });

  group('blur filter', () {
    test('a blur sets the moderation filter', () async {
      setUpModeration(const VideoModerationConfig.blur(filter: _blur));

      await moderation.onBlur(blur());

      expect(moderationFilters, [_blur]);
    });

    test('clearing the blur removes the moderation filter', () async {
      setUpModeration(const VideoModerationConfig.blur(filter: _blur));

      await moderation.onBlur(blur());
      moderation.clear();
      await Future<void>.delayed(Duration.zero);

      expect(moderationFilters, [_blur, null]);
    });

    test('a blur that fails turns the camera off', () async {
      final logger = installRecordingLogger();
      var applied = 0;
      setUpModeration(
        VideoModerationConfig(filter: _blur, onApply: () => applied++),
        filterResult: failureWithError('blur failed'),
      );

      await moderation.onBlur(blur());

      expect(toggles, ['camera: false']);
      expect(logger.errors, [contains('blur failed')]);
      expect(applied, 1);
    });

    test('a blur that fails while the camera cannot turn off', () async {
      final logger = installRecordingLogger();
      var applied = 0;
      setUpModeration(
        VideoModerationConfig(filter: _blur, onApply: () => applied++),
        filterResult: failureWithError('blur failed'),
        cameraResult: failureWithError('camera stuck'),
      );

      await moderation.onBlur(blur());

      expect(toggles, ['camera: false']);
      expect(logger.errors, [
        contains('blur failed'),
        contains('camera stuck'),
      ]);
      expect(applied, 0);
    });

    test('a blur with no camera capture keeps the camera off', () async {
      setUpModeration(
        const VideoModerationConfig.blur(filter: _blur),
        filterResult: const Result.success(LocalFilterChange.deferred),
      );

      await moderation.onBlur(blur());

      expect(toggles, ['camera: false']);
    });

    test('a clear while muting leaves no blur behind', () async {
      final cameraMuted = Completer<Result<None>>();
      setUpModeration(
        const VideoModerationConfig(muteVideo: true, filter: _blur),
      );
      moderation = CallVideoModeration(
        stateManager: stateManager,
        currentUserId: () => currentUserId,
        setMicrophoneEnabled: ({required enabled}) async =>
            const Result.success(none),
        setCameraEnabled: ({required enabled}) => cameraMuted.future,
        setModerationFilter: (filter) async {
          moderationFilters.add(filter);
          return const Result.success(LocalFilterChange.applied);
        },
        logger: taggedLogger(tag: 'SV:CallVideoModerationTest'),
      );

      final blurring = moderation.onBlur(blur());
      moderation.clear();
      cameraMuted.complete(const Result.success(none));
      await blurring;

      expect(moderationFilters, isEmpty);
      expect(stateManager.callState.isVideoModerated, isFalse);
    });

    test('a config without a blur filter sets none', () async {
      setUpModeration(const VideoModerationConfig.mute());

      await moderation.onBlur(blur());
      moderation.clear();
      await Future<void>.delayed(Duration.zero);

      expect(moderationFilters, isEmpty);
    });
  });

  group('timed clear', () {
    const duration = Duration(seconds: 10);

    test('a second blur restarts the timed clear', () {
      fakeAsync((async) {
        setUpModeration(
          const VideoModerationConfig.blur(filter: _blur, duration: duration),
        );

        moderation.onBlur(blur());
        async.elapse(duration ~/ 2);
        moderation.onBlur(blur());
        async.elapse(duration ~/ 2 + const Duration(milliseconds: 1));

        expect(stateManager.callState.isVideoModerated, isTrue);

        async.elapse(duration ~/ 2);

        expect(stateManager.callState.isVideoModerated, isFalse);
      });
    });

    test('cancelTimer stops a pending timed clear', () {
      fakeAsync((async) {
        setUpModeration(
          const VideoModerationConfig.blur(filter: _blur, duration: duration),
        );

        moderation.onBlur(blur());
        async.flushMicrotasks();
        moderation.cancelTimer();
        async.elapse(duration * 2);

        expect(stateManager.callState.isVideoModerated, isTrue);
      });
    });
  });
}

const _blur = _FakeVideoFilter();

final class _FakeVideoFilter extends VideoFilter {
  const _FakeVideoFilter();

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    return MediaStreamFilterResult(input.stream);
  }
}
