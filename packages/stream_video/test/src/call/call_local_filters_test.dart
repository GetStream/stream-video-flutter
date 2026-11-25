import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import '../webrtc/fixtures/rtc_manager_fakes.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

typedef _Capture =
    Future<RtcLocalTrack> Function(
      RtcLocalTrack track, {
      bool Function()? isCurrent,
    });

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(SfuTrackType.video);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  late MockCallSession session;
  late MutableSharedEmitter<StreamVideoEvent> events;

  setUp(() {
    session = setupMockCallSession();
    events = MutableSharedEmitter<StreamVideoEvent>();
    when(
      () => session.refilterLocalTrack(any()),
    ).thenAnswer((_) async => const Result.success(none));
  });

  Future<(Call, _Capture)> joinedCall({
    VideoModerationConfig config = const VideoModerationConfig.disabled(),
  }) async {
    final call = createTestCall(
      coordinatorClient: setupMockCoordinatorClient(events: events),
      sessionFactory: setupMockSessionFactory(callSession: session),
      streamVideo: setupMockCallHost(),
    );
    call.updateCallPreferences(
      DefaultCallPreferences(videoModerationConfig: config),
    );
    await call.join();

    final capture =
        verify(
              () => session.onLocalCapture = captureAny(),
            ).captured.last
            as _Capture;
    verify(() => session.onLocalCaptureReleased = any()).called(1);
    return (call, capture);
  }

  test('the session filters a published camera with the call chain', () async {
    final filter = _RecordingFilter();
    final (call, capture) = await joinedCall();
    await call.setVideoFilter(filter);

    await capture(fakeCameraTrack('cam'));

    expect(filter.attached, 1);
  });

  test('a lobby preview is published without being filtered again', () async {
    final filter = _RecordingFilter();
    final call = createTestCall(
      coordinatorClient: setupMockCoordinatorClient(events: events),
      sessionFactory: setupMockSessionFactory(callSession: session),
      streamVideo: setupMockCallHost(),
    );
    await call.setVideoFilter(filter);
    final preview = await call.applyLocalFilters(fakeCameraTrack('cam'));
    await call.join();
    final capture =
        verify(
              () => session.onLocalCapture = captureAny(),
            ).captured.last
            as _Capture;

    final published = await capture(preview);

    expect(filter.attached, 1);
    expect(filter.applied, 1);
    expect(published.mediaTrack, same(preview.mediaTrack));
  });

  test('a blur event blurs the published camera', () async {
    var applied = 0;
    final blur = _RecordingFilter();
    final (call, capture) = await joinedCall(
      config: VideoModerationConfig(filter: blur, onApply: () => applied++),
    );
    await capture(fakeCameraTrack('cam'));

    events.emit(
      StreamCallModerationBlurEvent(
        call.callCid,
        createdAt: DateTime.now(),
        userId: SampleCallData.defaultCallUser.id,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(blur.attached, 1);
    expect(applied, 1);
    verifyNever(() => session.refilterLocalTrack(any()));
  });

  test('a filter replacing the published stream is sent', () async {
    final (call, capture) = await joinedCall();
    await capture(fakeCameraTrack('cam'));

    final result = await call.setVideoFilter(_ReplacingFilter());

    expect(result.isSuccess, isTrue);
    verify(() => session.refilterLocalTrack(SfuTrackType.video)).called(1);
  });
}

final class _RecordingFilter extends VideoFilter {
  int attached = 0;
  int applied = 0;

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    applied++;
    attached++;
    return MediaStreamFilterResult(input.stream, stop: (_) => attached--);
  }
}

final class _ReplacingFilter extends VideoFilter {
  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    return MediaStreamFilterResult(
      FakeMediaStream([FakeMediaStreamTrack('out', kind: 'video')]),
    );
  }
}
