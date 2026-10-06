import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_video_moderation.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  final currentUserId = SampleCallData.defaultCallUser.id;

  late CallStateNotifier stateManager;
  late CallVideoModeration moderation;
  late List<String> toggles;

  void setUpModeration(VideoModerationConfig config) {
    toggles = [];
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
        return const Result.success(none);
      },
      setCameraEnabled: ({required enabled}) async {
        toggles.add('camera: $enabled');
        return const Result.success(none);
      },
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

    test('a blur-only config leaves the microphone and camera alone', () async {
      setUpModeration(const VideoModerationConfig.blur());

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

  group('timed clear', () {
    const duration = Duration(seconds: 10);

    test('a second blur restarts the timed clear', () {
      fakeAsync((async) {
        setUpModeration(const VideoModerationConfig.blur(duration: duration));

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
        setUpModeration(const VideoModerationConfig.blur(duration: duration));

        moderation.onBlur(blur());
        async.flushMicrotasks();
        moderation.cancelTimer();
        async.elapse(duration * 2);

        expect(stateManager.callState.isVideoModerated, isTrue);
      });
    });
  });
}
