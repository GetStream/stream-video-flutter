// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video_filters/src/video_effect_registry.dart';
import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_filters/stream_video_filters_platform_interface.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String> attached;

  setUp(() {
    StreamVideoFiltersPlatform.instance = _FakeFiltersPlatform();
    VideoEffectRegistry.reset();
    attached = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('FlutterWebRTC.Method'), (
          call,
        ) async {
          if (call.method == 'setVideoEffects') {
            final args = call.arguments as Map;
            attached.add(
              '${args['trackId']}: ${(args['names'] as List).join(',')}',
            );
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('FlutterWebRTC.Method'),
          null,
        );
  });

  test('stop detaches the blur from the track', () async {
    final result = await const FullFrameBlurFilter().apply(_input('cam-1'));

    await result.stop!(_stopDetails);

    expect(attached, ['cam-1: FullFrameBlur', 'cam-1: ']);
  });

  test('a late stop of a replaced blur keeps the new one', () async {
    const blur = FullFrameBlurFilter();
    final old = await blur.apply(_input('cam-1'));
    await blur.apply(_input('cam-1'));

    await old.stop!(_stopDetails);

    expect(attached.last, 'cam-1: FullFrameBlur');
  });
}

MediaStreamFilterInput _input(String trackId) => MediaStreamFilterInput(
  stream: _FakeStream([_FakeTrack(trackId)]),
  source: MediaStreamFilterSource.camera,
);

const _stopDetails = MediaStreamFilterStopDetails(
  reason: MediaStreamFilterStopReason.chainChanged,
);

class _FakeFiltersPlatform extends StreamVideoFiltersPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<void> registerFullFrameBlurEffectProcessor() async {}
}

class _FakeTrack extends Fake implements MediaStreamTrack {
  _FakeTrack(this.id);

  @override
  final String id;
}

class _FakeStream extends Fake implements MediaStream {
  _FakeStream(this._tracks);

  final List<MediaStreamTrack> _tracks;

  @override
  List<MediaStreamTrack> getVideoTracks() => _tracks;
}
